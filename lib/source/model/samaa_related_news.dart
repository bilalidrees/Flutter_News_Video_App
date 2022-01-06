import 'package:samma_tv/source/model/samaa_category_news.dart';

class SamaaRelatedNews {
  late List<News> seeMore;

  SamaaRelatedNews({required this.seeMore});

  SamaaRelatedNews.fromJson(Map<String, dynamic> json) {
    if (json['See-More'] != null) {
      seeMore = <News>[];
      json['See-More'].forEach((v) {
        seeMore.add(new News.fromJson(v));
      });
    } else {
      seeMore = <News>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.seeMore != null) {
      data['See-More'] = this.seeMore.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class SeeMore {
//   late int id;
//   late String title;
//   late String desc;
//   late String pubDate;
//   late String link;
//   late String image;
//   late String videourl;
//   late String category;
//
//   SeeMore(
//       {required this.id,
//       required this.title,
//       required this.desc,
//       required this.pubDate,
//       required this.link,
//       required this.image,
//       required this.videourl,
//       required this.category});
//
//   SeeMore.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     desc = json['desc'];
//     pubDate = json['pubDate'];
//     link = json['link'];
//     image = json['image'];
//     videourl = json['videourl'];
//     category = json['category'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['desc'] = this.desc;
//     data['pubDate'] = this.pubDate;
//     data['link'] = this.link;
//     data['image'] = this.image;
//     data['videourl'] = this.videourl;
//     data['category'] = this.category;
//     return data;
//   }
// }
