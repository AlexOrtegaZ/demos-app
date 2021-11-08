import 'package:demos_app/core/models/space.model.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/space_percentages_form/widgets/approval_percentage_slider.widget.dart';
import 'package:demos_app/modules/spaces/pages/new_space/screens/space_percentages_form/widgets/participation_percentage_slider.widget.dart';
import 'package:demos_app/modules/spaces/pages/space_details/services/space_details.service.dart';
import 'package:demos_app/modules/spaces/pages/spaces/services/current_space.service.dart';
import 'package:demos_app/utils/mixins/loading_state_handler.mixin.dart';
import 'package:demos_app/utils/ui/global_colors.util.dart';
import 'package:demos_app/widgets/buttons/big_button_widget.dart';
import 'package:flutter/material.dart';

class SpacePercentageSettingsScreen extends StatefulWidget {
  SpacePercentageSettingsScreen({Key? key}) : super(key: key);

  @override
  _SpacePercentageSettingsScreenState createState() =>
      _SpacePercentageSettingsScreenState();
}

class _SpacePercentageSettingsScreenState
    extends State<SpacePercentageSettingsScreen> with LoadingStateHandler {
  int approvalPercentage = 70;
  int participationPercentage = 70;

  @override
  Widget build(BuildContext context) {
    Space? space = CurrentSpaceService().getCurrentSpace();
    approvalPercentage = space!.approvalPercentage;
    participationPercentage = space.participationPercentage;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Votos"),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              ApprovalPercentageSlider(
                initialValue: approvalPercentage,
                onChange: (approvalPercentage) {
                  setState(() {
                    this.approvalPercentage = approvalPercentage;
                  });
                },
              ),
              Container(
                height: 30.0,
                margin: EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: greyColor))),
              ),
              ParticipationPercentageSlider(
                initialValue: participationPercentage,
                onChange: (participationPercentage) {
                  setState(() {
                    this.participationPercentage = participationPercentage;
                  });
                },
              ),
              Spacer(),
              BigButton(
                text: 'Guardar',
                onPressed: save,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    wrapLoadingTransaction(() async {
      Space? space = CurrentSpaceService().getCurrentSpace();
      space!.approvalPercentage = this.approvalPercentage;
      space.participationPercentage = this.participationPercentage;

      await SpaceDetailsService().updateSpace(space);
      Navigator.pop(context);
    });
  }
}