import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:samma_tv/presentation/bloc/main_category_bloc/category_bloc.dart';
import 'package:samma_tv/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:samma_tv/presentation/theme/app_theme.dart';
import 'package:samma_tv/route_generator.dart';
import 'app_localizations.dart';
import 'constant/route_string.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final theme = sl<ThemeBloc>();
  final locale = sl<LocalizationBloc>();
  @override
  void initState() {
    scheduleMicrotask((){
      precacheImage(ImageString.samaaTextLogo, context);
      precacheImage(ImageString.samaaLive, context);
      precacheImage(ImageString.appbar, context);
    });
    super.initState();
  }


  @override
  void dispose() {
    theme.close();
    //locale.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeMode>(
      bloc: theme,
      builder: (context,themeState){
        return BlocBuilder<LocalizationBloc,Locale>(
          bloc: locale,
          builder: (context,locateState)=>MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState,
            builder: (context, widget) => ResponsiveWrapper.builder(
              ClampingScrollWrapper.builder(context, widget!),
              maxWidth: 1200,
              minWidth: 350,
              defaultScale: true,
              breakpoints: const [
                ResponsiveBreakpoint.resize(350, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ur', 'PK'),
            ],
            locale: locateState,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            initialRoute: RouteString.initialPage,
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      },
    );
  }
}