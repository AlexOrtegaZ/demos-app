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

import 'package:demos_app/core/api/proposal.api.dart';
import 'package:demos_app/core/enums/proposal/proposal_status.enum.dart';
import 'package:demos_app/core/models/responses/proposal_participation_response.model.dart';
import 'package:demos_app/core/models/responses/update_proposal_response.model.dart';
import 'package:demos_app/core/models/responses/proposal_response.dart';
import 'package:demos_app/core/repositories/manifesto/manifesto.repository.dart';
import 'package:demos_app/core/repositories/manifesto/manifesto_option.repository.dart';
import 'package:demos_app/core/repositories/manifesto/proposal/proposal.repository.dart';
import 'package:demos_app/core/repositories/manifesto/proposal/proposal_participation.repository.dart';
import 'package:demos_app/core/repositories/manifesto/proposal/proposal_vote.repository.dart';
import 'package:demos_app/modules/proposals/pages/proposal_form/models/proposal_form_view.model.dart';

class ProposalService {
  Future<void> createNewProposalDraft(
      String spaceId, ProposalFormView proposalFormView) async {
    final response =
        await ProposalApi().createProposalDraft(spaceId, proposalFormView);
    await _saveProposalResponseOnRepository(response);
  }

  Future<void> updateProposalDraft(String spaceId, String proposalId,
      ProposalFormView proposalFormView) async {
    final response = await ProposalApi()
        .updateProposalDraft(spaceId, proposalId, proposalFormView);
    await _saveProposalResponseOnRepository(response);
  }

  Future<void> publishProposalDraft(String spaceId, String proposalId,
      ProposalFormView proposalFormView) async {
    final response = await ProposalApi()
        .publishProposalDraft(spaceId, proposalId, proposalFormView);
    await _saveProposalResponseOnRepository(response);
  }

  Future<void> createAndPublishProposal(
      String spaceId, ProposalFormView proposalFormView) async {
    final response =
        await ProposalApi().createAndPublishProposal(spaceId, proposalFormView);
    await _saveProposalResponseOnRepository(response);
  }

  Future<void> getProposal(String spaceId, String proposalId) async {
    ProposalResponse response =
        await ProposalApi().getProposal(spaceId, proposalId);

    if (response.proposal.status == ProposalStatus.open) {
      await ProposalParticipationRepository().removeByProposalId(proposalId);
    }
    await _saveProposalResponseOnRepository(response);
  }

  Future<void> getProposalParticipation(
      String spaceId, String participationId) async {
    ProposalParticipationResponse response =
        await ProposalApi().getProposalParticipation(spaceId, participationId);

    await ProposalParticipationRepository()
        .insertOrUpdate(response.proposalParticipation);
  }

  Future<void> cancelProposal(String spaceId, String proposalId) async {
    final response = await ProposalApi().cancelProposal(spaceId, proposalId);

    await _saveUpdateProposalResponseOnRepository(response);
  }

  Future<void> deleteProposalDraft(String spaceId, String proposalId) async {
    final response =
        await ProposalApi().deleteProposalDraft(spaceId, proposalId);

    await _saveUpdateProposalResponseOnRepository(response);
  }

  Future<void> updateProposal(String spaceId, String proposalId,
      ProposalFormView proposalFormView) async {
    final response = await ProposalApi()
        .updateProposal(spaceId, proposalId, proposalFormView);

    await ProposalParticipationRepository().removeByProposalId(proposalId);
    await _saveProposalResponseOnRepository(response);
  }

  Future<void> resetProposalVotes(String spaceId, String proposalId) async {
    final response =
        await ProposalApi().resetProposalVotes(spaceId, proposalId);

    await ProposalRepository().insertOrUpdate(response.proposal);
    await ProposalParticipationRepository().removeByProposalId(proposalId);
    for (final participation in response.participations) {
      await ProposalParticipationRepository().insert(participation);
    }
  }

  Future<void> _saveProposalResponseOnRepository(
      ProposalResponse response) async {
    await ManifestoRepository().insertOrUpdate(response.manifesto);
    for (final manifestoOption in response.manifestoOptions) {
      await ManifestoOptionRepository().insertOrUpdate(manifestoOption);
    }
    await ManifestoOptionRepository().removeAllMissingOptions(
        response.manifestoOptions, response.manifesto.manifestoId);
    await ProposalRepository().insertOrUpdate(response.proposal);

    for (final participation in response.participations) {
      await ProposalParticipationRepository().insert(participation);
    }
    for (final vote in response.votes) {
      await ProposalVoteRepository().insert(vote);
    }
  }

  Future<void> _saveUpdateProposalResponseOnRepository(
      UpdateProposalResponse response) async {
    await ProposalRepository().insertOrUpdate(response.proposal);
  }
}
