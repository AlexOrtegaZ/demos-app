import 'package:demos_app/modules/proposals/pages/proposal_form/enums/proposal_form_type.enum.dart';
import 'package:demos_app/modules/proposals/pages/proposal_form/interfaces/proposal_form_config.interface.dart';
import 'package:demos_app/modules/proposals/pages/proposal_form/proposal_form_editors/in_progress.proposal_form_editor.dart';
import 'package:demos_app/modules/proposals/pages/proposal_form/proposal_form_editors/new.proposal_form_editor.dart';
import 'package:demos_app/modules/proposals/pages/proposal_form/proposal_form_editors/draft.proposal_form_editor.dart';

ProposalFormConfig getProposalFormEditorFromType(ProposalFormType type) {
  switch (type) {
    case ProposalFormType.newProposal:
      return NewProposalFormEditor();
    case ProposalFormType.draft:
      return DraftProposalFormEditor();
    case ProposalFormType.proposalInProgress:
      return InProgressProposalFormEditor();
  }
}
