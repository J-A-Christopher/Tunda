import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tunda_event.dart';
part 'tunda_state.dart';

class TundaBloc extends Bloc<TundaEvent, TundaState> {
  TundaBloc() : super(TundaInitial()) {
    on<TundaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
