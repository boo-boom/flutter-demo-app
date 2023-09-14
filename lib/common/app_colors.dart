import 'package:flutter/material.dart';
import 'package:flutter_demo_app/util/color_transform.dart';

class AppColors {
  static const Color primaryColor = Color.fromRGBO(255, 22, 58, 1);
  static const Color backgroundColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color black15 = Color.fromRGBO(0, 0, 0, 0.15);
  static const Color black45 = Color.fromRGBO(0, 0, 0, 0.45);
  static const Color black65 = Color.fromRGBO(0, 0, 0, 0.65);
  static const Color black85 = Color.fromRGBO(0, 0, 0, 0.85);
  static const Color pink = Color.fromRGBO(255, 230, 230, 1);
  // Material主色调
  static MaterialColor primary = ColorTransform.createMaterialColor(primaryColor);
  // Material白色
  static MaterialColor white = ColorTransform.createMaterialColor(Colors.white);
}
