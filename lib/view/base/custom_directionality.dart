import 'package:flutter/material.dart';

class CustomDirectionality extends StatelessWidget {
  final Widget child;
  const CustomDirectionality({Key? key,  required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}