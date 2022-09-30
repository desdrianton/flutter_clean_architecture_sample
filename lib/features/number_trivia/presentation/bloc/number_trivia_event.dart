import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent() : super();

  @override
  List<Object?> get props => [];
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumberEvent({required this.numberString}) : super();

  @override
  List<Object?> get props => [numberString];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  const GetTriviaForRandomNumberEvent() : super();

  @override
  List<Object?> get props => [];
}
