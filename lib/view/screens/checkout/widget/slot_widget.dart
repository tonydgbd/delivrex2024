import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SlotWidget extends StatelessWidget {
  final String? title;
  final bool isSelected;
  final Function onTap;
  const SlotWidget({Key? key, required this.title, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [BoxShadow(
              color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200]!,
              spreadRadius: 0.5, blurRadius: 0.5,
            )],
          ),
          child: Text(
            title!,
            style: rubikRegular.copyWith(color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
      ),
    );
  }
}
