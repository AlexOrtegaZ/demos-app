part of 'spaces_bloc.dart';

abstract class SpacesEvent extends Equatable {
  const SpacesEvent();

  @override
  List<Object> get props => [];
}

class LoadSpacesEvent extends SpacesEvent {}