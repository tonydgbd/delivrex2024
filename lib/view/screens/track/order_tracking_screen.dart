import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/time_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/track/widget/custom_stepper.dart';
import 'package:flutter_restaurant/view/screens/track/widget/delivery_man_widget.dart';
import 'package:flutter_restaurant/view/screens/track/widget/tracking_map_widget.dart';
import 'package:provider/provider.dart';

import 'widget/timer_view.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  const OrderTrackingScreen({Key? key, required this.orderID,}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final TimerProvider timerProvider = Provider.of<TimerProvider>(context, listen: false);


    Provider.of<LocationProvider>(context, listen: false).initAddressList();
    orderProvider.getDeliveryManData(widget.orderID);

    orderProvider.trackOrder(widget.orderID, null, true).whenComplete(() {
      if(orderProvider.trackModel != null){
        timerProvider.countDownTimer(orderProvider.trackModel!, context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final List<String> statusList = ['pending', 'confirmed', 'processing' ,'out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'];

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('order_tracking', context))) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.paddingSizeLarge,
                  right: Dimensions.paddingSizeLarge,
                  bottom: Dimensions.paddingSizeLarge,
                  top: ResponsiveHelper.isMobile() ? 0 : Dimensions.paddingSizeLarge
                ),
                child: Center(
                  child: Consumer<OrderProvider>(
                    builder: (context, order, child) {
                      String? status;
                      if(order.trackModel != null) {
                        status = order.trackModel!.orderStatus;
                      }

                      if(status != null && status == statusList[5] || status == statusList[6] || status == statusList[7]) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(status!),
                            const SizedBox(height: 50),
                            CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                            }),
                          ],
                        );
                      } else if(order.responseModel != null && !order.responseModel!.isSuccess) {
                        return const Center(child: NoDataScreen());
                      }


                      return status != null ? RefreshIndicator(
                        onRefresh: () async {
                          await orderProvider.getDeliveryManData(widget.orderID);
                          await orderProvider.trackOrder(widget.orderID, null, true);
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        child: SingleChildScrollView(
                          child: Center(
                            child: Container(
                              // width: _width > 700 ? 700 : _width,
                              padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                              decoration: width > 700 ? BoxDecoration(
                                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                              ) : null,
                              child: SizedBox(
                                width: 1170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    if(status == statusList[0] ||
                                        status == statusList[1] ||
                                        status == statusList[2] ||
                                        status == statusList[3]) const TimerView(),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    order.trackModel!.deliveryMan != null ? DeliveryManWidget(deliveryMan: order.trackModel!.deliveryMan) : const SizedBox(),

                                    order.trackModel!.deliveryMan != null ? const SizedBox(height: 30) : const SizedBox(),

                                    CustomStepper(
                                      title: getTranslated('order_placed', context),
                                      isActive: true,
                                      haveTopBar: false,
                                    ),
                                    CustomStepper(
                                      title: getTranslated('order_accepted', context),
                                      isActive: status != statusList[0],
                                    ),
                                    CustomStepper(
                                      title: getTranslated('preparing_food', context),
                                      isActive: status != statusList[0] && status != statusList[1],
                                    ),
                                    order.trackModel!.orderType != 'take_away' ? CustomStepper(
                                      title: getTranslated('food_in_the_way', context),
                                      isActive: status != statusList[0] && status != statusList[1] && status != statusList[2],
                                    ) : const SizedBox(),
                                    CustomStepper(
                                      title: getTranslated('delivered_the_food', context),
                                      isActive: status == statusList[4], height: status == statusList[3] ? 240 : 30,
                                      child: status == statusList[3] ? Builder(
                                        builder: (context) {
                                          AddressModel? address;
                                          for(int i = 0 ; i< Provider.of<LocationProvider>(context, listen: false).addressList!.length; i++) {
                                            if(Provider.of<LocationProvider>(context, listen: false).addressList![i].id == order.trackModel!.deliveryAddressId) {
                                              address = Provider.of<LocationProvider>(context, listen: false).addressList![i];
                                            }
                                          }
                                          return TrackingMapWidget(
                                            deliveryManModel: order.deliveryManModel,
                                            orderID: widget.orderID,
                                            addressModel: address,
                                          );
                                        }
                                      ) : null,
                                    ),
                                    const SizedBox(height: 50),

                                  ResponsiveHelper.isDesktop(context) ? Center(
                                      child: SizedBox(
                                        width: 400,
                                        child: CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                                          Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                        }),
                                      ),
                                    ) : CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                  }),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) : Center(
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                    },
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) const FooterView(),
          ],
        ),
      ),
    );
  }
}
