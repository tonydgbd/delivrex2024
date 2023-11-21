import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  const CustomButton({Key? key, this.onTap, required this.btnTxt, this.backgroundColor, this.textStyle, this.borderRadius = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null ? Theme.of(context).hintColor.withOpacity(0.7) : backgroundColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(MediaQuery.of(context).size.width, 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    return TextButton(
      onPressed: onTap as void Function()?,
      style: flatButtonStyle,
      child: Text(btnTxt??"",
          style: textStyle ?? Theme.of(context).textTheme.displaySmall!.copyWith(color:Colors.white, fontSize: Dimensions.fontSizeLarge)),
    );
  }
}
