part of 'tunda_bloc.dart';

abstract class TundaState extends Equatable {
  const TundaState();

  @override
  List<Object> get props => [];
}

class TundaInitial extends TundaState {}

class TundaLoading extends TundaState {}

class TundaLoaded extends TundaState {}

class TundaError extends TundaState {
  final String errorMessage;
  const TundaError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
