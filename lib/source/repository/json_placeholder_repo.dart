import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/json_placeholder.dart';

class JsonPlaceHolderRepository {
  final RemoteDataSource _remoteDataSource;
  const JsonPlaceHolderRepository(this._remoteDataSource);

  Future<Either<Failure, JsonPlaceHolder>> getJsonPlaceHolder() async {
    try {
      final JsonPlaceHolder jsonPlaceHolder = await _remoteDataSource.getJsonPlaceHolder();
      return Right(jsonPlaceHolder);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
