import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {

  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF585a5c) : const Color(0xFFF4F7FC);
  }
  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF343636) : const Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF98a1ab) : const Color(0xFF52575C);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFE4E8EC) : const Color(0xFF25282B);
  }


  static Color getCartTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFF61699b) : const Color(0xFF000743);
  }


  static Color getProfileMenuHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  footerCol0r.withOpacity(0.5) : footerCol0r;
  }
  static Color getFooterColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFF494949) :const Color(0xFFFFDDD9);
  }


  static const Color colorNero = Color(0xFF1F1F1F);
  static const Color searchBg = Color(0xFFF4F7FC);
  static const Color borderColor = Color(0xFFDCDCDC);
  static const Color footerCol0r = Color(0xFFFFDDD9);
  static const Color cardShadowColor = Color(0xFFA7A7A7);



}
