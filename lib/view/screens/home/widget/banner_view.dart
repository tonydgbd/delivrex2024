import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TitleWidget(title: getTranslated('banner', context)),
        ),

        SizedBox(
          height: 85,
          child: Consumer<BannerProvider>(
            builder: (context, banner, child) {
              return banner.bannerList != null ? banner.bannerList!.isNotEmpty ? ListView.builder(
                itemCount: banner.bannerList!.length,
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                      return InkWell(
                        onTap: () {
                          if(banner.bannerList![index].productId != null) {
                            Product? product;
                            for(Product prod in banner.productList) {
                              if(prod.id == banner.bannerList![index].productId) {
                                product = prod;
                                break;
                              }
                            }
                            if(product != null) {
                              ResponsiveHelper.isMobile() ? showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (con) => CartBottomSheet(
                                  product: product,
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBar(getTranslated('added_to_cart', context),isError: false);
                                  },
                                ),
                              ): showDialog(context: context, builder: (con) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: CartBottomSheet(
                                  product: product,
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBar(getTranslated('added_to_cart', context),isError: false);
                                  },
                                ),
                              ));

                            }

                          }else if(banner.bannerList![index].categoryId != null) {
                            CategoryModel? category;
                            for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
                              if(categoryModel.id == banner.bannerList![index].categoryId) {
                                category = categoryModel;
                                break;
                              }
                            }
                            if(category != null) {
                              Navigator.pushNamed(context, Routes.getCategoryRoute(category));
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                              blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                              spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                            )],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderBanner, width: 250, height: 85, fit: BoxFit.cover,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.bannerList![index].image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderBanner, width: 250, height: 85, fit: BoxFit.cover),
                            ),
                          ),
                        )
                      );
                    }
                  );
                },
              ) : Center(child: Text(getTranslated('no_banner_available', context)!)) : const BannerShimmer();
            },
          ),
        ),
      ],
    );
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250, height: 85,
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
              )],
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

