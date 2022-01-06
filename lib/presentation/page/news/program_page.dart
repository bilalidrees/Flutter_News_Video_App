import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samma_tv/constant/app_contants.dart';
import 'package:samma_tv/constant/app_string.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/dependency_injection.dart';
import 'package:samma_tv/presentation/bloc/program_bloc/program_episode_bloc/program_episode_bloc.dart';
import 'package:samma_tv/presentation/widget/custom_loader.dart';
import 'package:samma_tv/source/model/program_response.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:samma_tv/presentation/page/news/video_detail_page.dart';
import 'package:samma_tv/presentation/widget/custom_list_tile.dart';
import 'package:samma_tv/presentation/widget/custom_text_widget.dart';
import 'package:samma_tv/presentation/widget/gradiant_appbar.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:share/share.dart';

class ProgramPage extends StatefulWidget {
  final Programs? programs;
  final Programs? currentEpisode;
  final ProgramResponse? programResponse;

  const ProgramPage(
      {Key? key, this.programs, this.currentEpisode, this.programResponse})
      : super(key: key);

  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  final episode = sl<ProgramEpisodeBloc>();
  String sharedLink = "";

  @override
  void initState() {
    if (widget.currentEpisode != null && widget.programResponse != null) {
      episode
          .add(GetCurrentProgramsList(programResponse: widget.programResponse));
    } else {
      episode.add(GetProgramsEpisodeList(url: widget.programs!.url));
    }
    super.initState();
  }

  @override
  void dispose() {
    episode.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GradiantAppBar(
          title: Text(
            "PROGRAMS",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          action: [
            GestureDetector(
                onTap: () {
                  Share.share(widget.currentEpisode != null
                      ? widget.currentEpisode!.sharingUrl!
                      : sharedLink);
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
        body: BlocBuilder<ProgramEpisodeBloc, ProgramEpisodeState>(
          bloc: episode,
          builder: (context, state) {
            if (state is ProgramEpisodeInitial) return const SizedBox.shrink();
            if (state is ProgramEpisodeLoading) return const CustomLoader();
            if (state is ProgramEpisodeLoaded) {
              sharedLink =
                  state.programResponse.programsEpisodes!.first.sharingUrl!;
              return _ProgramBody(
                programResponse: state.programResponse,
                currentEpisode: widget.currentEpisode,
              );
            }

            if (state is ProgramEpisodeError)
              return CustomTextWidget(AppString.error);
            return CustomTextWidget(AppString.someThingWentWrong);
          },
        ),
      ),
    );
  }
}

class _ProgramBody extends StatelessWidget {
  final ProgramResponse programResponse;
  final Programs? currentEpisode;

  const _ProgramBody(
      {Key? key, required this.programResponse, this.currentEpisode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VideoDetailPage(
            url: currentEpisode != null
                ? currentEpisode!.youtubeUrl!
                : programResponse.programsEpisodes!.first.youtubeUrl!),
        Expanded(
            child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstant.pageSidePadding, vertical: 3),
              child: CustomTextWidget(
                currentEpisode != null
                    ? currentEpisode!.title
                    : programResponse.programsEpisodes!.first.title,
                isFromApi: true,
                textAlign: TextAlign.left,
                fontWeight: EnumText.bold,
                fontSize: 15,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 7),
              child: Image(
                image: ImageString.adImage,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 0.1),
            for (var index = 0;
                index < programResponse.programsEpisodes!.length;
                index++)
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProgramPage(
                              currentEpisode:
                                  programResponse.programsEpisodes![index],
                              programResponse: programResponse)));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                  child: CustomListTile(
                    programs: programResponse.programsEpisodes![index],
                  ),
                ),
              )
          ],
        )),
      ],
    );
  }
}
