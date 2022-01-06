import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samma_tv/constant/app_contants.dart';
import 'package:flutter/rendering.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/presentation/bloc/main_category_bloc/category_bloc.dart';
import 'package:samma_tv/presentation/bloc/program_bloc/program_episode_bloc/program_episode_bloc.dart';
import 'package:samma_tv/presentation/bloc/program_bloc/program_listing_bloc/program_listing_bloc.dart';
import 'package:samma_tv/presentation/bloc/samaa_category_news_bloc/samaa_category_news_bloc.dart';
import 'package:samma_tv/presentation/bloc/youtube_live_bloc/youtube_live_bloc.dart';
import 'package:samma_tv/presentation/page/news/program_page.dart';
import 'package:samma_tv/presentation/page/news/video_detail_page.dart';
import 'package:samma_tv/presentation/widget/category_news_widget.dart';
import 'package:samma_tv/presentation/widget/drawer_widget.dart';
import 'package:samma_tv/presentation/widget/custom_loader.dart';
import 'package:samma_tv/presentation/widget/gradiant_appbar.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';
import 'package:samma_tv/presentation/widget/tab_appbar.dart';

class MainNewsPage extends StatefulWidget {
  Function(bool)? callback;

  MainNewsPage({Key? key, this.callback}) : super(key: key);

  @override
  _MainNewsPageState createState() => _MainNewsPageState();
}

