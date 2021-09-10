import 'package:demos_app/api/cache_api.service.dart';
import 'package:demos_app/core/bloc/spaces/spaces_bloc.dart';
import 'package:demos_app/core/interface/event.handler.interface.dart';
import 'package:demos_app/core/mixins/event_handler_mixin.dart';
import 'package:demos_app/core/models/data_event.model.dart';

class UserSpaceHandler extends EventHandlerMixin {
  static final _userSpaceHandler = UserSpaceHandler._internal();
  UserSpaceHandler._internal();
  factory UserSpaceHandler() => _userSpaceHandler;

  @override
  String key = 'user_space';
  @override
  List<EventHandler> eventHandlers = [UserSpaceInvitationEvent()];
}

class UserSpaceInvitationEvent implements EventHandler {
  @override
  String key = 'invitation';

  @override
  Future<void> handleEvent(DataEvent dataEvent) async {
    final CacheApiService cacheApiService = CacheApiService();
    final invitationId = dataEvent.data!["invitation_id"];

    final newInvitationSpace =
        await cacheApiService.getInvitation(invitationId);

    final spacesBloc = SpacesBloc();
    spacesBloc.add(SpacesAddSpaceInvitation(newInvitationSpace));
  }
}
