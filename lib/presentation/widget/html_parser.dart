import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:samma_tv/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dependency_injection.dart';

class HtmlParserWidget extends StatelessWidget {
  const HtmlParserWidget(
      {Key? key, required this.htmlText, required this.isExpanded})
      : super(key: key);
  final String htmlText;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: parse(htmlText).outerHtml,
      onLinkTap: (link, renderContext, map, element) async {
        if (link != null && link.isNotEmpty) {
          if (await canLaunch(link)) {
            await launch(
              link,
            );
          } else {
            throw 'Could not launch $link';
          }
        }
      },
      style: {
        'body': Style(
            color: sl<ThemeBloc>().state == ThemeMode.light
                ? AppColor.blackColor
                : AppColor.whiteColor,
            maxLines: isExpanded ? 3 : null)
      },
    );
  }
}
