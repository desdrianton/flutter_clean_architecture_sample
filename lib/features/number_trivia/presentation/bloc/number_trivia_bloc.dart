import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_sample/core/error/failure.dart';
import 'package:flutter_clean_architecture_sample/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_sample/core/util/input_converter.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/presentation/bloc/number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  void _onGetTriviaForConcreteNumber(GetTriviaForConcreteNumber event, emit) {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

    // leftHandler(l) {
    //   emit(const Error(message: invalidInputFailureMessage));
    // }
    //
    // rightHandler(number) async {
    //   emit(Loading());
    //   Either<Failure, NumberTrivia> failureOrTrivia = await getConcreteNumberTrivia(Params(number: number));
    //   _eitherErrorOrLoadedState(failureOrTrivia, emit);
    // }

    inputEither.fold((l) {
      emit(const Error(message: invalidInputFailureMessage));
    }, (number) async {
      emit(Loading());
      Either<Failure, NumberTrivia> failureOrTrivia = await getConcreteNumberTrivia(Params(number: number));
      _eitherErrorOrLoadedState(failureOrTrivia, emit);
    });
  }

  void _onGetTriviaForRandomNumber(GetTriviaForRandomNumber event, emit) async {
    emit(Loading());
    Either<Failure, NumberTrivia> failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _eitherErrorOrLoadedState(failureOrTrivia, emit);
  }

  void _eitherErrorOrLoadedState(Either<Failure, NumberTrivia> either, emit) {
    either.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
