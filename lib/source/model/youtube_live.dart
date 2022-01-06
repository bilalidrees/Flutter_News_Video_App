class YouTubeLive {
  late Url url;

  YouTubeLive({required this.url});

  YouTubeLive.fromJson(Map<String, dynamic> json) {
    url = (json['url'] != null ? new Url.fromJson(json['url']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.url != null) {
      data['url'] = this.url.toJson();
    }
    return data;
  }
}

class Url {
  late String url;

  Url({required this.url});

  Url.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
