// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samma_tv/constant/app_contants.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/samaa_category_news_bloc/samaa_category_news_bloc.dart';
import 'package:samma_tv/presentation/bloc/samaa_related_news_bloc/samaa_related_news_bloc.dart';
import 'package:samma_tv/presentation/page/news/video_app.dart';
import 'package:samma_tv/presentation/page/news/video_detail_page.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:samma_tv/presentation/widget/custom_list_tile.dart';
import 'package:samma_tv/presentation/widget/custom_loader.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';
import 'package:samma_tv/presentation/widget/gradiant_appbar.dart';
import 'package:samma_tv/presentation/widget/html_parser.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:share/share.dart';

class NewsDetailScreen extends StatefulWidget {
  final String appBarTitle;
  final News? data;

  NewsDetailScreen({Key? key, required this.appBarTitle, this.data})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NewsDetailScreen> {
  final hideDuration = const Duration(milliseconds: 800);
  final ValueNotifier<bool> isExpanded = ValueNotifier(true);
  final relatedNews = sl<SamaaRelatedNewsBloc>();
  final categoryByName = sl<SamaaCategoryNewsBloc>();
  String sharedLink = "";

  @override
  void initState() {
    if (widget.data != null) {
      relatedNews.add(GetSamaaRelatedNewsById(id: widget.data!.id));
    } else {
      categoryByName
          .add(GetSamaaCategoryNewsByName(categoryName: widget.appBarTitle));
    }
    super.initState();
  }

  @override
  void dispose() {
    isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: GradiantAppBar(
            title: CustomTextWidget(
              widget.appBarTitle.toUpperCase(),
              isFromApi: true,
              color: AppColor.whiteColor,
              fontWeight: EnumText.semiBold,
            ),
            action: [
              GestureDetector(
                  onTap: () {
                    Share.share(
                        widget.data != null ? widget.data!.link : sharedLink);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    height: 5,
                    width: 15,
                    child: Image(
                      image: ImageString.share,
                    ),
                  ))
            ],
          ),
          body: widget.data == null
              ? BlocConsumer<SamaaCategoryNewsBloc, SamaaCategoryNewsState>(
                  listener: (context, state) {
                    if (state is SamaaCategoryNewsLoaded) {
                      if (state.samaaCategoryNews.myNews != null &&
                          state.samaaCategoryNews.myNews.data.isNotEmpty)
                        relatedNews.add(GetSamaaRelatedNewsById(
                            id: state.samaaCategoryNews.myNews.data.first.id));
                    }
                  },
                  bloc: categoryByName,
                  builder: (context, state) {
                    if (state is SamaaCategoryNewsInitial) {
                      return SizedBox.shrink();
                    } else if (state is SamaaCategoryNewsLoading) {
                      return CustomLoader();
                    } else if (state is SamaaCategoryNewsLoaded) {
                      if (state.samaaCategoryNews.myNews != null &&
                          state.samaaCategoryNews.myNews.data.isNotEmpty) {
                        sharedLink =
                            state.samaaCategoryNews.myNews.data.first.link;
                        return buildNewsWidget(
                            state.samaaCategoryNews.myNews.data.first);
                      } else {
                        return SizedBox(
                          child: Center(
                              child: CustomTextWidget(
                                  AppString.Amazingcontentcommingsoon)),
                        );
                      }
                    } else if (state is SamaaCategoryNewsError) {
                      return CustomTextWidget(AppString.error);
                    } else {
                      return CustomTextWidget(AppString.error);
                    }
                  },
                )
              : buildNewsWidget(widget.data!)),
    );
  }

  Column buildNewsWidget(News? data) {
    return Column(
      children: [
        Expanded(
          child: data!.videourl.endsWith(".mp4")
              ? VideoApp(data.videourl)
              : (data.youtubeUrl != "None" && data.youtubeUrl != null)
                  ? VideoDetailPage(url: "${data.youtubeUrl}")
                  : Image(
                      image: ImageString.PlaceHolder,
                      height: 230,
                      fit: BoxFit.fill,
                    ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: double.infinity,
                height: 360,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.pageSidePadding,
                            vertical: 4),
                        child: CustomTextWidget(
                          data.title,
                          isFromApi: true,
                          textAlign: TextAlign.left,
                          fontWeight: EnumText.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.pageSidePadding,
                            vertical: 0),
                        child: ValueListenableBuilder<bool>(
                          builder: (context, value, child) => HtmlParserWidget(
                            isExpanded: value,
                            htmlText: data.desc,
                          ),
                          valueListenable: isExpanded,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: ValueListenableBuilder<bool>(
                        valueListenable: isExpanded,
                        builder: (context, value, child) => GestureDetector(
                          onTap: () {
                            isExpanded.value = !isExpanded.value;
                          },
                          child: CustomTextWidget(
                            value ? AppString.readMore : AppString.readLess,
                            fontSize: 12,
                            color: AppColor.greyColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.pageSidePadding,
                            vertical: 4),
                        child: CustomTextWidget(
                          AppString.RelatedStories,
                          textAlign: TextAlign.left,
                          fontWeight: EnumText.bold,
                          fontSize: 19,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(height: 0.1),
                    ])),
                    SliverToBoxAdapter(
                      child: BlocConsumer<SamaaRelatedNewsBloc,
                          SamaaRelatedNewsState>(
                        builder: (context, state) {
                          if (state is SamaaRelatedNewsInitial) {
                            return SizedBox.shrink();
                          } else if (state is SamaaRelatedNewsLoading) {
                            return const CustomLoader();
                          } else if (state is SamaaRelatedNewsLoaded) {
                            if (state.samaaRelatedNews.seeMore.isNotEmpty)
                              return ListView.builder(
                                itemCount:
                                    state.samaaRelatedNews.seeMore.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final data =
                                      state.samaaRelatedNews.seeMore[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => NewsDetailScreen(
                                                  appBarTitle:
                                                      widget.appBarTitle,
                                                  data: data)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 4),
                                      child: CustomListTile(
                                        news: data,
                                      ),
                                    ),
                                  );
                                },
                              );
                            else
                              return SizedBox(
                                height: 100,
                                child: Center(
                                  child:
                                      CustomTextWidget(AppString.NothingToShow),
                                ),
                              );
                          } else if (state is SamaaRelatedNewsError) {
                            return CustomTextWidget(AppString.error);
                          } else {
                            return CustomTextWidget(
                                AppString.someThingWentWrong);
                          }
                        },
                        listener: (context, state) {},
                        bloc: relatedNews,
                      ),
                    ),
                  ],
                ))),
      ],
    );
  }
}
