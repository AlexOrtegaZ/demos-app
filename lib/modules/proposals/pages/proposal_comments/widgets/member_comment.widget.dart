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

import 'package:demos_app/core/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:demos_app/core/models/manifesto/comment/manifesto_comment_vote.model.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/bloc/comment_view_list_bloc.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/enums/current_user_commemt_vote.enum.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/models/comment_view.model.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment_view.service.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/services/comment_vote.service.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/widgets/buttons/reply_button.widget.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/widgets/comment_votes_count.widget.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/widgets/buttons/show_replies_button.widget.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/widgets/popup_comment_menu_options.widget.dart';
import 'package:demos_app/modules/proposals/pages/proposal_comments/widgets/replies_list_view.widget.dart';
import 'package:demos_app/modules/spaces/pages/space_details/bloc/space.bloc.dart';
import 'package:demos_app/modules/spaces/validators/is_current_member.widget_validator.dart';
import 'package:demos_app/widgets/profile/profile_picture.widget.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/safe_widget_validator.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';

class MemberComment extends StatelessWidget {
  final CommentView comment;
  final EdgeInsetsGeometry padding;
  final bool enableReplies;

  final void Function()? onReplied;

  const MemberComment({
    Key? key,
    required this.comment,
    this.enableReplies = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.onReplied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentIsDeleted = comment.content == '' && comment.deleted;
    return Padding(
      padding: padding,
      child: ExpansionWidget(
        initiallyExpanded: comment.repliesCount <= 3,
        titleBuilder:
            (animationValue, easeInValue, isExpanded, toggleFunction) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                comment.member != null
                    ? ProfilePicture(
                        imageKey: comment.member!.profilePictureKey,
                        width: 40,
                        percentage: 0.9,
                      )
                    : Container(),
                const SizedBox(width: 10),
                Text(
                  '${comment.member != null ? comment.member!.displayName : '[Miembro Eliminado]'} ',
                  overflow: TextOverflow.clip,
                ),
                Text(comment.createdAtFormatted,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(color: Colors.grey, fontSize: 12))
              ],
            ),
            const SizedBox(height: 15),
            Text(commentIsDeleted ? '[Comentario Eliminado]' : comment.content,
                style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommentVotesCount(
                  votesInFavor: comment.upVotesCount,
                  votesInOpposing: comment.downVotesCount,
                  onUpvote: commentIsDeleted
                      ? null
                      : () => onVote(comment.manifestoCommentId, true),
                  onDownvote: commentIsDeleted
                      ? null
                      : () => onVote(comment.manifestoCommentId, false),
                  currentUserCommentVote: getCurrentUserCommentVote(),
                ),
                const SizedBox(width: 10),
                comment.repliesCount > 0 && enableReplies
                    ? ShowRepliesButton(
                        onTap: toggleFunction,
                        repliesCount: comment.repliesCount)
                    : Container(),
                const SizedBox(width: 5),
                enableReplies && !commentIsDeleted
                    ? ReplyButton(onTap: onReplied)
                    : Container(),
                commentIsDeleted
                    ? Container()
                    : SafeWidgetValidator(
                        validators: [
                          IsCurrentMemberWidgetValidator(
                              comment.member!.memberId!)
                        ],
                        child: PopupCommentMenuOptions(comment: comment),
                      )
              ],
            )
          ],
        ),
        content: enableReplies && comment.replies != null
            ? RepliesListView(replies: comment.replies!)
            : Container(),
      ),
    );
  }

  void onVote(String manifestoCommentId, bool upvote) async {
    final userId = CurrentUserBloc().state!.userId;
    final spaceId = SpaceBloc().state.spaceId;

    final currentUserCommentVote = await CommentVoteService()
        .getCommentVoteFromLocalDbByManifestoCommentIdAndUserId(
            manifestoCommentId, userId);

    if (currentUserCommentVote != null) {
      await updateVote(spaceId!, upvote, currentUserCommentVote);
      return;
    }

    final commentVote = await CommentVoteService()
        .voteComment(spaceId!, manifestoCommentId, upvote);

    await _updateCommentView(commentVote.manifestoCommentId);
  }

  Future<void> updateVote(String spaceId, bool upvote,
      ManifestoCommentVote currentUserCommentVote) async {
    final canUpdateVote = upvote != currentUserCommentVote.upvote;
    if (canUpdateVote) {
      await CommentVoteService().updateCommentVote(
          spaceId, currentUserCommentVote.manifestoCommentVoteId, upvote);
      await _updateCommentView(currentUserCommentVote.manifestoCommentId);
      return;
    }

    await CommentVoteService().deleteCommentVote(
        spaceId, currentUserCommentVote.manifestoCommentVoteId);
    await _updateCommentView(currentUserCommentVote.manifestoCommentId);
  }

  Future<void> _updateCommentView(String manifestoCommentId) async {
    final commentView =
        await CommentViewService().getCommentById(manifestoCommentId);

    CommentViewListBloc().add(CommentViewListCommentUpdated(commentView!));
  }

  CurrentUserCommentVote getCurrentUserCommentVote() {
    final currentUserId = CurrentUserBloc().state!.userId;
    final currentUserVoteResult =
        comment.votes.where((vote) => vote.userId == currentUserId).toList();

    if (currentUserVoteResult.isEmpty) return CurrentUserCommentVote.none;

    final currentUserVote = currentUserVoteResult.first;

    return currentUserVote.upvote
        ? CurrentUserCommentVote.upvote
        : CurrentUserCommentVote.downvote;
  }
}
