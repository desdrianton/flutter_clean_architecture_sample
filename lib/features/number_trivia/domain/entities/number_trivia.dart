import 'package:equatable/equatable.dart';

class NumberTriviaEntity extends Equatable {
  final int number;

  final String text;

  const NumberTriviaEntity({
    required this.number,
    required this.text,
  });

  @override
  List<Object?> get props => [number, text,];
}
