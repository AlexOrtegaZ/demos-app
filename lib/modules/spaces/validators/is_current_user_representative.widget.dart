import 'package:demos_app/core/models/space.model.dart';
import 'package:demos_app/core/models/user.model.dart';
import 'package:demos_app/core/services/current_user.service.dart';
import 'package:demos_app/core/services/general_spaces.service.dart';
import 'package:demos_app/modules/spaces/pages/spaces/services/space.bloc.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/widget_validator.interface.dart';

class IsCurrentUserRepresentativeValidator implements WidgetValidator {
  @override
  Future<bool> canActivate() async {
    await Future.delayed(const Duration(milliseconds: 100));
    Space? space = SpaceBloc().state;

    if (space == null) {
      return false;
    }

    User? user = await CurrentUserService().getCurrentUser();

    bool isRepresentative = await GeneralSpaceService()
        .isUserRepresentative(user!.userId!, space.spaceId!);

    return isRepresentative;
  }
}