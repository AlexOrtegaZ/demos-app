import 'package:demos_app/config/routes/routes.dart';
import 'package:demos_app/shared/models/option.model.dart';
import 'package:demos_app/widgets/buttons/big_button_widget.dart';
import 'package:demos_app/widgets/buttons/right_close_button.widget.dart';
import 'package:demos_app/widgets/general/select_options.widget.dart';
import 'package:demos_app/widgets/titles/entity_title.widget.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/safe_widget_validator.dart';
import 'package:flutter/material.dart';

class VoteProposalPage extends StatefulWidget {
  const VoteProposalPage({Key? key}) : super(key: key);

  @override
  State<VoteProposalPage> createState() => _VoteProposalPageState();
}

class _VoteProposalPageState extends State<VoteProposalPage> {
  Option? optionSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            RightCloseButton(onPressed: () => Navigator.pop(context)),
            const SizedBox(height: 15),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EntityTitle(name: 'Propuesta #1', type: 'Propuesta'),
                const Spacer(),
                const Text('Opción'),
                Expanded(
                  flex: 3,
                  child: SafeWidgetValidator(
                      child: SelectOptionListWidget(
                    options: getOptions(),
                    onChange: (option) {
                      setState(() {
                        optionSelected = option;
                      });
                    },
                  )),
                ),
                const Spacer(),
                SafeWidgetValidator(
                    child: BigButton(
                  text: 'Votar',
                  disabled: optionSelected == null,
                  onPressed: () {
                    if (optionSelected != null) {
                      optionSelected!.accept();
                    }
                  },
                ))
              ],
            ))
          ],
        ),
      ),
    );
  }

  List<Option> getOptions() {
    return [
      Option('A favor', () {}),
      Option('En contra', () {}),
      Option('Nulo', goToNuleVoteScreen)
    ];
  }

  void goToNuleVoteScreen() => Navigator.pushNamed(context, Routes.nuloVote);
}
