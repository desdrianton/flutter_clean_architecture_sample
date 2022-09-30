import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState() : super();
}

class EmptyState extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends NumberTriviaState {
  final NumberTriviaEntity trivia;

  const LoadedState({required this.trivia}) : super();

  @override
  List<Object?> get props => [trivia];
}

class ErrorState extends NumberTriviaState {
  final String message;

  const ErrorState({required this.message}) : super();

  @override
  List<Object?> get props => [];
}
