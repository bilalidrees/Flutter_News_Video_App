import 'package:flutter/material.dart';
import 'package:samma_tv/presentation/page/news/main_news_page.dart';
import 'package:samma_tv/presentation/page/news/live_tv.dart';
import 'package:samma_tv/presentation/page/news/national_page/national_page.dart';
import 'package:samma_tv/presentation/page/news/search.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.tabCallback});

  final GlobalKey<NavigatorState>? navigatorKey;
  final String? tabItem;
  Function(bool)? tabCallback;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (tabItem == "Page1")
      child = MainNewsPage(callback: (value) {
        tabCallback!(value);
      });
    else if (tabItem == "Page2")
      child = NationalPage();
    else if (tabItem == "Page3") child = Search();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child!);
      },
    );
  }
}
