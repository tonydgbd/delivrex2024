import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import 'widget/button_view.dart';
import 'widget/details_view.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  const OrderDetailsScreen({Key? key, required this.orderModel, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();


  void _loadData(BuildContext context) async {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await orderProvider.trackOrder(widget.orderId.toString(), widget.orderModel, false);
    if(widget.orderModel == null) {
      await splashProvider.initConfig();
    }
    await locationProvider.initAddressList();
    await orderProvider.getOrderDetails(widget.orderId.toString());
  }

  @override
  void initState() {
    super.initState();

    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffold,
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('order_details', context))) as PreferredSizeWidget?,

      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double? deliveryCharge = 0;
          double itemsPrice = 0;
          double discount = 0;
          double tax = 0;
          double addOns = 0;
          double extraDiscount = 0;
          if(order.orderDetails != null && order.orderDetails!.isNotEmpty) {
            if(order.trackModel!.orderType == 'delivery') {
              deliveryCharge = order.trackModel!.deliveryCharge;
            }
            for(OrderDetailsModel orderDetails in order.orderDetails!) {
              List<double> addonPrices = orderDetails.addOnPrices ?? [];
              List<int> addonsIds = orderDetails.addOnIds != null ? orderDetails.addOnIds! : [];

              if(addonsIds.length == addonPrices.length &&
                  addonsIds.length == orderDetails.addOnQtys?.length){
                for(int i = 0; i < addonsIds.length; i++){
                  addOns = addOns + (addonPrices[i] * orderDetails.addOnQtys![i]);
                }
              }
              itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              discount = discount + (orderDetails.discountOnProduct! * orderDetails.quantity!);
              tax = (tax + (orderDetails.taxAmount! * orderDetails.quantity!)) + orderDetails.addOnTaxAmount!;
            }
          }

          if( order.trackModel != null &&  order.trackModel!.extraDiscount!=null) {
            extraDiscount  = order.trackModel!.extraDiscount ?? 0.0;
          }
          double subTotal = itemsPrice + tax + addOns;
          double total = itemsPrice + addOns - discount - extraDiscount + tax + deliveryCharge! - (order.trackModel != null
              ? order.trackModel!.couponDiscountAmount! : 0);



          return !order.isLoading && order.orderDetails != null  ?
          order.orderDetails!.isNotEmpty ?
          ResponsiveHelper.isDesktop(context) ?
          SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: !ResponsiveHelper.isDesktop(context) && height < 600
                        ? height : height - 400,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(width: 1170,
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: width > 700 ? 700 : width,
                                padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                                decoration: width > 700 ? BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )],
                                ) : null,
                                child: const DetailsView(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(width: 400,
                                padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                                decoration: width > 700 ? BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )],
                                ) : null,

                                child: _amountView(
                                  context, itemsPrice, tax,
                                  addOns, subTotal, discount,
                                  order, extraDiscount,
                                  deliveryCharge, total,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                ResponsiveHelper.isDesktop(context)? const FooterView() : const SizedBox()
              ],
            ),
          ) :
          Column(
            children: [

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const DetailsView(),

                      _amountView(
                        context, itemsPrice, tax,
                        addOns, subTotal, discount,
                        order, extraDiscount,
                        deliveryCharge, total,
                      ),
                    ]),
                  ),
                ),
              ),

              const ButtonView(),



            ],
          ) : const NoDataScreen()
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),);
        },
      ),
    );
  }


  Widget _amountView(
      BuildContext context,
      double itemsPrice,
      double tax,
      double addOns,
      double subTotal,
      double discount,
      OrderProvider order,
      double extraDiscount,
      double? deliveryCharge,
      double total,
      ) {
    return Column(children: [

      ItemView(
        title: getTranslated('items_price', context)!,
        subTitle: PriceConverter.convertPrice(itemsPrice),
      ),
      const SizedBox(height: 10),

      ItemView(
        title: getTranslated('tax', context)!,
        subTitle: '(+) ${PriceConverter.convertPrice( tax)}',
      ),
      const SizedBox(height: 10),

      ItemView(
        title: getTranslated('addons', context)!,
        subTitle: '(+) ${PriceConverter.convertPrice(addOns)}',
      ),

      const Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: CustomDivider(),
      ),

      ItemView(
        title: getTranslated('subtotal', context)!,
        subTitle: PriceConverter.convertPrice(subTotal),
        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
      ),
      const SizedBox(height: 10),

      ItemView(
        title: getTranslated('discount', context)!,
        subTitle: '(-) ${PriceConverter.convertPrice(discount)}',
      ),
      const SizedBox(height: 10),

      ///....Extra discount..
      (order.trackModel!.orderType=="pos" || order.trackModel!.orderType=="dine_in") ?
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ItemView(
          title: getTranslated('extra_discount', context)!,
          subTitle: '(-) ${PriceConverter.convertPrice(extraDiscount)}',
          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ):const SizedBox(),

      ItemView(
        title: getTranslated('coupon_discount', context)!,
        subTitle: '(-) ${PriceConverter.convertPrice(order.trackModel!.couponDiscountAmount)}',
      ),
      const SizedBox(height: 10),

      ItemView(
        title: getTranslated('delivery_fee', context)!,
        subTitle: '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
      ),


      const Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: CustomDivider(),
      ),

      ItemView(
        title: getTranslated('total_amount', context)!,
        subTitle: PriceConverter.convertPrice(total),
        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),
      ),

      if(ResponsiveHelper.isDesktop(context)) const ButtonView(),

    ],
    );
  }


}



