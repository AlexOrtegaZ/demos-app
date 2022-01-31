import 'package:demos_app/config/routes/routes.dart';
import 'package:demos_app/modules/proposals/pages/proposals/models/proposal_view.model.dart';
import 'package:demos_app/modules/proposals/pages/proposals/widgets/proposal_cards/proposal_card.interface.dart';
import 'package:demos_app/modules/proposals/pages/proposals/widgets/proposal_cards/proposal_cart_info.widget.dart';
import 'package:flutter/material.dart';

class ProposalInProgressCard extends StatelessWidget implements ProposalCard {
  @override
  final ProposalView proposal;
  final int totalOfMembers;

  const ProposalInProgressCard(
      {Key? key, required this.proposal, this.totalOfMembers = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.proposalDetails),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(proposal.title ?? 'Sin titulo',
                        style: const TextStyle(fontSize: 20)),
                    Container(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Por: ${proposal.createdByName}',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12.0),
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProposalCardInfo(
                    getIcon: (size, color) => Icon(
                      Icons.calendar_today,
                      size: size,
                      color: color,
                    ),
                    title: 'TERMINA EN:',
                    content: '3 HORAS',
                  ),
                  ProposalCardInfo(
                    getIcon: (size, color) => Icon(
                      Icons.how_to_vote,
                      size: size,
                      color: color,
                    ),
                    title: 'Votos:',
                    content: '${proposal.votesCount}/$totalOfMembers',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}