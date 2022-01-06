import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/youtube_live.dart';

class YouTubeLiveRepository {
  final RemoteDataSource _remoteDataSource;
  const YouTubeLiveRepository(this._remoteDataSource);

  Future<Either<Failure, YouTubeLive>> getYouTubeLive() async {
    try {
      final YouTubeLive youTubeLive = await _remoteDataSource.getYouTubeLive();
      return Right(youTubeLive);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}