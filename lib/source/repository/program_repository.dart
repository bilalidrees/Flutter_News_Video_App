import 'package:dartz/dartz.dart';
import 'package:samma_tv/source/core/app_utility.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/model/program_response.dart';

class ProgramRepository {
  final RemoteDataSource _remoteDataSource;

  const ProgramRepository(this._remoteDataSource);

  Future<Either<Failure, ProgramResponse>> getProgramsList(
      {String? url}) async {
    try {
      final ProgramResponse programResponse =
          await _remoteDataSource.getProgramsList(url: url);
      if (url != null) {
        programResponse.programsEpisodes = await AppUtility.getPublishTime(
            programList: programResponse.programsEpisodes) as List<Programs>;
      }
      return Right(programResponse);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
