/*
  DEMOS
  Copyright (C) 2022 Julian Alejandro Ortega Zepeda, Erik Ivanov Domínguez Rivera, Luis Ángel Meza Acosta
  This file is part of DEMOS.

  DEMOS is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  DEMOS is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:demos_app/core/api/member.api.dart';
import 'package:demos_app/core/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:demos_app/modules/spaces/bloc/spaces/spaces_bloc.dart';
import 'package:demos_app/core/enums/invitation-status.enum.dart';
import 'package:demos_app/core/enums/space_role.enum.dart';
import 'package:demos_app/core/models/errors/invalid_invitation_status.error.dart';
import 'package:demos_app/core/models/errors/invitation_expired.error.dart';
import 'package:demos_app/core/models/responses/accept_invitation_response.model.dart';
import 'package:demos_app/core/models/responses/invitation_response.model.dart';
import 'package:demos_app/core/models/responses/member_response.model.dart';
import 'package:demos_app/core/models/responses/send_invitations_response.model.dart';
import 'package:demos_app/core/models/member.model.dart';
import 'package:demos_app/core/models/user.model.dart';
import 'package:demos_app/core/repositories/spaces.repository.dart';
import 'package:demos_app/core/repositories/members.repository.dart';
import 'package:demos_app/core/repositories/users.repository.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/invitations/models/invitation_contact.model.dart';

class MemberService {
  Future<List<Member>> sendInvitations(
      String spaceId, List<InvitationContact> contacts) async {
    SendInvitationsResponse response =
        await MemberApi().sendInvitations(spaceId, contacts);

    for (final member in response.members) {
      await MembersRepository().insertOrUpdate(member);
    }

    return response.members;
  }

  Future<void> acceptInvitation(String spaceId) async {
    try {
      AcceptInvitationResponse response =
          await MemberApi().acceptInvitation(spaceId);

      await SpacesRepository().updateSpace(response.space);

      for (final member in response.members) {
        await MembersRepository().insertOrUpdate(member);
      }

      for (final user in response.users) {
        await UsersRepository().insertOrUpdate(user);
      }
    } catch (err) {
      if (err == InvitationExpiredError() ||
          err == InvalidInvitationStatusError()) {
        await removeInvitationForExpiration(spaceId);
      }
      rethrow;
    }
  }

  Future<Member?> rejectInvitation(String spaceId) async {
    InvitationResponse response = await MemberApi().rejectInvitation(spaceId);

    await MembersRepository().update(response.member);

    return response.member;
  }

  Future<void> getMember(String spaceId, String memberId) async {
    MemberResponse response = await MemberApi().getMember(spaceId, memberId);

    await MembersRepository().insertOrUpdate(response.member);

    await UsersRepository().insertOrUpdate(response.user);
  }

  Future<void> updateMember(
      String spaceId, String memberId, String? name, SpaceRole role) async {
    await MemberApi().updateMember(spaceId, memberId, name, role);
  }

  Future<void> cancelInvitation(String memberId) async {
    Member? member = await MembersRepository().findById(memberId);

    member!.invitationStatus = InvitationStatus.canceled;

    await MembersRepository().insertOrUpdate(member);
  }

  Future<void> removeMembership(String memberId, String spaceId) async {
    Member? member = await MembersRepository().findById(memberId);

    member!.deleted = true;

    await MembersRepository().update(member);
  }

  Future<void> leaveSpace(String spaceId) async {
    await MemberApi().leaveSpace(spaceId);

    User? user = CurrentUserBloc().state;
    Member? member = await MembersRepository()
        .findByUserIdAndSpaceIdAndInvitationStatusAccepted(
            user!.userId!, spaceId);

    member!.deleted = true;

    await MembersRepository().update(member);

    SpacesBloc().add(LoadSpacesEvent());
  }

  Future<List<Member>> getRepresentatives(String spaceId) async {
    return await MembersRepository().findRepresentativesBySpaceId(spaceId);
  }

  Future<List<Member>> getAdministrators(String spaceId) async {
    return await MembersRepository().findAdministratorsBySpaceId(spaceId);
  }

  Future<void> removeInvitationForExpiration(String spaceId) async {
    User? user = CurrentUserBloc().state;

    List<InvitationStatus> invitationStatus = [
      InvitationStatus.received,
      InvitationStatus.sended
    ];
    Member? member = await MembersRepository()
        .findByUserIdAndSpaceIdAndInvitationStatuses(
            user!.userId!, spaceId, invitationStatus);
    if (member != null) {
      member.invitationStatus = InvitationStatus.expired;
      await MembersRepository().update(member);
    }
  }
}
