import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/app_utility.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';

class NationalFeedRepository {
  final RemoteDataSource _remoteDataSource;

  const NationalFeedRepository(this._remoteDataSource);

  Future<Either<Failure, MyNews>> getNationalFeed() async {
    try {
      final MyNews myNews = await _remoteDataSource.getNationalFeed();
      myNews.national =
          await AppUtility.getPublishTime(newsFeedList: myNews.national)
              as List<News>;
      return Right(myNews);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
