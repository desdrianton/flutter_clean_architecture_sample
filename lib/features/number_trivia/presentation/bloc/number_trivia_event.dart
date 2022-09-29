import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent() : super();

  @override
  List<Object?> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String number;

  const GetTriviaForConcreteNumber({required this.number}) : super();

  @override
  List<Object?> get props => [number];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  const GetTriviaForRandomNumber() : super();

  @override
  List<Object?> get props => [];
}
