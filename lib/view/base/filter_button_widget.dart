import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';


class FilterButtonWidget extends StatelessWidget {
  final String type;
  final List<String> items;
  final bool isBorder;
  final bool isSmall;
  final Function(String value) onSelected;

  const FilterButtonWidget({Key? key, 
    required this.type, required this.onSelected, required this.items,  this.isBorder = false, this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool ltr = Provider.of<LocalizationProvider>(context) .isLtr;
    bool isVegFilter = Provider.of<ProductProvider>(context).productTypeList == items;

    return  Consumer<SplashProvider>(
      builder: (c, splashProvider, _) {
        return Visibility(
          visible: splashProvider.configModel!.isVegNonVegActive!,
          child: Align(alignment: Alignment.center, child: Container(
            height: ResponsiveHelper.isMobile() ? 35 : 40,
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            decoration: isBorder ? null : BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onSelected(items[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    margin: isBorder ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall) : EdgeInsets.zero,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: isBorder ? const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)) : BorderRadius.horizontal(
                        left: Radius.circular(
                          ltr ? index == 0 && items[index] != type ? Dimensions.radiusSmall : 0
                              : index == items.length-1
                              ? Dimensions.radiusSmall : 0,
                        ),
                        right: Radius.circular(
                          ltr ? index == items.length-1 &&  items[index] != type
                              ? Dimensions.radiusSmall : 0 : index == 0
                              ? Dimensions.radiusSmall : 0,
                        ),
                      ),
                      color: items[index] == type ? Theme.of(context).primaryColor
                          : Theme.of(context).canvasColor,

                    border: isBorder ?  Border.all(width: 1.3, color: Theme.of(context).primaryColor.withOpacity(0.4)) : null ,
                    ),
                    child: Row(
                      children: [
                        items[index] != items[0] && isVegFilter ? Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Image.asset(
                            Images.getImageUrl(items[index]),
                          ),
                        ) : const SizedBox(),
                        Text(
                          getTranslated(items[index], context)!,
                          style: items[index] == type
                              ? robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)
                              : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          )),
        );
      }
    );
  }
}

