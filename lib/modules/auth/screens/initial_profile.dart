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

import 'package:demos_app/config/routes/routes.dart';
import 'package:demos_app/widgets/profile/profile.widget.dart';
import 'package:flutter/material.dart';

import 'package:demos_app/widgets/buttons/big_button_widget.dart';

class InitialProfile extends StatefulWidget {
  const InitialProfile({Key? key}) : super(key: key);

  @override
  _InitialProfileState createState() => _InitialProfileState();
}

class _InitialProfileState extends State<InitialProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
                textAlign: TextAlign.start,
              ),
              Expanded(
                  child: Profile(
                children: [
                  BigButton(
                    text: 'CONTINUAR',
                    onPressed: goToSpaces,
                  )
                ],
              ))
            ],
          ))),
    );
  }

  void goToSpaces() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.spaces, (r) => false);
  }
}
