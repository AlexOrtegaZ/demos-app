import 'package:demos_app/modules/spaces/pages/new_space/screens/member_profile/widgets/participation_counts.widget.dart';
import 'package:flutter/material.dart';
import 'package:demos_app/modules/spaces/validators/is_current_user_admin.widget_validator.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/member_profile/modals/select_role_modal.dart';
import 'package:demos_app/modules/spaces/services/member.service.dart';
import 'package:demos_app/modules/spaces/models/member_view.model.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/member_profile/widgets/member_profile_popup_menu_button.widget.dart';
import 'package:demos_app/widgets/profile/profile_field.widget.dart';
import 'package:demos_app/widgets/profile/profile_picture.widget.dart';
import 'package:demos_app/core/enums/space_role.enum.dart';
import 'package:demos_app/core/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:demos_app/utils/ui/modals/open_update_string_field_modal.dart';
import 'package:demos_app/utils/ui/modals/open_alert_dialog.dart';
import 'package:demos_app/utils/mixins/loading_state_handler.mixin.dart';

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen(this.member, {Key? key}) : super(key: key);

  final MemberView member;

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen>
    with LoadingStateHandler {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          FutureBuilder(
            future: isCurrentUser(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                final isCurrentUser = snapshot.data!;
                if (isCurrentUser) {
                  return Container();
                }

                return MemberProfilePopupMenuOptions(
                    memberIsInvited: widget.member.isInvited,
                    memberId: widget.member.memberId!,
                    spaceId: widget.member.spaceId!);
              }

              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            ProfilePicture(imageKey: widget.member.profilePictureKey),
            Expanded(
              child:
                  ListView(physics: const BouncingScrollPhysics(), children: [
                ProfileField(
                  placeholderPrefix: 'Sin ',
                  title: 'Nombre en el espacio',
                  icon: Icons.person,
                  value: widget.member.currentMemberName,
                  editable: !widget.member.isInvited,
                  onEdit: isLoading ? null : openUpdateNameModal,
                  editableButtonValidators: [
                    IsCurrentUserAdminWidgetValidator()
                  ],
                ),
                ProfileField(
                  title: 'Teléfono',
                  icon: Icons.phone,
                  value: widget.member.phoneNumberFormatted,
                ),
                ProfileField(
                  title: 'Rol',
                  icon: Icons.manage_accounts,
                  value: getSpaceRoleName(widget.member.role),
                  editable: !widget.member.isInvited,
                  onEdit: isLoading ? null : openUpdateRoleModel,
                  editableButtonValidators: [
                    IsCurrentUserAdminWidgetValidator()
                  ],
                ),
                ProfileField(
                  title: 'Propuestas',
                  icon: Icons.how_to_vote,
                  child: ParticipationCounts(created: widget.member.proposalCreatedCount, votes: widget.member.proposalVotedCount),
                  onEdit: isLoading ? null : openUpdateRoleModel,
                ),
                widget.member.isInvited
                    ? ProfileField(
                        placeholderPrefix: '',
                        title: 'La invitacion expira el',
                        icon: Icons.calendar_today,
                        value: widget.member.invitationExpiredAtFormatted,
                      )
                    : ProfileField(
                        title: 'Miembro desde',
                        icon: Icons.calendar_today,
                        value: widget.member.memberCreatedAtFormatted,
                      )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isCurrentUser() async {
    final currentUser = CurrentUserBloc().state;
    if (currentUser == null) return false;

    return widget.member.userId == currentUser.userId;
  }

  void openUpdateNameModal() async {
    String? newName = await openUpdateStringFieldModal(context,
        title: 'Nombre en el espacio',
        hintText: 'Introduce el nuevo nombre',
        initialValue: widget.member.memberName);
    bool isNewNameValid =
        widget.member.memberName != newName && newName != null;

    if (isNewNameValid) {
      updateMemberName(newName);
    }
  }

  void updateMemberName(String newName) {
    wrapLoadingTransaction(() async {
      await MemberService().updateMember(widget.member.spaceId!,
          widget.member.memberId!, newName, widget.member.role!);
      setState(() {
        widget.member.memberName = newName;
      });
    });
  }

  void openUpdateRoleModel() async {
    if (widget.member.role == SpaceRole.admin) {
      final admins =
          await MemberService().getAdministrators(widget.member.spaceId!);

      final existsAnotherAdministrator = admins.length > 1;
      if (!existsAnotherAdministrator) {
        await openAlertDialog(context,
            title: 'No es posible actualizar él rol',
            content:
                'Es requerido tener al menos un administrador dentro del espacio.');
        return;
      }
    }

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SelectRoleModal(
            updateRole: updateRole, currentRole: widget.member.role!);
      },
    );
  }

  void updateRole(SpaceRole newRole) {
    wrapLoadingTransaction(() async {
      if (newRole != widget.member.role) {
        await MemberService().updateMember(widget.member.spaceId!,
            widget.member.memberId!, widget.member.memberName, newRole);
        setState(() {
          widget.member.role = newRole;
        });
      }
    });
  }
}
