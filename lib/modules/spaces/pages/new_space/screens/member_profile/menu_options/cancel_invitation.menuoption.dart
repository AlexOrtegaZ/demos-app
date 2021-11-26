import 'package:demos_app/shared/interfaces/menu_option.interface.dart';
import 'package:flutter/material.dart';

class CancelInvitationMenuOption implements MenuOption {
  String name = 'Cancelar Invitación';

  IconData icon = Icons.cancel;

  @override
  void Function(BuildContext context) onTap = (context) { };
}