class _MainNewsPageState extends State<MainNewsPage>
    with SingleTickerProviderStateMixin {
  bool? isImageShow = true;
  final category = sl<CategoryBloc>();
  final youtubeLiveUrl = sl<YoutubeLiveBloc>();
  final categoryByName = sl<SamaaCategoryNewsBloc>();
  final programs = sl<ProgramListingBloc>();
  var local = sl<LocalizationBloc>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isLiveClicked = ValueNotifier(false);
  late final ScrollController scrollController;
  late final TabController tabController;
  late String appBarTitle;

  @override
  void dispose() {
    category.close();
    categoryByName.close();
    youtubeLiveUrl.close();
    programs.close();
    scrollController.removeListener(() {});
    print('MainNewsPage disposed');
    super.dispose();
  }

  @override
  void initState() {
    print('MainNewsPage initalized');
    scrollController = ScrollController();
    category.add(const GetMainCategory());
    youtubeLiveUrl.add(const GetYoutubeLive());
    programs.add(GetProgramsList());
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // widget.callback!(false);
        print('forward');
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        print('reverse');
        // widget.callback!(true);
      } else {
        print('else');
      }
    });
    super.initState();
  }

  void callNewsDetail(CategoryLoaded state, int index) {
    appBarTitle = state.mainCategory.catsMain[index];
    categoryByName.add(GetSamaaCategoryNewsByName(
        categoryName: state.mainCategory.catsMain[index]));
  }

  void watchLive() {
    isLiveClicked.value = !isLiveClicked.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          isImageShow: isImageShow,
          category: category,
        ),
        appBar: GradiantAppBar(
          title: Image(image: ImageString.samaaTextLogo, height: 30),
          action: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isImageShow = !isImageShow!;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Icon(
                  Icons.search,
                  size: 20,
                ),
              ),
            )
          ],
        ),
        body: ListView(
          controller: scrollController,
          children: [
            GestureDetector(
              onTap: watchLive,
              child: ValueListenableBuilder<bool>(
                builder: (context, value, child) {
                  if (value) {
                    return BlocBuilder<YoutubeLiveBloc, YoutubeLiveState>(
                      bloc: youtubeLiveUrl,
                      builder: (context, state) {
                        if (state is YoutubeLiveInitial) {
                          return SizedBox.shrink();
                        } else if (state is YoutubeLiveLoading) {
                          return const CustomLoader();
                        } else if (state is YoutubeLiveLoaded) {
                          return VideoDetailPage(
                              url: state.youTubeLive.url.url);
                        } else if (state is YoutubeLiveError) {
                          return CustomTextWidget(AppString.error);
                        } else {
                          return CustomTextWidget(AppString.someThingWentWrong);
                        }
                      },
                    );
                  } else {
                    return const Image(
                      image: ImageString.samaaLive,
                      height: 230,
                      fit: BoxFit.fill,
                    );
                  }
                },
                valueListenable: isLiveClicked,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
              child: Image(
                image: ImageString.adImage,
                fit: BoxFit.fitWidth,
              ),
            ),
            //categoryTab
            BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryLoaded) {
                  tabController = TabController(
                      length: state.mainCategory.catsMain.length, vsync: this);
                  callNewsDetail(state, 0);
                  tabController.addListener(() {
                    if (tabController.indexIsChanging) {
                      // tab is animating. from active (getting the index) to inactive(getting the index)
                    } else {
                      //tab is finished animating you get the current index
                      //here you can get your index or run some method once.
                      callNewsDetail(state, tabController.index);
                    }
                  });
                }
              },
              bloc: category,
              builder: (context, state) {
                if (state is CategoryInitial) {
                  return SizedBox.shrink();
                } else if (state is CategoryLoading) {
                  return CustomLoader();
                } else if (state is CategoryLoaded) {
                  return CustomTabBar(
                      state.mainCategory.catsMain, tabController);
                } else if (state is CategoryError) {
                  return CustomTextWidget(AppString.error);
                } else {
                  return CustomTextWidget(AppString.error);
                }
              },
            ),
            BlocConsumer<SamaaCategoryNewsBloc, SamaaCategoryNewsState>(
              listener: (context, state) {},
              bloc: categoryByName,
              builder: (context, state) {
                if (state is SamaaCategoryNewsInitial) {
                  return SizedBox.shrink();
                } else if (state is SamaaCategoryNewsLoading) {
                  return CustomLoader();
                } else if (state is SamaaCategoryNewsLoaded) {
                  return CategoryNewsWidget(
                      samaaCategoryNews: state.samaaCategoryNews,
                      appBarTitle: appBarTitle);
                } else if (state is SamaaCategoryNewsError) {
                  return CustomTextWidget(AppString.error);
                } else {
                  return CustomTextWidget(AppString.error);
                }
              },
            ),
            if (local.state.languageCode != "en") SizedBox(height: 15),
            if (local.state.languageCode == "en")
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.pageSidePadding, vertical: 4),
                child: CustomTextWidget(
                  AppString.Programs,
                  textAlign: TextAlign.left,
                  fontWeight: EnumText.bold,
                  fontSize: 19,
                ),
              ),
            if (local.state.languageCode == "en")
              BlocConsumer<ProgramListingBloc, ProgramListingState>(
                listener: (context, state) {},
                bloc: programs,
                builder: (context, state) {
                  if (state is ProgramListingInitial) {
                    return SizedBox.shrink();
                  } else if (state is ProgramListingLoading) {
                    return CustomLoader();
                  } else if (state is ProgramListingLoaded) {
                    return Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListView.builder(
                          itemCount: state.programResponse.programs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index % 3 == 0) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProgramPage(
                                              programs: state.programResponse
                                                  .programs[index])));
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 120,
                                  child: state.programResponse.programs[index]
                                          .image.isNotEmpty
                                      ? FadeInImage.assetNetwork(
                                          placeholder: "assets/image/dummy.png",
                                          image: state.programResponse
                                              .programs[index].image,
                                          fit: BoxFit.fill,
                                        )
                                      : Image(
                                          image: ImageString.PlaceHolder,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              );
                            } else {
                              int current = index;
                              int currentPlusOne = index + 1;
                              if (index.isOdd) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProgramPage(
                                                      programs: state
                                                          .programResponse
                                                          .programs[current],
                                                    )));
                                      },
                                      child: SizedBox(
                                        height: 75,
                                        width: 150,
                                        child: state
                                                .programResponse
                                                .programs[current]
                                                .image
                                                .isNotEmpty
                                            ? FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/image/dummy.png",
                                                image: state.programResponse
                                                    .programs[current].image,
                                                fit: BoxFit.fill,
                                              )
                                            : Image(
                                                image: ImageString.PlaceHolder,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    currentPlusOne <
                                            state
                                                .programResponse.programs.length
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ProgramPage(
                                                            programs: state
                                                                    .programResponse
                                                                    .programs[
                                                                currentPlusOne],
                                                          )));
                                            },
                                            child: SizedBox(
                                              height: 75,
                                              width: 150,
                                              child: state
                                                      .programResponse
                                                      .programs[currentPlusOne]
                                                      .image
                                                      .isNotEmpty
                                                  ? FadeInImage.assetNetwork(
                                                      placeholder:
                                                          "assets/image/dummy.png",
                                                      image: state
                                                          .programResponse
                                                          .programs[
                                                              currentPlusOne]
                                                          .image,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image(
                                                      image: ImageString
                                                          .PlaceHolder,
                                                      fit: BoxFit.fill),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          }),
                    );
                  } else if (state is ProgramListingError) {
                    return CustomTextWidget(AppString.error);
                  } else {
                    return CustomTextWidget(AppString.error);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
