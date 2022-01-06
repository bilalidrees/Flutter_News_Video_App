import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/presentation/bloc/main_category_bloc/category_bloc.dart';
import 'package:samma_tv/presentation/bloc/national_feed_bloc/national_feed_bloc.dart';
import 'package:samma_tv/presentation/bloc/program_bloc/program_episode_bloc/program_episode_bloc.dart';
import 'package:samma_tv/presentation/bloc/program_bloc/program_listing_bloc/program_listing_bloc.dart';
import 'package:samma_tv/presentation/bloc/samaa_category_news_bloc/samaa_category_news_bloc.dart';
import 'package:samma_tv/presentation/bloc/samaa_related_news_bloc/samaa_related_news_bloc.dart';
import 'package:samma_tv/presentation/bloc/temp_bloc/temp_bloc.dart';
import 'package:samma_tv/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:samma_tv/presentation/bloc/youtube_live_bloc/youtube_live_bloc.dart';
import 'package:samma_tv/source/core/api_client.dart';
import 'package:samma_tv/source/data_source/remote_data_source.dart';
import 'package:samma_tv/source/repository/json_placeholder_repo.dart';
import 'package:samma_tv/source/repository/main_category_repo.dart';
import 'package:samma_tv/source/repository/national_feed_repo.dart';
import 'package:samma_tv/source/repository/program_repository.dart';
import 'package:samma_tv/source/repository/samaa_category_news_repo.dart';
import 'package:samma_tv/source/repository/samaa_related_news_repo.dart';
import 'package:samma_tv/source/repository/youtube_live_repo.dart';



final sl = GetIt.instance;
final  one =sl<NationalFeedBloc>();
final  two =one;
Future<void> init()async{
  sl.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
  sl.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());
  sl.registerLazySingleton<Client>(() => Client());

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl(),sl()));
  ///////////////////////
  sl.registerLazySingleton<JsonPlaceHolderRepository>(() => JsonPlaceHolderRepository(sl()));
  sl.registerFactory<TempBloc>(() => TempBloc(sl()));
  /////////////
  sl.registerLazySingleton<MainCategoryRepository>(() => MainCategoryRepository(sl()));
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(sl()));

  ///////////////

  sl.registerLazySingleton<SamaaCategoryNewsRepository>(() => SamaaCategoryNewsRepository(sl()));
  sl.registerFactory<SamaaCategoryNewsBloc>(() => SamaaCategoryNewsBloc(sl()));
  /////////////
  sl.registerLazySingleton<ProgramRepository>(() => ProgramRepository(sl()));
  sl.registerFactory<ProgramListingBloc>(() => ProgramListingBloc(sl()));
  sl.registerFactory<ProgramEpisodeBloc>(() => ProgramEpisodeBloc(sl()));
  /////////////

  sl.registerLazySingleton<SamaaRelatedNewsRepository>(() => SamaaRelatedNewsRepository(sl()));
  sl.registerFactory<SamaaRelatedNewsBloc>(() => SamaaRelatedNewsBloc(sl()));
  //////////////
  sl.registerLazySingleton<NationalFeedRepository>(() => NationalFeedRepository(sl()));
  sl.registerFactory<NationalFeedBloc>(() => NationalFeedBloc(sl()));
  ////
  sl.registerLazySingleton<YouTubeLiveRepository>(() => YouTubeLiveRepository(sl()));
  sl.registerFactory<YoutubeLiveBloc>(() => YoutubeLiveBloc(sl()));
  ////


}