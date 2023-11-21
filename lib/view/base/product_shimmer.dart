import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  const ProductShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
          blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
          spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
        )],
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnabled,
        child: Row(children: [
          Container(
            height: 70, width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(height: 15, width: double.maxFinite, color: Theme.of(context).shadowColor),
            const SizedBox(height: 5),
            const RatingBar(rating: 0.0, size: 12),
            const SizedBox(height: 10),
            Container(height: 10, width: 50, color: Theme.of(context).shadowColor),
          ])),
          const SizedBox(width: 10),

           Column(children: [
            Icon(Icons.favorite_border, color: Colors.grey),
            Expanded(child: SizedBox()),
            Icon(Icons.add, color: Colors.black),
          ]),

        ]),
      ),
    );
  }
}
