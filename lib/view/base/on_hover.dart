import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:provider/provider.dart';

class OnHover extends StatefulWidget {

  final Widget Function(bool isHovered) builder;

  const OnHover({Key? key, required this.builder}) : super(key: key);

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final isLtr = Provider.of<LocalizationProvider>(context).isLtr;
    // on hover animation movement matrix translation
    final matrixLtr =  Matrix4.identity()..translate(2,0,0);
    final matrixRtl =  Matrix4.identity()..translate(-2,0,0);
    final transform = isHovered ? isLtr ? matrixLtr : matrixRtl : Matrix4.identity();

    // when user enter the mouse pointer onEnter method will work
    // when user exit the mouse pointer from MouseRegion onExit method will work
    return MouseRegion(
      onEnter: (_) {
        //debugPrint('On Entry hover');
        onEntered(true);
      },
      onExit: (_){
        onEntered(false);
       // debugPrint('On Exit hover');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: transform,             // animation transformation hovered.
        child: widget.builder(isHovered,),   // build the widget passed from main.dart
      ),
    );
  }

  //used to set bool isHovered to true/false
  void onEntered(bool isHovered){
    setState(() {
      this.isHovered = isHovered;
    });
  }
}