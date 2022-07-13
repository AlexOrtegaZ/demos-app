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

import 'package:demos_app/constans/comments.path.dart';
import 'package:demos_app/core/api/api.dart';
import 'package:demos_app/core/models/responses/comment_response.model.dart';

class CommentApi {
  Future<CommentResponse> createComment(
      String content, String spaceId, String manifestoId) async {
    final String endpoint =
        CommentsPath().getManifestoCommentPath(spaceId, manifestoId);
    final body = _getBodyFromContent(content);

    final httpResponse = await Api.post(endpoint, body, null);
    final response = CommentResponse.fromObject(httpResponse);

    return response;
  }

  Future<CommentResponse> sendCommentReply(String content, String spaceId,
      String manifestoId, String manifestoCommentParentId) async {
    final String endpoint = CommentsPath().getReplyManifestoCommentPath(
        spaceId, manifestoId, manifestoCommentParentId);
    final body = _getBodyFromContent(content);

    final httpResponse = await Api.post(endpoint, body, null);
    final response = CommentResponse.fromObject(httpResponse);

    return response;
  }

  Future<CommentResponse> getComment(
      String spaceId, String manifestoCommentId) async {
    final String endpoint =
        CommentsPath().getManifestoCommentPath(spaceId, manifestoCommentId);

    final httpResponse = await Api.get(endpoint, null);
    final response = CommentResponse.fromObject(httpResponse);

    return response;
  }

  Future<CommentResponse> deleteComment(
      String spaceId, String manifestoCommentId) async {
    final String endpoint =
        CommentsPath().getManifestoCommentPath(spaceId, manifestoCommentId);

    final httpResponse = await Api.delete(endpoint, null);
    final response = CommentResponse.fromObject(httpResponse);

    return response;
  }

  Future<CommentResponse> updateComment(
      String spaceId, String manifestoCommentId, String content) async {
    final String endpoint =
        CommentsPath().getManifestoCommentPath(spaceId, manifestoCommentId);

    final body = _getBodyFromContent(content);

    final httpResponse = await Api.put(endpoint, body, null);
    final response = CommentResponse.fromObject(httpResponse);

    return response;
  }

  Map<String, dynamic> _getBodyFromContent(String content) =>
      {'content': content};
}
