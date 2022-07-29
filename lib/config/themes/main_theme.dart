// ignore_for_file: prefer_const_declarations

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

const Color primaryColor = Color(0xFF000033);
const Color primaryColorDark = const Color(0xFF3B4879);
const Color primaryColorLight = Color(0xFFB6BACE);
final Color secondaryColor = const Color(0xFFFFCC00);
const Color secondaryColorDark = Color(0xFFFF9900);
final Color secondaryColorLight = const Color(0xFFFFDF81);

final mainTheme = ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    fontFamily: 'Montserrat',
    tabBarTheme:
        ThemeData.light().tabBarTheme.copyWith(labelColor: Colors.white),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0)),
    textTheme: const TextTheme(
      caption: TextStyle(fontSize: 16.0),
      headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 16.0),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          secondaryContainer: secondaryColorDark,
        ));
