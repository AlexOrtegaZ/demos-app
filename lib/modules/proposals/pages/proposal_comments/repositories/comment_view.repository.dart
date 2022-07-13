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

import 'package:demos_app/core/repositories/app_repository.dart';
import 'package:demos_app/core/repositories/manifesto/comment/manifesto_comment.repository.dart';
import 'package:demos_app/core/repositories/manifesto/comment/manifesto_comment_vote.repository.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/models/comment_view.model.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/members/services/member_view.service.dart';
import 'package:sqflite/sqflite.dart';

class CommentViewRepository extends AppRepository {
  final tblManifestoComment = ManifestoCommentRepository().tblManifestoComment;
  final colManifestoCommentId = ManifestoCommentRepository().colId;
  final colManifestoCommentParentId =
      ManifestoCommentRepository().colManifestoCommentParentId;
  final colContent = ManifestoCommentRepository().colContent;
  final colCreatedAt = ManifestoCommentRepository().colCreatedAt;
  final colCreatedByMember = ManifestoCommentRepository().colCreatedByMember;
  final colManifestoId = ManifestoCommentRepository().colManifestoId;
  final colDeleted = ManifestoCommentRepository().colDeleted;

  String _getSelectQuery() => '''
    SELECT $colManifestoCommentId,
            $colContent,
            $colCreatedAt,
            $colCreatedByMember,
            $colManifestoCommentParentId,
            $colDeleted
    FROM $tblManifestoComment
  ''';

  String _getFindByManifestoIdQuery(String manifestoId) => '''
    ${_getSelectQuery()}
    WHERE $colManifestoId = '$manifestoId'
      AND 
    ($colManifestoCommentParentId is null OR $colManifestoCommentParentId = '') 
  ''';

  String _getFindRepliesByManifestoCommentId(String manifestoCommentId) => '''
    ${_getSelectQuery()}
    WHERE $colManifestoCommentParentId = '$manifestoCommentId';
  ''';

  String _getFindByManifestoCommentId(String manifestoCommentId) => '''
    ${_getSelectQuery()}
    WHERE $colManifestoCommentId = '$manifestoCommentId';
  ''';

  Future<CommentView?> findByManifestoCommentId(
      String manifestoCommentId) async {
    final Database? db = await this.db;
    final query = _getFindByManifestoCommentId(manifestoCommentId);

    final result = await db!.rawQuery(query);

    return result.isNotEmpty
        ? await _mapCommentResultToCommentView(result[0])
        : null;
  }

  Future<List<CommentView>> findRepliesByManifestoCommentId(
      String manifestoCommentId) async {
    final Database? db = await this.db;
    final query = _getFindRepliesByManifestoCommentId(manifestoCommentId);

    final repliesResult = await db!.rawQuery(query);
    final replies = await _mapCommentResultsToCommentViews(repliesResult);

    return replies;
  }

  Future<List<CommentView>> findByManifestoId(String manifestoId) async {
    final Database? db = await this.db;
    final query = _getFindByManifestoIdQuery(manifestoId);

    final commentResults = await db!.rawQuery(query);
    final comments = await _mapCommentResultsToCommentViews(commentResults);

    return comments;
  }

  Future<CommentView> _mapCommentResultToCommentView(
      Map<String, Object?> result) async {
    final memberId = '${result['createdByMember']}';
    final member = await MemberViewService().getMemberViewByMemberId(memberId);
    final votes = await ManifestoCommentVoteRepository()
        .findByManifestoCommentId('${result['manifestoCommentId']}');

    final haveReplies = result['manifestoCommentParentId'] == null;
    final replies = haveReplies
        ? await findRepliesByManifestoCommentId(
            '${result['manifestoCommentId']}')
        : null;

    final comment =
        CommentView.fromObjectAndParams(result, replies, member, votes);

    return comment;
  }

  Future<List<CommentView>> _mapCommentResultsToCommentViews(
      List<Map<String, Object?>> commentResults) async {
    final List<CommentView> commentViews = [];

    for (final commentResult in commentResults) {
      final comment = await _mapCommentResultToCommentView(commentResult);

      commentViews.add(comment);
    }

    return commentViews;
  }
}
