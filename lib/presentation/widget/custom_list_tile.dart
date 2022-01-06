import 'package:flutter/material.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';
import 'package:samma_tv/presentation/widget/playIconWdiget.dart';
import 'package:samma_tv/source/model/program_response.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';

class CustomListTile extends StatelessWidget {
  final News? news;
  final Programs? programs;

  const CustomListTile({Key? key, this.news, this.programs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.1))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: CustomTextWidget(
                    news != null ? news!.title : programs!.title,
                    isFromApi: true,
                    fontSize: 12.5,
                    fontWeight: EnumText.semiBold,
                    textAlign: TextAlign.left,
                    horizontalPadding: 10,
                    verticalPadding: 10,
                  ),
                ),
                Expanded(
                  child: CustomTextWidget(
                      (news != null && news!.articlePublishedTime != null)
                          ? news!.articlePublishedTime!
                          : programs!.articlePublishedTime ?? "",
                      isFromApi: true,
                      textAlign: TextAlign.left,
                      fontSize: 10.0,
                      horizontalPadding: 10,
                      color: AppColor.greyColor),
                ),
              ],
            ),
          ),
          Container(
            width: 160,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: news != null
                      ? news!.image.isNotEmpty
                          ? FadeInImage.assetNetwork(
                              placeholder: "assets/image/dummy.png",
                              image: news!.image,
                              fit: BoxFit.fill,
                            )
                          : Image(image: ImageString.PlaceHolder)
                      : programs!.image.isNotEmpty
                          ? FadeInImage.assetNetwork(
                              placeholder: "assets/image/dummy.png",
                              image: programs!.image,
                              fit: BoxFit.fill,
                            )
                          : Image(image: ImageString.PlaceHolder),
                ),
                if (news != null &&
                    (news!.videourl.endsWith(".mp4") ||
                        (news!.youtubeUrl != "None" &&
                            news!.youtubeUrl != null)))
                  PlayIconWidget(),
                if (programs != null &&
                    (programs!.videoUrl!.endsWith(".mp4") ||
                        (programs!.youtubeUrl != "None" &&
                            programs!.youtubeUrl != null)))
                  PlayIconWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
