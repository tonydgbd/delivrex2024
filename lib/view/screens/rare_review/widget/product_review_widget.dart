import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';

class ProductReviewWidget extends StatelessWidget {
  final List<OrderDetailsModel> orderDetailsList;
  const ProductReviewWidget({Key? key, required this.orderDetailsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: SizedBox(
                      width: 1170,
                      child: ListView.builder(
                        itemCount: orderDetailsList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))],
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            ),
                            child: Column(
                              children: [

                                // Product details
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholderImage, height: 70, width: 85, fit: BoxFit.cover,
                                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${orderDetailsList[index].productDetails!.image}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 70, width: 85, fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(orderDetailsList[index].productDetails!.name!, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 10),

                                        CustomDirectionality(child: Text(
                                          PriceConverter.convertPrice(orderDetailsList[index].productDetails!.price),
                                          style: rubikBold,
                                        )),
                                      ],
                                    )),
                                    Row(children: [
                                      Text(
                                        '${getTranslated('quantity', context)}: ',
                                        style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        orderDetailsList[index].quantity.toString(),
                                        style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ],
                                ),
                                const Divider(height: 20),

                                // Rate
                                Text(
                                  getTranslated('rate_the_food', context)!,
                                  style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        child: Icon(
                                          productProvider.ratingList[index] < (i + 1) ? Icons.star_border : Icons.star,
                                          size: 25,
                                          color: productProvider.ratingList[index] < (i + 1)
                                              ? Theme.of(context).hintColor.withOpacity(0.7)
                                              : Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {
                                          if(!productProvider.submitList[index]) {
                                            Provider.of<ProductProvider>(context, listen: false).setRating(index, i + 1);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                Text(
                                  getTranslated('share_your_opinion', context)!,
                                  style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                CustomTextField(
                                  maxLines: 3,
                                  capitalization: TextCapitalization.sentences,
                                  isEnabled: !productProvider.submitList[index],
                                  hintText: getTranslated('write_your_review_here', context),
                                  fillColor: ColorResources.getSearchBg(context),
                                  onChanged: (text) {
                                    productProvider.setReview(index, text);
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Submit button
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                  child: Column(
                                    children: [
                                      !productProvider.loadingList[index] ? CustomButton(
                                        btnTxt: getTranslated(productProvider.submitList[index] ? 'submitted' : 'submit', context),
                                        backgroundColor: productProvider.submitList[index] ? Theme.of(context).hintColor.withOpacity(0.7) : Theme.of(context).primaryColor,
                                        onTap: () {
                                          if(!productProvider.submitList[index]) {
                                            if (productProvider.ratingList[index] == 0) {
                                              showCustomSnackBar('Give a rating');
                                            } else if (productProvider.reviewList[index].isEmpty) {
                                              showCustomSnackBar('Write a review');
                                            } else {
                                              FocusScopeNode currentFocus = FocusScope.of(context);
                                              if (!currentFocus.hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              ReviewBody reviewBody = ReviewBody(
                                                productId: orderDetailsList[index].productId.toString(),
                                                rating: productProvider.ratingList[index].toString(),
                                                comment: productProvider.reviewList[index],
                                                orderId: orderDetailsList[index].orderId.toString(),
                                              );
                                              productProvider.submitReview(index, reviewBody).then((value) {
                                                if (value.isSuccess) {
                                                  showCustomSnackBar(value.message, isError: false);
                                                  productProvider.setReview(index, '');
                                                } else {
                                                  showCustomSnackBar(value.message);
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if(ResponsiveHelper.isDesktop(context)) const Padding(
                  padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  child: FooterView(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
