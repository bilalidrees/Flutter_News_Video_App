import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/constant/route_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/main_category_bloc/category_bloc.dart';
import 'package:samma_tv/presentation/page/news/news_details.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:samma_tv/presentation/widget/custom_list_tile.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> _list;
  final TabController _tabController;

  const CustomTabBar(this._list, this._tabController, {Key? key})
      : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget._list.length, // length of tabs
        initialIndex: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  child: TabBar(
                    controller: widget._tabController,
                    isScrollable: true,
                    labelColor: AppColor.GradTwo,
                    indicatorColor: AppColor.GradTwo,
                    unselectedLabelColor: AppColor.greyColor,
                    tabs: widget._list.map((e) => Tab(text: e)).toList(),
                  ),
                ),
                const Divider(height: 0.0,thickness: 1.5),
              ]),
        ));
  }
}

