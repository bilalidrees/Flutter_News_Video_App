import 'package:flutter/material.dart';
import 'package:samma_tv/constant/route_string.dart';
import 'package:samma_tv/presentation/page/home/home_page.dart';
import 'package:samma_tv/presentation/page/news/main_news_page.dart';
import 'package:samma_tv/presentation/page/news/news_details.dart';
import 'package:samma_tv/presentation/page/news/program_page.dart';
import 'package:samma_tv/presentation/page/splash/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case RouteString.initialPage:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case RouteString.homePage:
        return MaterialPageRoute(builder: (_) => MainNewsPage());
      case RouteString.dummy:
        return MaterialPageRoute(builder: (_) => HomePage());
      // case RouteString.newsDetail:
      //   return MaterialPageRoute(builder: (_) => NewsDetailScreen());
      // case RouteString.programPage:
      //   return MaterialPageRoute(builder: (_) => ProgramPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
