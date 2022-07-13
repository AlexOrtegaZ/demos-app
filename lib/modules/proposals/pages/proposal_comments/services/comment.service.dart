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

import 'package:demos_app/core/api/comment.api.dart';
import 'package:demos_app/core/models/manifesto/comment/manifesto_comment.model.dart';
import 'package:demos_app/core/models/responses/comment_response.model.dart';
import 'package:demos_app/core/repositories/manifesto/comment/manifesto_comment.repository.dart';

class CommentService {
  Future<ManifestoComment> createComment(
      String content, String spaceId, String manifestoId) async {
    final response =
        await CommentApi().createComment(content, spaceId, manifestoId);

    await _saveCommentResponseOnRepository(response);

    return response.comment;
  }

  Future<ManifestoComment> sendCommentReply(String content, String spaceId,
      String manifestoId, String manifestoCommentParentId) async {
    final response = await CommentApi().sendCommentReply(
        content, spaceId, manifestoId, manifestoCommentParentId);

    await _saveCommentResponseOnRepository(response);

    return response.comment;
  }

  Future<ManifestoComment> getComment(
      String spaceId, String manifestoCommentId) async {
    final response = await CommentApi().getComment(spaceId, manifestoCommentId);

    await _saveCommentResponseOnRepository(response);

    return response.comment;
  }

  Future<ManifestoComment> deleteComment(
      String spaceId, String manifestoCommentId) async {
    final response =
        await CommentApi().deleteComment(spaceId, manifestoCommentId);

    await _saveCommentResponseOnRepository(response);

    return response.comment;
  }

  Future<ManifestoComment> updateComment(
      String spaceId, String manifestoCommentId, String content) async {
    final response =
        await CommentApi().updateComment(spaceId, manifestoCommentId, content);

    await _saveCommentResponseOnRepository(response);

    return response.comment;
  }

  Future<ManifestoComment?> getCommentFromLocalDb(
      String manifestoCommentId) async {
    return ManifestoCommentRepository().findById(manifestoCommentId);
  }

  Future<void> _saveCommentResponseOnRepository(
      CommentResponse commentResponse) async {
    await ManifestoCommentRepository().insertOrUpdate(commentResponse.comment);
  }
}
