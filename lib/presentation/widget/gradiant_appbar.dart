import 'package:flutter/material.dart';
import 'package:samma_tv/constant/image_string.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';

class GradiantAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? action;
  GlobalKey<ScaffoldState>? scaffoldKey;

  GradiantAppBar(
      {GlobalKey<ScaffoldState>? scaffoldKey, this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      actions: action,
      title: title != null ? title : SizedBox(),
      flexibleSpace: Image(
        height: 80,
        image: ImageString.appbar,
        fit: BoxFit.cover,
      ),
      backgroundColor: AppColor.GradOne,
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [AppColor.GradOne, AppColor.GradTwo],
      //   )),
      // ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}

class _SquigglyLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final Paint _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final Path _path = Path();
    _path.moveTo(0.0, height);
    _path.quadraticBezierTo(width / 2, height / 2, width, 0);

    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
