import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_sample/core/error/failure.dart';
import 'package:flutter_clean_architecture_sample/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_sample/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
