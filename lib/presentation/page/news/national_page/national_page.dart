import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:samma_tv/constant/app_contants.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/presentation/bloc/national_feed_bloc/national_feed_bloc.dart';
import 'package:samma_tv/presentation/bloc/samaa_category_news_bloc/samaa_category_news_bloc.dart';
import 'package:samma_tv/presentation/bloc/theme_bloc/theme_bloc.dart';
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

class NationalPage extends StatefulWidget {
  final News? news;
  final MyNews? nationalFeedList;
  final SamaaCategoryNews? samaaCategoryNews;

  const NationalPage(
      {Key? key, this.news, this.nationalFeedList, this.samaaCategoryNews})
      : super(key: key);

  @override
  _NationalPageState createState() => _NationalPageState();
}

class _NationalPageState extends State<NationalPage> {
  final nationalFeed = sl<NationalFeedBloc>();
  final categoryByName = sl<SamaaCategoryNewsBloc>();
  final ValueNotifier<bool> isExpanded = ValueNotifier(true);

  @override
  void initState() {
    if (sl<LocalizationBloc>().state.languageCode == 'en') {
      if (widget.news == null && widget.nationalFeedList == null) {
        nationalFeed.add(const GetNationalFeed());
      } else {
        nationalFeed
            .add(GetCurrentNationalFeed(myNews: widget.nationalFeedList!));
      }
    } else {
      if (widget.news == null && widget.samaaCategoryNews == null)
        categoryByName.add(GetSamaaCategoryNewsByName(categoryName: 'پاکستان'));
      else {
        categoryByName.add(GetSamaaCategoryNewsUrdu(
            samaaCategoryNews: widget.samaaCategoryNews!));
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    nationalFeed.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return sl<LocalizationBloc>().state.languageCode == 'en'
        ? BlocBuilder<NationalFeedBloc, NationalFeedState>(
            bloc: nationalFeed,
            builder: (context, state) {
              if (state is NationalFeedInitial) {
                return const SizedBox.shrink();
              } else if (state is NationalFeedLoading) {
                return const CustomLoader();
              } else if (state is NationalFeedLoaded) {
                return _NationalPageLayout(
                  currentNews: widget.news == null ? null : widget.news,
                  nationalFeed: state.myNews,
                );
              } else if (state is NationalFeedError) {
                return CustomTextWidget(AppString.error);
              } else {
                return CustomTextWidget(AppString.someThingWentWrong);
              }
            })
        : BlocConsumer<SamaaCategoryNewsBloc, SamaaCategoryNewsState>(
            listener: (context, state) {},
            bloc: categoryByName,
            builder: (context, state) {
              if (state is SamaaCategoryNewsInitial) {
                return SizedBox.shrink();
              } else if (state is SamaaCategoryNewsLoading) {
                return CustomLoader();
              } else if (state is SamaaCategoryNewsLoaded) {
                if (state.samaaCategoryNews.myNews != null &&
                    state.samaaCategoryNews.myNews.data.isNotEmpty) {
                  return SafeArea(
                    child: Scaffold(
                      appBar: GradiantAppBar(
                        title: CustomTextWidget(
                          AppString.Pakistan,
                          color: AppColor.whiteColor,
                          fontWeight: EnumText.semiBold,
                        ),
                        action: [
                          GestureDetector(
                              onTap: () {
                                Share.share(widget.news != null
                                    ? widget.news!.link
                                    : state.samaaCategoryNews.myNews.data.first
                                        .link);
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
                      body: Column(
                        children: [
                          if (widget.news == null)
                            Expanded(
                              child: state.samaaCategoryNews.myNews.data.first
                                      .videourl
                                      .endsWith(".mp4")
                                  ? VideoApp(state.samaaCategoryNews.myNews.data
                                      .first.videourl)
                                  : (state.samaaCategoryNews.myNews.data.first
                                                  .youtubeUrl !=
                                              "None" &&
                                          state.samaaCategoryNews.myNews.data
                                                  .first.youtubeUrl !=
                                              null)
                                      ? VideoDetailPage(
                                          url:
                                              "${state.samaaCategoryNews.myNews.data.first.youtubeUrl}")
                                      : Image(
                                          image: ImageString.PlaceHolder,
                                          height: 230,
                                          fit: BoxFit.fill,
                                        ),
                            ),
                          if (widget.news != null)
                            Expanded(
                              child: widget.news!.videourl.endsWith(".mp4")
                                  ? VideoApp(widget.news!.videourl)
                                  : (widget.news!.youtubeUrl != "None" &&
                                          widget.news!.youtubeUrl != null)
                                      ? VideoDetailPage(
                                          url: "${widget.news!.youtubeUrl}")
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
                                              horizontal:
                                                  AppConstant.pageSidePadding,
                                              vertical: 4),
                                          child: CustomTextWidget(
                                            widget.news == null
                                                ? state.samaaCategoryNews.myNews
                                                    .data.first.title
                                                : widget.news!.title,
                                            isFromApi: true,
                                            textAlign: TextAlign.left,
                                            fontWeight: EnumText.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  AppConstant.pageSidePadding,
                                              vertical: 0),
                                          child: ValueListenableBuilder<bool>(
                                            builder: (context, value, child) =>
                                                HtmlParserWidget(
                                              isExpanded: value,
                                              htmlText: widget.news == null
                                                  ? state.samaaCategoryNews
                                                      .myNews.data.first.desc
                                                  : widget.news!.desc,
                                            ),
                                            valueListenable: isExpanded,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Center(
                                            child: ValueListenableBuilder<bool>(
                                          valueListenable: isExpanded,
                                          builder: (context, value, child) =>
                                              GestureDetector(
                                            onTap: () {
                                              isExpanded.value =
                                                  !isExpanded.value;
                                            },
                                            child: CustomTextWidget(
                                              value
                                                  ? AppString.readMore
                                                  : AppString.readLess,
                                              fontSize: 12,
                                              color: AppColor.GradOne,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ])),
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                        final data = state.samaaCategoryNews
                                            .myNews.data[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NationalPage(
                                                          news: data,
                                                          samaaCategoryNews: state
                                                              .samaaCategoryNews,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 4),
                                            child: CustomListTile(news: data),
                                          ),
                                        );
                                      },
                                              childCount: state
                                                  .samaaCategoryNews
                                                  .myNews
                                                  .data
                                                  .length))
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              } else if (state is SamaaCategoryNewsError) {
                return CustomTextWidget(AppString.error);
              } else {
                return CustomTextWidget(AppString.error);
              }
            },
          );
  }
}

class _NationalPageLayout extends StatefulWidget {
  final MyNews nationalFeed;
  final News? currentNews;

  const _NationalPageLayout(
      {Key? key, required this.nationalFeed, this.currentNews})
      : super(key: key);

  @override
  State<_NationalPageLayout> createState() => _NationalPageLayoutState();
}

class _NationalPageLayoutState extends State<_NationalPageLayout> {
  final ValueNotifier<bool> _valueNotifier = ValueNotifier(true);

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  void _seeMore() {
    _valueNotifier.value = !_valueNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradiantAppBar(
        title: CustomTextWidget(
          AppString.national,
          color: AppColor.whiteColor,
          fontWeight: EnumText.semiBold,
        ),
        action: [
          GestureDetector(
              onTap: () {
                Share.share(widget.currentNews != null
                    ? widget.currentNews!.link
                    : widget.nationalFeed.national.first.link);
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
      body: SafeArea(
        child: getNewsLayout(widget.currentNews != null
            ? widget.currentNews!
            : widget.nationalFeed.national.first),
      ),
    );
  }

  Widget getNewsLayout(News news) {
    return Column(
      children: [
        news.videourl.endsWith(".mp4")
            ? SizedBox(
                width: double.infinity,
                height: 200,
                child: VideoApp(news.videourl))
            : (news.youtubeUrl != "None" && news.youtubeUrl != null)
                ? VideoDetailPage(url: "${news.youtubeUrl}")
                : news.image.isNotEmpty
                    ? FadeInImage.assetNetwork(
                        placeholder: "assets/image/dummy.png",
                        image: news.image,
                      )
                    : Image(
                        image: ImageString.PlaceHolder,
                        height: 230,
                        fit: BoxFit.fill,
                      ),
        Expanded(
            child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              CustomTextWidget(
                news.title,
                isFromApi: true,
                textAlign: TextAlign.left,
                fontWeight: EnumText.semiBold,
                verticalPadding: 4,
                fontSize: 20,
                horizontalPadding: AppConstant.pageSidePadding,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.pageSidePadding, vertical: 3),
                child: ValueListenableBuilder<bool>(
                  builder: (context, value, child) => HtmlParserWidget(
                    htmlText: news.desc,
                    isExpanded: value,
                  ),
                  valueListenable: _valueNotifier,
                ),
              ),
              TextButton(
                  onPressed: _seeMore,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _valueNotifier,
                    builder: (context, value, child) {
                      return CustomTextWidget(
                        value ? AppString.readMore : AppString.readLess,
                        fontSize: 12,
                        color: AppColor.greyColor,
                        decoration: TextDecoration.underline,
                      );
                    },
                  )),
              SizedBox(height: 10),
              Divider(height: 0.1)
            ])),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              final data = widget.nationalFeed.national[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NationalPage(
                                news: data,
                                nationalFeedList: widget.nationalFeed,
                              )));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                  child: CustomListTile(news: data),
                ),
              );
            }, childCount: widget.nationalFeed.national.length)),
          ],
        )),
      ],
    );
  }
}
