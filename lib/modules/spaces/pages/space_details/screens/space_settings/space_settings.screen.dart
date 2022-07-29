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
import 'package:demos_app/modules/spaces/models/space_view.model.dart';
import 'package:demos_app/modules/spaces/services/member.service.dart';
import 'package:demos_app/shared/services/date_formatter.service.dart';
import 'package:demos_app/utils/ui/modals/open_confirmation_dialog.dart';
import 'package:demos_app/widgets/general/card.widget.dart';
import 'package:flutter/material.dart';
import 'package:demos_app/config/routes/routes.dart';
import 'package:demos_app/modules/spaces/pages/space_details/screens/space_settings/widgets/setting_items.widget.dart';
import 'package:demos_app/modules/spaces/pages/space_details/bloc/space.bloc.dart';
import 'package:demos_app/widgets/simbols/powered_by_migala.dart';
import 'package:demos_app/widgets/tiles/information_tile.widget.dart';
import 'package:demos_app/widgets/space/space_picture.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpaceSettingsScreen extends StatelessWidget {
  const SpaceSettingsScreen({Key? key}) : super(key: key);

  void goToSpacePercentageSettings(BuildContext context) =>
      Navigator.pushNamed(context, Routes.spacePercentage);

  void goToSpaceMembers(BuildContext context) =>
      Navigator.pushNamed(context, Routes.spaceMembers);

  void goToEditSpace(BuildContext context) =>
      Navigator.pushNamed(context, Routes.editSpace);

  void goToSpaces(BuildContext context) =>
      Navigator.of(context).popUntil(ModalRoute.withName(Routes.spaces));

  void leaveSpace(BuildContext context) {
    openConfirmationDialog(context,
        content: '¿Estás seguro que deseas dejar este espacio?',
        accept: () async {
      SpaceView space = SpaceBloc().state;
      await MemberService().leaveSpace(space.spaceId!);
      goToSpaces(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 32,
                right: 16,
                left: 16,
              ),
              child: CardWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      BlocBuilder<SpaceBloc, SpaceView>(
                          bloc: SpaceBloc(),
                          builder: (context, space) {
                            return InformationTile(
                              picture: SpacePicture(
                                width: 64,
                                pictureKey: space.pictureKey,
                              ),
                              name: space.name,
                              subtitle:
                                  'Creado el ${DateFormatterService.parseToStandardDate(space.createdAt)}',
                              onTap: () => goToEditSpace(context),
                            );
                          }),
                      const SizedBox(
                        height: 64,
                        width: 280,
                        child: Divider(
                          thickness: 0.4,
                          color: primaryColorLight,
                        ),
                      ),
                      SettingItem(
                        title: 'Votos',
                        subtitle:
                            'Porcentaje de participación y aprovación de las propuestas',
                        icon: DemosIcons.vote,
                        color: primaryColorLight,
                        colorTitle: primaryColor,
                        onTap: () => goToSpacePercentageSettings(context),
                      ),
                      const SizedBox(height: 12),
                      SettingItem(
                        title: 'Miembros',
                        subtitle: 'Usuarios, invitaciones y roles',
                        icon: DemosIcons.members,
                        color: primaryColorLight,
                        colorTitle: primaryColor,
                        onTap: () => goToSpaceMembers(context),
                      ),
                      SettingItem(
                        title: 'Dejar el Espacio',
                        subtitle: 'Esta opción te removera del espacio',
                        icon: DemosIcons.exit,
                        color: Colors.red,
                        colorTitle: Colors.red,
                        onTap: () => leaveSpace(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: PoweredByMigala(),
          )
        ],
      ),
    );
  }
}
