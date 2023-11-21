import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ProductTypeView extends StatelessWidget {
  final String? productType;
  const ProductTypeView({Key? key, this.productType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isVegNonVegActive = Provider.of<SplashProvider>(context, listen: false).configModel!.isVegNonVegActive!;
    return productType == null ||  !isVegNonVegActive ? const SizedBox() : Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0 ,vertical: 2),
        child: Text(getTranslated(productType, context,
        )!, style: robotoRegular.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}