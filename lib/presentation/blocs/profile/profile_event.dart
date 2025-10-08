part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final String uid;

  const LoadProfileEvent({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class RefreshProfileEvent extends ProfileEvent {
  final String uid;

  const RefreshProfileEvent({required this.uid});

  @override
  List<Object?> get props => [uid];
}
