import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/source/core/api_client.dart';
import 'package:samma_tv/source/core/api_constant.dart';
import 'package:samma_tv/source/model/json_placeholder.dart';
import 'package:samma_tv/source/model/main_category.dart';
import 'package:samma_tv/source/model/program_response.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:samma_tv/source/model/samaa_related_news.dart';
import 'package:samma_tv/source/model/youtube_live.dart';

abstract class RemoteDataSource {
  const RemoteDataSource();
  Future<JsonPlaceHolder> getJsonPlaceHolder();

  Future<MainCategory> getMainCategory();

  Future<SamaaCategoryNews> getSamaaCategoryNews(String categoryName);

  Future<SamaaRelatedNews> getSamaaRelatedNews(int id);

  Future<MyNews> getNationalFeed();

  Future<YouTubeLive> getYouTubeLive();

  Future<ProgramResponse> getProgramsList({String? url});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiClient _apiClient;
  final LocalizationBloc local;
  const RemoteDataSourceImpl(this._apiClient,this.local);


  @override
  Future<JsonPlaceHolder> getJsonPlaceHolder() async {
    final Map<String, dynamic> response = await _apiClient
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    return JsonPlaceHolder.fromJson(response);
  }

  @override
  Future<MainCategory> getMainCategory() async {
    final Map<String, dynamic> response = await _apiClient.get(Uri.parse(
        local.state.languageCode == "en"
            ? '${ApiString.baseUrl}' + '${ApiString.getCategoryUrlEnglish}'
            : ApiString.getCategoryUrlUrdu));
    return MainCategory.fromJson(response);
  }

  @override
  Future<SamaaCategoryNews> getSamaaCategoryNews(String categoryName) async {
    var uri = local.state.languageCode == "en"
        ? Uri.https('${ApiString.baseUrlWithoutHttpEnglish}',
            '${ApiString.getCategoryDetailNews}', {'category': categoryName})
        : Uri.https('${ApiString.baseUrlWithoutHttpUrdu}', '/urdu/my_news/',
            {'category': categoryName});
    final Map<String, dynamic> response = await _apiClient.get(uri);
    return SamaaCategoryNews.fromJson(response);
  }

  @override
  Future<SamaaRelatedNews> getSamaaRelatedNews(int id) async {
    var uri = local.state.languageCode == "en"
        ? Uri.https('${ApiString.baseUrlWithoutHttpEnglish}',
            '/jappfeedseemore/', {'news_id': id.toString()})
        : Uri.https('${ApiString.baseUrlWithoutHttpEnglish}',
            '/urdu/jfeedurduseemore/', {'news_id': id.toString()});
    final Map<String, dynamic> response = await _apiClient.get(uri);

    return SamaaRelatedNews.fromJson(response);
  }

  @override
  Future<MyNews> getNationalFeed() async {
    final Map<String, dynamic> response = await _apiClient.get(Uri.parse(ApiString.nationalFeed));
    return MyNews.fromJson(response);
  }

  @override
  Future<YouTubeLive> getYouTubeLive() async {

    final Map<String, dynamic> response = await _apiClient.get(Uri.parse(ApiString.youTubeLive));
    return YouTubeLive.fromJson(response);
  }

  @override
  Future<ProgramResponse> getProgramsList({String? url}) async {
    final Map<String, dynamic> response;
    if (url==null) {
      response = await _apiClient.get(Uri.parse(ApiString.tvProgramList));
    } else {
      response = await _apiClient.get(Uri.parse('$url'));
    }
    return ProgramResponse.fromJson(response);
  }
}
