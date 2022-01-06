class ProgramResponse {
  late  List<Programs> programs;

  late  List<Programs>? programsEpisodes;

  ProgramResponse({required this.programs});

  ProgramResponse.fromJson(Map<String, dynamic> json) {
    if (json['Programs'] != null) {
      programs = [];
      json['Programs'].forEach((v) {
        programs.add(new Programs.fromJson(v));
      });
    } else {
      programs = [];
    }
    if (json['Program-Episodes'] != null) {
      programsEpisodes = [];
      json['Program-Episodes'].forEach((v) {
        programsEpisodes!.add(new Programs.fromJson(v));
      });
    } else {
      //programsEpisodes = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Programs'] = this.programs.map((v) => v.toJson()).toList();
    data['Program-Episodes'] =
        this.programsEpisodes!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Programs {
  late final String id;
  late final String title;
  late final String url;
  late final String? videoUrl;
  late final String duration;
  late final String image;
  late final String timings;
  late final String? youtubeUrl;
  late final String? pubDate;
  late final String? sharingUrl;
  late String? articlePublishedTime;

  Programs(
      {required this.id,
      required this.title,
      required this.url,
      this.videoUrl,
      required this.duration,
      required this.image,
      required this.timings,
      this.youtubeUrl,
      this.pubDate,
      this.sharingUrl,
      this.articlePublishedTime});

  Programs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    videoUrl = json['videourl'];
    duration = json['duration'];
    image = json['image'];
    timings = json['timings'];
    youtubeUrl = json['youtube-url'];
    pubDate = json['pubDate'];
    sharingUrl = json['sharingurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['videourl'] = this.videoUrl;
    data['duration'] = this.duration;
    data['image'] = this.image;
    data['timings'] = this.timings;
    data['youtube-url'] = this.youtubeUrl;
    data['pubDate'] = this.pubDate;
    data['sharingurl'] = this.sharingUrl;
    return data;
  }
}
