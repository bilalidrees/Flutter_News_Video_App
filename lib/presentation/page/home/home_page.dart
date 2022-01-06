import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:samma_tv/app_localizations.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/tab_navigator.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';

import '../../../constant/image_string.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
  };
  int _currentIndex = 0;
  ValueNotifier<bool> isHideBottom = ValueNotifier(false);
  final hideDuration = const Duration(milliseconds: 500);

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    isHideBottom.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Page1") {
            _selectTab("Page1", 1);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator("Page1", callback: (value) {
            isHideBottom.value = value;
          }),
          _buildOffstageNavigator("Page2"),
          _buildOffstageNavigator("Page3"),
        ]),
        bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: isHideBottom,
          builder: (context, value, child) => AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: CustomNavigationBar(
              iconSize: 25.0,
              selectedColor: Color(0xff040307),
              strokeColor: Color(0x30040307),
              unSelectedColor: Color(0xffacacac),
              backgroundColor: AppColor.GradTwo,
              items: [
                CustomNavigationBarItem(
                  icon: Image(
                    image: ImageString.home,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate(AppString.Home),
                    style: TextStyle(color: AppColor.whiteColor),
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Image(image: ImageString.latest),
                  title: Text(
                    AppLocalizations.of(context)!.translate(AppString.News),
                    style: TextStyle(color: AppColor.whiteColor),
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Image(
                    image: ImageString.search,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate(AppString.Search),
                    style: TextStyle(color: AppColor.whiteColor),
                  ),
                ),
              ],
              currentIndex: _currentIndex,
              onTap: (int index) {
                _selectTab(pageKeys[index], index);
              },
            ),
            crossFadeState:
                value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: hideDuration,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem, {Function(bool)? callback}) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        tabCallback: (value) {
          callback!(value);
        },
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
