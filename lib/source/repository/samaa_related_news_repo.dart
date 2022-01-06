import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/app_utility.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:samma_tv/source/model/samaa_related_news.dart';

class SamaaRelatedNewsRepository {
  final RemoteDataSource _remoteDataSource;

  const SamaaRelatedNewsRepository(this._remoteDataSource);

  Future<Either<Failure, SamaaRelatedNews>> getSamaaRelatedNewsByName(
      int id) async {
    try {
      final SamaaRelatedNews samaaRelatedNews =
          await _remoteDataSource.getSamaaRelatedNews(id);
      samaaRelatedNews.seeMore = await AppUtility.getPublishTime(
          newsFeedList: samaaRelatedNews.seeMore) as List<News>;
      return Right(samaaRelatedNews);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
