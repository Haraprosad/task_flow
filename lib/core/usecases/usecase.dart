import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_flow/core/network/api_error.dart';


abstract interface class UseCase<SuccessType,Params> {
  Future<Either<ApiError, SuccessType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}