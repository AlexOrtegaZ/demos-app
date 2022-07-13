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

part of 'comment_view_list_bloc.dart';

abstract class CommentViewListEvent extends Equatable {
  const CommentViewListEvent();

  @override
  List<Object> get props => [];
}

class CommentViewListLoaded extends CommentViewListEvent {}

class CommentViewListUserCommented extends CommentViewListEvent {
  final CommentView comment;

  const CommentViewListUserCommented(this.comment);
}

class CommentViewListUserReplied extends CommentViewListEvent {
  final CommentView comment;
  final String manifestoCommentParentId;

  const CommentViewListUserReplied(this.comment, this.manifestoCommentParentId);
}

class CommentViewListCommentUpdated extends CommentViewListEvent {
  final CommentView comment;

  const CommentViewListCommentUpdated(this.comment);
}

class CommentViewListEmpited extends CommentViewListEvent {}
