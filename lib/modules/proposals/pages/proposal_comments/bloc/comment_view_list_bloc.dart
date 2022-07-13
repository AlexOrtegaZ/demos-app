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

import 'package:bloc/bloc.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/models/comment_view.model.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment_view.service.dart';
import 'package:equatable/equatable.dart';

part 'comment_view_list_event.dart';
part 'comment_view_list_state.dart';

class CommentViewListBloc
    extends Bloc<CommentViewListEvent, CommentViewListState> {
  static final _commentViewListBloc = CommentViewListBloc._internal();
  factory CommentViewListBloc() => _commentViewListBloc;
  CommentViewListBloc._internal() : super(CommentViewListLoadingInProgress()) {
    on<CommentViewListLoaded>(_onListLoaded);
    on<CommentViewListUserCommented>(_onUserCommeted);
    on<CommentViewListUserReplied>(_onUserReplied);
    on<CommentViewListEmpited>(_onEmpited);
    on<CommentViewListCommentUpdated>(_onCommentUpdated);
  }

  void _onListLoaded(
      CommentViewListLoaded event, Emitter<CommentViewListState> emit) async {
    emit(CommentViewListLoadingInProgress());

    final commentViews = await CommentViewService().getComments();

    if (commentViews.isEmpty) {
      emit(CommentViewListEmpty());
      return;
    }

    emit(CommentViewListWithData(commentViews));
  }

  void _onUserCommeted(CommentViewListUserCommented event,
      Emitter<CommentViewListState> emit) async {
    if (state is CommentViewListWithData) {
      emit(CommentViewListWithData(
          [...(state as CommentViewListWithData).commentViews, event.comment],
          lastUpdateIsNewComment: true));
      return;
    }

    emit(
        CommentViewListWithData([event.comment], lastUpdateIsNewComment: true));
  }

  void _onUserReplied(CommentViewListUserReplied event,
      Emitter<CommentViewListState> emit) async {
    if (state is CommentViewListWithData) {
      final List<CommentView> commentViews =
          List.from((state as CommentViewListWithData).commentViews);

      emit(CommentViewListLoadingInProgress());

      final CommentView? commentReplied = commentViews
          .where((comment) =>
              comment.manifestoCommentId == event.manifestoCommentParentId)
          .first;

      commentReplied?.replies!.add(event.comment);

      emit(CommentViewListWithData(commentViews));
    }
  }

  void _onCommentUpdated(CommentViewListCommentUpdated event,
      Emitter<CommentViewListState> emit) async {
    if (state is CommentViewListWithData) {
      final List<CommentView> commentViews =
          List.from((state as CommentViewListWithData).commentViews);
      final isSubComment = event.comment.isSubcomment;

      emit(CommentViewListLoadingInProgress());

      if (isSubComment) {
        final int parentCommentIndex = commentViews.indexWhere((comment) =>
            comment.manifestoCommentId ==
            event.comment.manifestoCommentParentId);
        final parentComment = commentViews[parentCommentIndex];

        final int replyIndex = parentComment.replies!.indexWhere((reply) =>
            reply.manifestoCommentId == event.comment.manifestoCommentId);
        parentComment.replies![replyIndex] = event.comment;
      } else {
        final int commentIndex = commentViews.indexWhere((comment) =>
            comment.manifestoCommentId == event.comment.manifestoCommentId);

        commentViews[commentIndex] = event.comment;
      }

      emit(CommentViewListWithData(commentViews));
    }
  }

  void _onEmpited(
      CommentViewListEmpited event, Emitter<CommentViewListState> emit) {
    emit(CommentViewListEmpty());
  }
}
