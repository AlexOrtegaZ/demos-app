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

import 'dart:io';
import 'package:demos_app/config/custom-icons/demos_icons_icons.dart';
import 'package:demos_app/config/themes/main_theme.dart';
import 'package:demos_app/modules/spaces/models/space_view.model.dart';
import 'package:demos_app/modules/spaces/pages/new_space/services/new_space.service.dart';
import 'package:demos_app/modules/spaces/pages/space_details/screens/edit_space/widgets/space_field.widget.dart';
import 'package:demos_app/modules/spaces/pages/space_details/services/space_details.service.dart';
import 'package:demos_app/modules/spaces/pages/space_details/bloc/space.bloc.dart';
import 'package:demos_app/modules/spaces/validators/is_current_user_admin.widget_validator.dart';
import 'package:demos_app/utils/ui/modals/open_update_string_field_modal.dart';
import 'package:demos_app/widgets/general/card.widget.dart';
import 'package:demos_app/widgets/pages/image_editor.page.dart';
import 'package:demos_app/widgets/space/space_picture.widget.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/safe_widget_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSpaceScreen extends StatefulWidget {
  const EditSpaceScreen({Key? key}) : super(key: key);

  @override
  _EditSpaceScreenState createState() => _EditSpaceScreenState();
}

class _EditSpaceScreenState extends State<EditSpaceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceBloc, SpaceView>(
      bloc: SpaceBloc(),
      builder: (context, space) {
        return Scaffold(
          backgroundColor: primaryColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Espacio'),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: SpacePicture(
                      width: 180,
                      pictureKey: space.pictureKey,
                    ),
                  ),
                  SafeWidgetValidator(
                    validators: [IsCurrentUserAdminWidgetValidator()],
                    child: Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                        onPressed: () => onPictureEditPress(space),
                        child: const Icon(
                          DemosIcons.camera,
                          color: primaryColor,
                          size: 32,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 64, right: 16, left: 16, top: 16),
                  child: CardWidget(
                    child: Column(
                      children: [
                        SpaceField(
                          title: 'Nombre',
                          subtitle: space.name,
                          icon: DemosIcons.building,
                          onEdit: () => updateSpaceName(space),
                        ),
                        SpaceField(
                          title: 'Descripción',
                          subtitle: space.description ?? 'Sin descripcion',
                          icon: DemosIcons.info_outlined,
                          onEdit: () => updateSpaceDescription(space),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onPictureEditPress(SpaceView space) async {
    File? imageFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ImageEditorPage(),
        ));
    if (imageFile != null) {
      NewSpaceService().uploadPicture(space.spaceId!, imageFile);
    }
  }

  void updateSpaceName(SpaceView space) async {
    String? newName = await openUpdateStringFieldModal(
      context,
      title: 'Nombre del espacio',
      hintText: 'Introduce un nuevo nombre',
      initialValue: space.name,
    );
    if (newName != null && newName.isNotEmpty && newName != space.name) {
      SpaceDetailsService().updateName(space.spaceId!, newName);
    }
  }

  void updateSpaceDescription(SpaceView space) async {
    String? newDescription = await openUpdateStringFieldModal(
      context,
      title: 'Descripción del espacio',
      hintText: 'Introduce una nueva descripción',
      initialValue: space.description,
      validator: (String? value) {
        if (value != null && value.length > 120) {
          return 'La descripción no puede tener más de 120 caracteres';
        }
        return null;
      },
    );
    if (newDescription != null &&
        newDescription.isNotEmpty &&
        newDescription != space.description) {
      SpaceDetailsService().updateDescription(space.spaceId!, newDescription);
    }
  }
}
