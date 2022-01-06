class MainCategory {
  late List<String> catsMain;

  MainCategory({required this.catsMain});

  MainCategory.fromJson(Map<String, dynamic> json) {
    catsMain = json['cats_main'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cats_main'] = this.catsMain;
    return data;
  }
}