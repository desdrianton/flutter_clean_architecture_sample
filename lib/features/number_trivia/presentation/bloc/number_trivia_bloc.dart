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
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTriviaUseCase concrete,
    required GetRandomNumberTriviaUseCase random,
    required this.inputConverter,
  })  : getConcreteNumberTriviaUseCase = concrete,
        getRandomNumberTriviaUseCase = random,
        super(EmptyState()) {
    on<GetTriviaForConcreteNumberEvent>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumberEvent>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(GetTriviaForConcreteNumberEvent event, emit) async {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

    leftHandler(l) {
      emit(const ErrorState(message: invalidInputFailureMessage));
    }

    rightHandler(number) async {
      emit(LoadingState());
      Either<Failure, NumberTriviaEntity> failureOrTrivia = await getConcreteNumberTriviaUseCase(Params(number: number));
      _eitherErrorOrLoadedState(failureOrTrivia, emit);
    }

    await inputEither.fold(leftHandler, rightHandler);
  }

  Future<void> _onGetTriviaForRandomNumber(GetTriviaForRandomNumberEvent event, emit) async {
    emit(LoadingState());
    Either<Failure, NumberTriviaEntity> failureOrTrivia = await getRandomNumberTriviaUseCase(NoParams());
    _eitherErrorOrLoadedState(failureOrTrivia, emit);
  }

  Future<void> _eitherErrorOrLoadedState(Either<Failure, NumberTriviaEntity> either, emit) async {
    await either.fold(
          (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
          (trivia) => emit(LoadedState(trivia: trivia)),
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
