import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/category_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo? categoryRepo;

  CategoryProvider({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  List<Product>? _categoryProductList;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  bool _isLoading = false;
  String? _selectedSubCategoryId;

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  List<Product>? get categoryProductList => _categoryProductList;
  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;
  bool get isLoading => _isLoading;
  String? get selectedSubCategoryId => _selectedSubCategoryId;

  Future<void> getCategoryList(bool reload) async {
    _subCategoryList = null;
    if(_categoryList == null || reload) {
      _isLoading = true;
      ApiResponse apiResponse = await categoryRepo!.getCategoryList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList = [];
        apiResponse.response!.data.forEach((category) => _categoryList!.add(CategoryModel.fromJson(category)));
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void getSubCategoryList(String categoryID) async {
    _subCategoryList = null;
    _isLoading = true;
    ApiResponse apiResponse = await categoryRepo!.getSubCategoryList(categoryID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoryList= [];
      apiResponse.response!.data.forEach((category) => _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryProductList(categoryID);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void getCategoryProductList(String? categoryID, {String type = 'all'}) async {
    _categoryProductList = null;
    _selectedSubCategoryId = categoryID;
    notifyListeners();
    ApiResponse apiResponse = await categoryRepo!.getCategoryProductList(categoryID, type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      apiResponse.response!.data.forEach((category) => _categoryProductList!.add(Product.fromJson(category)));
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString());
    }
  }

  int _selectCategory = -1;

  int get selectCategory => _selectCategory;

  updateSelectCategory(int index) {
    _selectCategory = index;
    notifyListeners();
  }
  updateProductCurrentIndex(int index, int totalLength) {
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
