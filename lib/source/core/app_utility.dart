import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/source/model/program_response.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:samma_tv/app_localizations.dart';

class AppUtility {
  static Future<List<dynamic>> getPublishTime(
      {List<News>? newsFeedList, List<Programs>? programList}) async {
    if (newsFeedList != null) {
      List<News> newNewsFeed = [];
      newsFeedList.forEach((news) {
        news.articlePublishedTime = newsPostTimeCalculation(news.pubDate);
        newNewsFeed.add(news);
      });
      return newNewsFeed;
    } else {
      List<Programs> newNewsFeed = [];
      programList!.forEach((news) {
        news.articlePublishedTime = newsPostTimeCalculation(news.pubDate!);
        newNewsFeed.add(news);
      });
      return newNewsFeed;
    }
  }

  static String newsPostTimeCalculation(String pubDate) {
    var tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(pubDate, false);
    var currentDate = DateTime.now();

    var seconds =
        (currentDate.millisecondsSinceEpoch - tempDate.millisecondsSinceEpoch) /
            1000;
    String intervalType;
    num mathValue;
    mathValue = seconds / 31536000;
    var interval = mathValue.round();
    if (interval >= 1) {
      intervalType = sl<LocalizationBloc>().state.languageCode == 'en'
          ? AppString.year
          : 'سال';
    } else {
      mathValue = seconds / 2592000;
      interval = mathValue.round();
      if (interval >= 1) {
        intervalType = sl<LocalizationBloc>().state.languageCode == 'en'
            ? AppString.month
            : 'مہینہ';
      } else {
        mathValue = seconds / 86400;
        interval = mathValue.round();
        if (interval >= 1) {
          intervalType = sl<LocalizationBloc>().state.languageCode == 'en'
              ? AppString.day
              : 'دن';
        } else {
          mathValue = seconds / 3600;
          interval = mathValue.round();
          if (interval >= 1) {
            intervalType = sl<LocalizationBloc>().state.languageCode == 'en'
                ? AppString.hour
                : 'گھنٹہ';
          } else {
            mathValue = seconds / 60;
            interval = mathValue.round();
            if (interval >= 1) {
              intervalType = sl<LocalizationBloc>().state.languageCode == 'en'
                  ? AppString.minute
                  : 'منٹ';
            } else {
              interval = seconds as int;
              intervalType = sl<LocalizationBloc>().state.languageCode == 'en'
                  ? AppString.second
                  : 'دوسرا';
            }
          }
        }
      }
    }
    //    adding a plural to text, optional
    if (interval > 1 || interval == 0) {
      intervalType +=
          sl<LocalizationBloc>().state.languageCode == 'en' ? 's' : '';
    }
    if (interval is String || (interval <= 0)) {
      return "";
    } else {
      return "$interval $intervalType ${sl<LocalizationBloc>().state.languageCode == 'en' ? "ago" : "پہلے"}";
    }
  }
}
