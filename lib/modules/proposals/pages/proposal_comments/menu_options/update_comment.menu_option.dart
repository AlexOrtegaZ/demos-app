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

import 'package:demos_app/modules/proposals/pages/proposal_comments/bloc/comment_view_list_bloc.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/models/comment_view.model.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment.service.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment_view.service.dart';
import 'package:demos_app/modules/spaces/pages/space_details/bloc/space.bloc.dart';
import 'package:demos_app/shared/interfaces/menu_option.interface.dart';
import 'package:demos_app/utils/ui/modals/open_update_string_field_modal.dart';
import 'package:flutter/material.dart';

class UpdateCommentMenuOption implements MenuOption {
  final CommentView comment;

  @override
  IconData icon = Icons.edit;

  @override
  String name = 'Editar';

  UpdateCommentMenuOption(this.comment);

  @override
  void onTap(BuildContext context) async {
    final newContent = await openUpdateStringFieldModal(context,
        title: 'Editar Comentario',
        hintText: comment.content,
        validator: validateContent);

    if (newContent == comment.content) {
      return;
    }

    final spaceId = SpaceBloc().state.spaceId!;
    final manifestoComment = await CommentService()
        .updateComment(spaceId, comment.manifestoCommentId, newContent!);

    final commentView = await CommentViewService()
        .getCommentById(manifestoComment.manifestoCommentId);
    CommentViewListBloc().add(CommentViewListCommentUpdated(commentView!));
  }

  String? validateContent(String? content) {
    if (content == null || content.isEmpty) {
      return 'El contenido no puede estar vacío';
    }

    return null;
  }
}
