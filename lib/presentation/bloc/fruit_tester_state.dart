part of 'fruit_tester_bloc.dart';

abstract class FruitTesterState extends Equatable {
  const FruitTesterState();

  @override
  List<Object> get props => [];
}

class FruitTesterInitial extends FruitTesterState {}

class FruitTesterLoading extends FruitTesterState {}

class FruitTesterLoaded extends FruitTesterState {
  final String greeting;
  const FruitTesterLoaded({required this.greeting});
  @override
  List<Object> get props => [greeting];
}

class FruitTesterError extends FruitTesterState {}
