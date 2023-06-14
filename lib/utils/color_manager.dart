import 'dart:ui';

class ColorManager {
  static const Color headerText = Color(0xffcbefb6);
  static const Color buttonPrimaryColor = Color(0xffFF92B9);
  static const Color backBtnColor = Color(0xff79CDF9);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}