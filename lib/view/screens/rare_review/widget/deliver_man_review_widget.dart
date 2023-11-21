import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/track/widget/delivery_man_widget.dart';
import 'package:provider/provider.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final String orderID;
  const DeliveryManReviewWidget({Key? key, required this.deliveryMan, required this.orderID}) : super(key: key);

  @override
  State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: SizedBox(
                      width: 1170,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        widget.deliveryMan != null ? DeliveryManWidget(deliveryMan: widget.deliveryMan) : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 5, spreadRadius: 1,
                            )],
                          ),
                          child: Column(children: [
                            Text(
                              getTranslated('rate_his_service', context)!,
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
                                      productProvider.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                                      size: 25,
                                      color: productProvider.deliveryManRating < (i + 1)
                                          ? Theme.of(context).hintColor.withOpacity(0.7)
                                          : Theme.of(context).primaryColor,
                                    ),
                                    onTap: () {
                                      if(!Provider.of<ProductProvider>(context, listen: false).isReviewSubmitted) {
                                        Provider.of<ProductProvider>(context, listen: false).setDeliveryManRating(i + 1);
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
                              maxLines: 5,
                              capitalization: TextCapitalization.sentences,
                              controller: _controller,
                              hintText: getTranslated('write_your_review_here', context),
                              fillColor: ColorResources.getSearchBg(context),
                            ),
                            const SizedBox(height: 40),

                            // Submit button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Column(
                                children: [
                                  !productProvider.isLoading ? CustomButton(
                                    btnTxt: getTranslated(productProvider.isReviewSubmitted ? 'submitted' : 'submit', context),
                                    onTap: productProvider.isReviewSubmitted ? null : () {
                                      if (productProvider.deliveryManRating == 0) {
                                        showCustomSnackBar('Give a rating');
                                      } else if (_controller.text.isEmpty) {
                                        showCustomSnackBar('Write a review');
                                      } else {
                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        ReviewBody reviewBody = ReviewBody(
                                          deliveryManId: widget.deliveryMan!.id.toString(),
                                          rating: productProvider.deliveryManRating.toString(),
                                          comment: _controller.text,
                                          orderId: widget.orderID,
                                        );
                                        productProvider.submitDeliveryManReview(reviewBody).then((value) {
                                          if (value.isSuccess) {
                                            showCustomSnackBar(value.message, isError: false);
                                            _controller.text = '';
                                          } else {
                                            showCustomSnackBar(value.message);
                                          }
                                        });
                                      }
                                    },
                                  ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                ],
                              ),
                            ),
                          ]),
                        ),

                      ]),
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
