import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_sample/core/error/failure.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(int number);

  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}
