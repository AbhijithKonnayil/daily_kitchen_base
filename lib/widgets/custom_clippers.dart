import 'package:flutter/rendering.dart';

class OfferClipper  extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    var path =Path();
    path.lineTo(size.width-10, 0);
    path.lineTo(size.width, size.height/2);
    path.lineTo(size.width-10, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }

}