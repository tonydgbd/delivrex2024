import 'dart:convert';
import 'package:flutter_restaurant/main.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class OrderWebPayment extends StatefulWidget {
  final String? token;
  const OrderWebPayment({Key? key, this.token}) : super(key: key);

  @override
  State<OrderWebPayment> createState() => _OrderWebPaymentState();
}

class _OrderWebPaymentState extends State<OrderWebPayment> {

  getValue() async {
    if(html.window.location.href.contains('success')){
      final orderProvider =  Provider.of<OrderProvider>(Get.context!, listen: false);
      String placeOrderString =  utf8.decode(base64Url.decode(orderProvider.getPlaceOrder()!.replaceAll(' ', '+')));
      String tokenString = utf8.decode(base64Url.decode(widget.token!.replaceAll(' ', '+')));
      String paymentMethod = tokenString.substring(0, tokenString.indexOf('&&'));
      String transactionReference = tokenString.substring(tokenString.indexOf('&&') + '&&'.length, tokenString.length);

      PlaceOrderBody placeOrderBody =  PlaceOrderBody.fromJson(jsonDecode(placeOrderString)).copyWith(
        paymentMethod: paymentMethod.replaceAll('payment_method=', ''),
        transactionReference: transactionReference.replaceAll('transaction_reference=', ''),
      );
      orderProvider.placeOrder(placeOrderBody, _callback);

    }else{
      Future.delayed(const Duration(milliseconds: 500)).then((value) => Navigator.pushReplacementNamed(Get.context!, '${Routes.orderSuccessScreen}/-1/payment-fail'));
    }
  }

  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    Provider.of<CartProvider>(context, listen: false).clearCartList();
    Provider.of<OrderProvider>(context, listen: false).clearPlaceOrder();
    Provider.of<OrderProvider>(context, listen: false).stopLoader();
    if(isSuccess) {
      Navigator.pushReplacementNamed(context, '${Routes.orderSuccessScreen}/$orderID/success');
    }else {
      showCustomSnackBar(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()),
      body: Center(
          child: CircularProgressIndicator()),
    );
  }
}
