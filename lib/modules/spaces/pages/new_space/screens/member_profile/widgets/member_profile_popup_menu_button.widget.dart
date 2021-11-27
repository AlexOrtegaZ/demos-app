import 'package:demos_app/modules/spaces/pages/new_space/screens/member_profile/menu_options/cancel_invitation.menuoption.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/member_profile/menu_options/delete_member.menuoption.dart';
import 'package:demos_app/shared/interfaces/menu_option.interface.dart';
import 'package:demos_app/widgets/general/popup_menu_options.widget.dart';
import 'package:flutter/material.dart';
import 'package:demos_app/modules/spaces/validators/is_current_user_admin.widget_validator.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/safe_widget_validator.dart';

class MemberProfilePopupMenuOptions extends StatelessWidget {
  const MemberProfilePopupMenuOptions(
      {Key? key,
      required this.memberIsInvited,
      required this.spaceId,
      required this.memberId})
      : super(key: key);

  final bool memberIsInvited;
  final String spaceId;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    final MenuOption deleteOrCancelOption = memberIsInvited
        ? CancelInvitationMenuOption(spaceId, memberId)
        : DeleteMemberMenuOption(spaceId, memberId);

    return SafeWidgetValidator(
      validators: [IsCurrentUserAdminWidgetValidator()],
      child: PopupMenuOptions(menuOptions: [deleteOrCancelOption]),
    );
  }
}
