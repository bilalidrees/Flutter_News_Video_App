import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/app_utility.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';

class SamaaCategoryNewsRepository {
  final RemoteDataSource _remoteDataSource;

  const SamaaCategoryNewsRepository(this._remoteDataSource);

  Future<Either<Failure, SamaaCategoryNews>> getSamaaCategoryNewsByName(
      String categoryName) async {
    try {
      final SamaaCategoryNews samaaCategoryNews =
          await _remoteDataSource.getSamaaCategoryNews(categoryName);
      samaaCategoryNews.myNews.data = await AppUtility.getPublishTime(
          newsFeedList: samaaCategoryNews.myNews.data) as List<News>;
      return Right(samaaCategoryNews);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
