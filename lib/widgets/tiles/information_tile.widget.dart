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

import 'package:demos_app/config/themes/main_theme.dart';
import 'package:flutter/material.dart';

class InformationTile extends StatelessWidget {
  const InformationTile({
    Key? key,
    required this.onTap,
    required this.picture,
    required this.subtitle,
    required this.name,
  }) : super(key: key);

  final Widget picture;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ListTile(
        leading: picture,
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: primaryColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: primaryColorLight),
        ),
        visualDensity:
            const VisualDensity(vertical: VisualDensity.maximumDensity),
        minVerticalPadding: 16,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 28),
        horizontalTitleGap: 16,
      ),
    );
  }
}
