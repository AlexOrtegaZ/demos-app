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

import 'package:flutter/material.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/safe_widget_validator.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/widget_validator.interface.dart';

class ProfileField extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? child;
  final IconData icon;
  final bool editable;
  final VoidCallback? onEdit;
  final String placeholderPrefix;
  final List<WidgetValidator>? editableButtonValidators;

  const ProfileField(
      {Key? key,
      required this.title,
      required this.icon,
      this.value,
      this.editable = false,
      this.placeholderPrefix = 'Introduce tu',
      this.onEdit,
      this.editableButtonValidators,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return ListTile(
      leading: Container(
        margin: const EdgeInsets.only(top: 6.0),
        child: Icon(icon),
      ),
      trailing: editable
          ? SafeWidgetValidator(
              validators: editableButtonValidators,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: onEdit == null ? Colors.grey : accentColor,
                ),
                onPressed: onEdit,
              ))
          : const SizedBox(
              height: 14,
              width: 14,
            ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      subtitle: child == null
          ? hasValue()
              ? getValueLabel()
              : getWithoutValueLabel()
          : child!,
    );
  }

  bool hasValue() {
    return value != null && value != '';
  }

  Widget getValueLabel() {
    return Text(value ?? '',
        style: const TextStyle(color: Colors.black, fontSize: 18));
  }

  Widget getWithoutValueLabel() {
    return Text('$placeholderPrefix ${title.toLowerCase()}',
        style: const TextStyle(color: Colors.black26, fontSize: 18));
  }
}
