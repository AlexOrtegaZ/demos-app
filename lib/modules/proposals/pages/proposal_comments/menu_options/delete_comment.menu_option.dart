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
import 'package:flutter/material.dart';

class DeleteCommentMenuOption implements MenuOption {
  final CommentView comment;

  @override
  IconData icon = Icons.delete;

  @override
  String name = 'Eliminar';

  DeleteCommentMenuOption(this.comment);

  @override
  void onTap(BuildContext context) async {
    final commentService = CommentService();
    final spaceId = SpaceBloc().state.spaceId!;

    final manifestoComment =
        await commentService.deleteComment(spaceId, comment.manifestoCommentId);

    final commentView = await CommentViewService()
        .getCommentById(manifestoComment.manifestoCommentId);
    CommentViewListBloc().add(CommentViewListCommentUpdated(commentView!));
  }
}
