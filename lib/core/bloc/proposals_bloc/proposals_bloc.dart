import 'package:bloc/bloc.dart';
import 'package:demos_app/core/repositories/manifesto/manifesto.repository.dart';
import 'package:demos_app/shared/constants/proposal_list_type_menu_order.dart';
import 'package:equatable/equatable.dart';
import 'package:demos_app/core/enums/proposal_list_type.enum.dart';
import 'package:demos_app/core/models/manifesto/manifesto.model.dart';

part 'proposals_event.dart';
part 'proposals_state.dart';

class ProposalsBloc extends Bloc<ProposalsEvent, ProposalsState> {
  static final ProposalsBloc _proposalsBloc = ProposalsBloc._internal();
  factory ProposalsBloc() => _proposalsBloc;
  ProposalsBloc._internal() : super(ProposalLoadingInProgress()) {
    on<ProposalEventInitialized>((event, emit) async {
      for (final type in proposalListTypeMenuOrder) {
        final proposals =
            await ManifestoRepository().findBySpaceId(event.spaceId);
        if (proposals.isNotEmpty) {
          emit(ProposalBlocStateWithData(proposals, type));
          return;
        }
      }
      emit(
          ProposalBlocStateWithData(const [], proposalListTypeMenuOrder.first));
    });
  }
}
