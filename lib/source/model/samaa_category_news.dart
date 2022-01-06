class SamaaCategoryNews {
  late MyNews myNews;

  SamaaCategoryNews({required this.myNews});

  SamaaCategoryNews.fromJson(Map<String, dynamic> json) {
    myNews = (json['my_news'] != null
        ? new MyNews.fromJson(json['my_news'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myNews != null) {
      data['my_news'] = this.myNews.toJson();
    }
    return data;
  }
}

class MyNews {
  late List<News> data;
  late List<News> national;

  MyNews({required this.data});

  MyNews.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <News>[];
      json['data'].forEach((v) {
        data.add(new News.fromJson(v));
      });
    } else {
      data = [];
    }
    if (json['National'] != null) {
      national = <News>[];
      json['National'].forEach((v) {
        national.add(new News.fromJson(v));
      });
    } else {
      national = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.national != null) {
      data['National'] = this.national.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class News {
  late dynamic id;
  late String title;
  late String desc;
  late String youtubeIframe;
  late String youtubeUrl;
  late String pubDate;
  late String link;
  late String image;
  late String videourl;
  late String category;
  late String? articlePublishedTime;

  News(
      {required this.id,
      required this.title,
      required this.desc,
      required this.youtubeIframe,
      required this.youtubeUrl,
      required this.pubDate,
      required this.link,
      required this.image,
      required this.videourl,
      required this.category,
      this.articlePublishedTime});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    youtubeIframe =
        json['youtube-iframe'] != null ? json['youtube-iframe'] : null;
    youtubeUrl = json['youtube-url'] != null ? json['youtube-url'] : null;
    pubDate = json['pubDate'];
    link = json['link'];
    image = json['image'];
    videourl = json['videourl'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['youtube-iframe'] = this.youtubeIframe;
    data['youtube-url'] = this.youtubeUrl;
    data['pubDate'] = this.pubDate;
    data['link'] = this.link;
    data['image'] = this.image;
    data['videourl'] = this.videourl;
    data['category'] = this.category;
    return data;
  }
}
