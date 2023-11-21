import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/set_menu_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class SetMenuProvider extends ChangeNotifier {
  final SetMenuRepo? setMenuRepo;

  SetMenuProvider({required this.setMenuRepo});

  List<Product>? _setMenuList;
  final int _currentIndex = 0;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;

  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;

  List<Product>? get setMenuList => _setMenuList;
  int get getCurrentIndex => _currentIndex;

  Future<void> getSetMenuList(bool reload) async {
    if (setMenuList == null || reload) {
      ApiResponse apiResponse = await setMenuRepo!.getSetMenuList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _setMenuList = [];
        apiResponse.response!.data.forEach((setMenu) =>
            _setMenuList!.add(Product.fromJson(setMenu)));
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  updateSetMenuCurrentIndex(int index, int totalLength) {
    if(index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    }else{
      _pageFirstIndex = true;
      notifyListeners();
    }
    if(index + 1  == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    }else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }



}