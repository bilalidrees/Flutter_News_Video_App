import 'dart:math';

import 'package:flutter/material.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/constant/route_string.dart';
import 'package:samma_tv/presentation/page/news/news_details.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:samma_tv/presentation/widget/custom_list_tile.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';

class CategoryNewsWidget extends StatefulWidget {
  final SamaaCategoryNews samaaCategoryNews;
  final String appBarTitle;

  const CategoryNewsWidget(
      {Key? key, required this.samaaCategoryNews, required this.appBarTitle})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CategoryNewsWidget> {
  final ValueNotifier<bool> isExpanded = ValueNotifier(true);

  @override
  void dispose() {
    isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ValueListenableBuilder<bool>(
              builder: (context, value, child) {
                if (widget.samaaCategoryNews.myNews != null &&
                    widget.samaaCategoryNews.myNews.data.isNotEmpty) {
                  return SizedBox(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data =
                            widget.samaaCategoryNews.myNews.data[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NewsDetailScreen(
                                          appBarTitle: widget.appBarTitle,
                                          data: data)));
                            },
                            child: CustomListTile(news: data));
                      },
                      itemCount: isExpanded.value
                          ? widget.samaaCategoryNews.myNews.data.length > 3
                              ? 3
                              : widget.samaaCategoryNews.myNews.data.length
                          : widget.samaaCategoryNews.myNews.data.length,
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    child: Center(child: CustomTextWidget(AppString.NothingToShow)),
                  );
                }
              },
              valueListenable: isExpanded,
            ),
            SizedBox(height: 10),
            Center(
                child: ValueListenableBuilder<bool>(
              valueListenable: isExpanded,
              builder: (context, value, child) => GestureDetector(
                onTap: () {
                  isExpanded.value = !isExpanded.value;
                },
                child: CustomTextWidget(
                  value ? AppString.SeeMore : AppString.SeeLess,
                  fontSize: 13,
                  color: AppColor.greyColor,
                ),
              ),
            )),
          ]),
    );
  }
}
