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

import 'package:demos_app/utils/parsers/parse_object_to_boolean.dart';

class ManifestoComment {
  final String manifestoCommentId;
  final String content;
  final String? manifestoCommentParentId;
  final bool deleted;
  final String createdAt;
  final String createdByMember;
  final String updatedAt;
  final String manifestoId;

  ManifestoComment(
      this.manifestoCommentId,
      this.content,
      this.manifestoCommentParentId,
      this.deleted,
      this.createdAt,
      this.createdByMember,
      this.updatedAt,
      this.manifestoId);

  factory ManifestoComment.fromObject(dynamic o) => ManifestoComment(
      o['manifestoCommentId'],
      o['content'],
      o['manifestoCommentParentId'] == 'null'
          ? null
          : o['manifestoCommentParentId'],
      parseObjectToBoolean(o['deleted']),
      o['createdAt'],
      o['createdByMember'],
      o['updatedAt'],
      o['manifestoId']);

  Map<String, dynamic> toMap() => {
        'manifestoCommentId': manifestoCommentId,
        'content': content,
        'manifestoCommentParentId': manifestoCommentParentId,
        'deleted': deleted ? 1 : 0,
        'createdAt': createdAt,
        'createdByMember': createdByMember,
        'updatedAt': updatedAt,
        'manifestoId': manifestoId
      };
}
