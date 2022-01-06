import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/main_category.dart';

class MainCategoryRepository {
  final RemoteDataSource _remoteDataSource;
  const MainCategoryRepository(this._remoteDataSource);

  Future<Either<Failure, MainCategory>> getMainCategory() async {
    try {
      final MainCategory mainCategory = await _remoteDataSource.getMainCategory();
      return Right(mainCategory);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
