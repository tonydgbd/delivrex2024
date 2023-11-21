
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/rare_review/widget/deliver_man_review_widget.dart';
import 'package:flutter_restaurant/view/screens/rare_review/widget/product_review_widget.dart';
import 'package:provider/provider.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan? deliveryMan;
  const RateReviewScreen({Key? key, required this.orderDetailsList, required this.deliveryMan}) : super(key: key);

  @override
  State<RateReviewScreen>  createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.deliveryMan == null ? 1 : 2, initialIndex: 0, vsync: this);
    Provider.of<ProductProvider>(context, listen: false).initRatingData(widget.orderDetailsList);
    Provider.of<ProductProvider>(context, listen: false).updateSubmitted(false);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('rate_review', context))) as PreferredSizeWidget?,

      body: Column(children: [
        Center(
          child: Container(
            width: 1170,
            color: Theme.of(context).cardColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).textTheme.bodyLarge!.color,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              unselectedLabelStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
              labelStyle: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              tabs: widget.deliveryMan != null ? [
                Tab(text: getTranslated(widget.orderDetailsList.length > 1 ? 'items' : 'item', context)),
                Tab(text: getTranslated('delivery_man', context)),
              ] : [
                Tab(text: getTranslated(widget.orderDetailsList.length > 1 ? 'items' : 'item', context)),
              ],
            ),
          ),
        ),

        Expanded(child: TabBarView(
          controller: _tabController,
          children: widget.deliveryMan != null ? [
            ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
            DeliveryManReviewWidget(deliveryMan: widget.deliveryMan, orderID: widget.orderDetailsList[0].orderId.toString()),
          ] : [
            ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
          ],
        )),

      ]),
    );
  }
}
