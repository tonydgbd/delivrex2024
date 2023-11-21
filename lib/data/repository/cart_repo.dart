import 'dart:convert';

import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
  final SharedPreferences? sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<CartModel> getCartList() {
    List<String>? carts = [];
    if(sharedPreferences!.containsKey(AppConstants.cartList)) {
      carts = sharedPreferences!.getStringList(AppConstants.cartList);
    }
    List<CartModel> cartList = [];
    for (var cart in carts!) {
      cartList.add(CartModel.fromJson(jsonDecode(cart)));
    }

    return cartList;
  }

  void addToCartList(List<CartModel?> cartProductList) {
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferences!.setStringList(AppConstants.cartList, carts);
  }

}