import 'package:demos_app/core/models/space.model.dart';
import 'package:demos_app/core/models/user.model.dart';
import 'package:demos_app/core/services/current_user.service.dart';
import 'package:demos_app/core/services/general_spaces.service.dart';
import 'package:demos_app/modules/spaces/pages/spaces/services/current_space.service.dart';
import 'package:demos_app/widgets/wrappers/safe_widget/widget_validator.interface.dart';

class IsCurrentUserAdminWidgetValidator implements WidgetValidator {
  @override
  Future<bool> canActivate() async {
    Space? space = CurrentSpaceService().getCurrentSpace();

    if (space == null) {
      return false;
    }

    User? user = await CurrentUserService().getCurrentUser();

    bool isAdmin = await GeneralSpaceService().isUserAdmin(user!.userId!, space.spaceId!);
    
    return isAdmin;
  }
}