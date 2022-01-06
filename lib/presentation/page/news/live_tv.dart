import 'package:flutter/material.dart';
import 'package:samma_tv/presentation/page/news/video_app.dart';
import 'package:samma_tv/tab_navigator.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/presentation/widget/gradiant_appbar.dart';

class LiveTv extends StatefulWidget {
  const LiveTv({Key? key}) : super(key: key);

  @override
  _LiveTvState createState() => _LiveTvState();
}

class _LiveTvState extends State<LiveTv> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: GradiantAppBar(
              title: Image(image: ImageString.samaaTextLogo, height: 30),
              action: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.search),
                )
              ],
            ),
            body: Align(
                alignment: Alignment.center,
                child: FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoApp('dada')));
                    },
                    child: Text("Switch Page - Leave a Like")))));
    ;
  }
}
