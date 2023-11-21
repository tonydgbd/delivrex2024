import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            width: 1170,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1, blurRadius: 5,
              )],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: Provider.of<OrderProvider>(context).runningOrderList == null,
              child: Column(children: [

                Row(children: [
                  Container(
                    height: 70, width: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).shadowColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 15, width: 150, color: Theme.of(context).shadowColor),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Container(height: 15, width: 100, color: Theme.of(context).shadowColor),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Container(height: 15, width: 130, color: Theme.of(context).shadowColor),
                  ]),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Expanded(child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(10),

                    ),
                  )),
                  const SizedBox(width: 20),
                  Expanded(child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(10)),
                  )),
                ]),

              ]),
            ),
          ),
        );
      },
    );
  }
}
