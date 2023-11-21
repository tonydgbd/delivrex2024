import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';


class SetMenuScreen extends StatelessWidget {
  const SetMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(true);

    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('set_menu', context)),
      body: Consumer<SetMenuProvider>(
        builder: (context, setMenu, child) {
          return setMenu.setMenuList != null ? setMenu.setMenuList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(true);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: setMenu.setMenuList!.length,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 13,
                          childAspectRatio:  1/1.2,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 2),
                      itemBuilder: (context, index) {
                        double? startingPrice;
                        // double? endingPrice;
                        // if(setMenu.setMenuList[index].choiceOptions.length != 0) {
                        //   List<double> _priceList = [];
                        //   setMenu.setMenuList[index].variations.forEach((variation) => _priceList.add(variation.price));
                        //   _priceList.sort((a, b) => a.compareTo(b));
                        //   _startingPrice = _priceList[0];
                        //   if(_priceList[0] < _priceList[_priceList.length-1]) {
                        //     _endingPrice = _priceList[_priceList.length-1];
                        //   }
                        // }else {
                        //   _startingPrice = setMenu.setMenuList[index].price;
                        // }
                        startingPrice = setMenu.setMenuList![index].price;

                        double discount = setMenu.setMenuList![index].price! - PriceConverter.convertWithDiscount(
                            setMenu.setMenuList![index].price, setMenu.setMenuList![index].discount, setMenu.setMenuList![index].discountType)!;

                        bool isAvailable = DateConverter.isAvailable(setMenu.setMenuList![index].availableTimeStarts!, setMenu.setMenuList![index].availableTimeEnds!, context);

                        return Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                            return InkWell(
                              onTap: () {
                               ResponsiveHelper.isMobile() ? showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(
                                 product: setMenu.setMenuList![index], fromSetMenu: true,
                                 callback: (CartModel cartModel) {
                                   showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                                 },
                               )
                               ): showDialog(context: context, builder: (con) => Dialog(
                                 backgroundColor: Colors.transparent,
                                 child: CartBottomSheet(
                                   product: setMenu.setMenuList![index], fromSetMenu: true,
                                   callback: (CartModel cartModel) {
                                     showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                                   },
                                 ),
                               ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                                      blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                      spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                    )]
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderRectangle, height: 110, width: MediaQuery.of(context).size.width/2, fit: BoxFit.cover,
                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenu.setMenuList![index].image}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, height: 110, width: MediaQuery.of(context).size.width/2, fit: BoxFit.cover),
                                        ),
                                      ),
                                      isAvailable ? const SizedBox() : Positioned(
                                        top: 0, left: 0, bottom: 0, right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                          child: Text(getTranslated('not_available_now', context)!, textAlign: TextAlign.center, style: rubikRegular.copyWith(
                                            color: Colors.white, fontSize: Dimensions.fontSizeSmall,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Text(
                                          setMenu.setMenuList![index].name!,
                                          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                          maxLines: 2, overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                        RatingBar(
                                          rating: setMenu.setMenuList![index].rating!.isNotEmpty ? double.parse(setMenu.setMenuList![index].rating![0].average!) : 0.0,
                                          size: 12,
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomDirectionality(child: Text(
                                              PriceConverter.convertPrice(startingPrice, discount: setMenu.setMenuList![index].discount,
                                                  discountType: setMenu.setMenuList![index].discountType),
                                              style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                            )),

                                            discount > 0 ? const SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge!.color),
                                          ],
                                        ),

                                        discount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          CustomDirectionality(child: Text(
                                            PriceConverter.convertPrice(startingPrice),
                                            style: rubikBold.copyWith(
                                              fontSize: Dimensions.fontSizeExtraSmall,
                                              color: Theme.of(context).hintColor.withOpacity(0.7),
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          )),

                                          Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge!.color),
                                        ]) : const SizedBox(),
                                      ]),
                                    ),
                                  ),

                                ]),
                              ),
                            );
                          }
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : const NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
