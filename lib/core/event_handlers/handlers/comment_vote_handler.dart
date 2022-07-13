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

import 'package:demos_app/core/interfaces/event.handler.interface.dart';
import 'package:demos_app/core/mixins/event_handler_mixin.dart';
import 'package:demos_app/core/models/cache.model.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/bloc/comment_view_list_bloc.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment_view.service.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment_vote.service.dart';

class CommentVoteHandler extends EventHandlerMixin {
  @override
  String get key => 'comment-votes';

  @override
  final List<EventHandler> eventHandlers = [
    CommentVotePublishedHandler(),
    CommentVoteUpdatedHandler(),
    CommentVoteDeletedHandler()
  ];
}

class CommentVotePublishedHandler extends EventHandler {
  @override
  String get key => 'published';

  @override
  Future<void> handleEvent(Cache dataEvent) async {
    await _handleCommentVoteUpdate(dataEvent);
  }
}

class CommentVoteUpdatedHandler extends EventHandler {
  @override
  String get key => 'updated';

  @override
  Future<void> handleEvent(Cache dataEvent) async {
    await _handleCommentVoteUpdate(dataEvent);
  }
}

class CommentVoteDeletedHandler extends EventHandler {
  @override
  String get key => 'deleted';

  @override
  Future<void> handleEvent(Cache dataEvent) async {
    final String manifestoCommentVoteId =
        dataEvent.data!['manifestoCommentVoteId'];

    await CommentVoteService()
        .deleteCommentVoteFromLocalDb(manifestoCommentVoteId);
  }
}

Future<void> _handleCommentVoteUpdate(Cache dataEvent) async {
  final String spaceId = dataEvent.data!['spaceId'];
  final String manifestoCommentVoteId =
      dataEvent.data!['manifestoCommentVoteId'];

  final commentVote = await CommentVoteService()
      .getCommentVote(spaceId, manifestoCommentVoteId);

  final commentView =
      await CommentViewService().getCommentById(commentVote.manifestoCommentId);

  CommentViewListBloc().add(CommentViewListCommentUpdated(commentView!));
}
