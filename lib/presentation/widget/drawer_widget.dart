import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/constant/route_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/presentation/bloc/main_category_bloc/category_bloc.dart';
import 'package:samma_tv/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:samma_tv/presentation/page/news/national_page/national_page.dart';
import 'package:samma_tv/presentation/page/news/news_details.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:samma_tv/presentation/widget/custom_loader.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';
import 'package:samma_tv/presentation/widget/restart_widget.dart';

class CustomDrawer extends StatefulWidget {
  bool? isImageShow;
  final CategoryBloc category;
  CustomDrawer({Key? key, this.isImageShow,required this.category}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget _animatedContainer(String text, bool isSelected, Function() onTap) =>
      GestureDetector(
        onTap: isSelected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 25,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: isSelected ? Colors.lightGreen[400] : Colors.white),
          child: CustomTextWidget(text,
              color: isSelected ? AppColor.whiteColor : AppColor.blackColor,
              fontSize: 12,
              fontWeight: EnumText.semiBold),
        ),
      );

  final theme = sl<ThemeBloc>();
  final locale = sl<LocalizationBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        margin: const EdgeInsets.only(top: 60),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColor.GradOne, AppColor.GradTwo],
        )),
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              const CustomTextWidget(
                AppString.categories,
                color: AppColor.whiteColor,
                fontSize: 20,
                fontWeight: EnumText.semiBold,
                verticalPadding: 15,
                letterSpacing: 1,
              ),
            ])),

            BlocBuilder<CategoryBloc, CategoryState>(
              bloc: widget.category,
              builder: (context, state) {
                if (state is CategoryInitial)
                  return SliverToBoxAdapter(child: SizedBox.shrink());
                if (state is CategoryLoading)
                  return SliverToBoxAdapter(child: CustomLoader());
                if (state is CategoryLoaded)
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => _DrawerItem(
                                text: state.mainCategory.catsMain[index],
                                routeString: state.mainCategory.catsMain[index],
                                image: widget.isImageShow!
                                    ? DrawerItemModel.itemList[index].image
                                    : null,
                              ),
                          childCount: state.mainCategory.catsMain.length));
                if (state is CategoryError)
                  return SliverToBoxAdapter(
                      child: CustomTextWidget(AppString.error));
                return SliverToBoxAdapter(
                    child: CustomTextWidget(AppString.someThingWentWrong));
              },
            ),
            //lang and darkMode
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image(image: ImageString.moon, width: 15),
                        SizedBox(width: 10),
                        CustomTextWidget(AppString.darkMode,
                            color: AppColor.whiteColor,
                            fontWeight: EnumText.semiBold,
                            fontSize: 16),
                        Spacer(),
                        Transform.scale(
                          scale: 0.7,
                          child: BlocBuilder<ThemeBloc, ThemeMode>(
                              bloc: theme,
                              builder: (context, state) {
                                return CupertinoSwitch(
                                  activeColor: AppColor.greyColor,
                                  value:
                                      state == ThemeMode.light ? false : true,
                                  onChanged: (bool val) {
                                    val
                                        ? sl<ThemeBloc>()
                                            .add(const SetDarkTheme())
                                        : sl<ThemeBloc>()
                                            .add(const SetLightTheme());
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                    CustomTextWidget(
                      AppString.language,
                      color: AppColor.whiteColor,
                      fontWeight: EnumText.semiBold,
                      fontSize: 16,
                      verticalPadding: 15,
                    ),
                    BlocBuilder<LocalizationBloc, Locale>(
                      bloc: locale,
                      builder: (context, state) => Row(
                        children: [
                          _animatedContainer(
                              AppString.eng, state.countryCode == 'US', () {
                            locale.add(const SetLocale(
                                countryCode: 'US', languageCode: 'en'));
                            RestartWidget.restartApp(context);
                            Navigator.pop(context);
                          }),
                          SizedBox(width: 15.0),
                          _animatedContainer(
                              AppString.urdu, state.countryCode == 'PK', () {
                            locale.add(const SetLocale(
                                countryCode: 'PK', languageCode: 'ur'));
                            RestartWidget.restartApp(context);
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class _DrawerItem extends StatelessWidget {
  final ImageProvider? image;
  final String text;
  final String routeString;

  const _DrawerItem(
      {Key? key, required this.text, this.image, required this.routeString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4.5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.whiteColor, width: 0.1),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailScreen(appBarTitle: routeString, data: null)));
        },
        child: Row(
          children: [
            image == null
                ? const SizedBox.shrink()
                : Image(image: image!, width: 22),
            const SizedBox(width: 12),
            CustomTextWidget(text,
                isFromApi: true,
                color: AppColor.whiteColor,
                fontWeight: EnumText.semiBold,
                fontSize: 16)
          ],
        ),
      ),
    );
  }
}

class DrawerItemModel {
  final ImageProvider? image;
  final String text;
  final String routeString;

  const DrawerItemModel(
      {this.image, required this.text, required this.routeString});

  static List<DrawerItemModel> itemList = [
    DrawerItemModel(
        text: AppString.latest,
        image: ImageString.latest,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.pakistan,
        image: ImageString.pakistan,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.lifeAndStyle,
        image: ImageString.lifeAndStyle,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.money,
        image: ImageString.money,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.sports,
        image: ImageString.sports,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.technology,
        image: ImageString.technology,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.video,
        image: ImageString.video,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.programs,
        image: ImageString.programs,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.education,
        image: ImageString.education,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.entertainment,
        image: ImageString.entertainment,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.global,
        image: ImageString.global,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.health,
        image: ImageString.health,
        routeString: RouteString.initialPage),
    DrawerItemModel(
        text: AppString.share,
        image: ImageString.health,
        routeString: RouteString.initialPage),
  ];
}

enum EnumLocale { US, PK }
