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

import 'package:demos_app/core/models/manifesto/comment/manifesto_comment_vote.model.dart';
import 'package:demos_app/modules/spaces/models/member_view.model.dart';
import 'package:demos_app/shared/services/date_formatter.service.dart';

class CommentView {
  final String manifestoCommentId;
  final String createdAt;
  final String content;
  final String? manifestoCommentParentId;
  final List<ManifestoCommentVote> votes;
  final MemberView? member;
  final List<CommentView>? replies;
  final bool deleted;

  String get createdAtFormatted =>
      DateFormatterService.parseToDayMonthYearHourDate(createdAt);

  int get repliesCount => replies == null ? 0 : replies!.length;
  bool get isSubcomment => manifestoCommentParentId != null;

  int get upVotesCount => votes.where((vote) => vote.upvote).length;
  int get downVotesCount => votes.where((vote) => !vote.upvote).length;

  CommentView(
    this.manifestoCommentId,
    this.createdAt,
    this.content,
    this.manifestoCommentParentId,
    this.votes,
    this.member,
    this.replies,
    this.deleted,
  );

  factory CommentView.fromObjectAndParams(dynamic o, List<CommentView>? replies,
          MemberView? member, List<ManifestoCommentVote> votes) =>
      CommentView(
        o['manifestoCommentId'],
        o['createdAt'],
        o['content'],
        o['manifestoCommentParentId'],
        votes,
        member,
        replies,
        o['deleted'] == 1 ? true : false,
      );
}
