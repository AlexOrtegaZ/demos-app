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

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.color,
    this.colorTitle,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final Color? colorTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, size: 32, color: color),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, color: colorTitle),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: color),
        ),
        onTap: onTap,
        // contentPadding: const EdgeInsets.symmetric(horizontal: 28),
        horizontalTitleGap: 8,
        dense: true,
      ),
    );
  }
}
