import 'package:flutter/material.dart';

class NewsImageWidget extends StatelessWidget {
  String url;

  NewsImageWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: 300,
        child: Image.network(
          url,
          fit: BoxFit.fitWidth,
        ));
  }
}
