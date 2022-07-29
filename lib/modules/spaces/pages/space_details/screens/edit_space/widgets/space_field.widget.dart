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

import 'package:demos_app/config/custom-icons/demos_icons_icons.dart';
import 'package:demos_app/config/themes/main_theme.dart';
import 'package:demos_app/modules/spaces/validators/is_current_user_admin.widget_validator.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/safe_widget_validator.dart';
import 'package:flutter/material.dart';

class SpaceField extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onEdit;

  const SpaceField(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: primaryColorLight,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        leading: Icon(
          icon,
          size: 36,
          color: primaryColorLight,
        ),
        trailing: SafeWidgetValidator(
          validators: [IsCurrentUserAdminWidgetValidator()],
          child: IconButton(
            icon: const Icon(
              DemosIcons.pencil,
              color: secondaryColorDark,
            ),
            onPressed: onEdit,
          ),
        ),
        horizontalTitleGap: 6,
        shape: const Border(
          bottom: BorderSide(
            color: primaryColorLight,
            width: 0.2,
          ),
        ),
      ),
    );
  }
}
