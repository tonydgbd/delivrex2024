import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/search_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:provider/provider.dart';

import 'localization_provider.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;

  SearchProvider({required this.searchRepo});

  int _filterIndex = 0;
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];
  bool _isSearch = true;

  int get filterIndex => _filterIndex;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;

  List<String> get historyList => _historyList;
  TextEditingController _searchController = TextEditingController();
  TextEditingController  get searchController=> _searchController;
  int _searchLength = 0;
  int get searchLength => _searchLength;
  bool get isSearch => _isSearch;

  searchDone(){
    _isSearch = !_isSearch;
    notifyListeners();
  }

  getSearchText(String searchText){
    _searchController = TextEditingController(text: searchText);
    _searchLength = searchText.length;
    notifyListeners();
  }

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    notifyListeners();
  }

  void sortSearchList(int categoryIndex, List<CategoryModel>? categoryList) {
    _searchProductList= [];
    _searchProductList!.addAll(_filterProductList!);
    if(_upperValue > 0) {
      _searchProductList!.removeWhere((product) => product.price! <= _lowerValue || product.price! >= _upperValue);
    }
    if(categoryIndex != -1) {
      int? categoryID = categoryList![categoryIndex].id;
      _searchProductList!.removeWhere((product) {
        List<String?> ids = [];
        for (var element in product.categoryIds!) {
          ids.add(element.id);
        }
        return !ids.contains(categoryID.toString());
      });
    }
    if(_rating != -1) {
      _searchProductList!.removeWhere((product) => product.rating == null || product.rating!.isEmpty || double.parse(product.rating![0].average!) < _rating);
    }
    notifyListeners();
  }

  List<Product>? _searchProductList;
  List<Product>? _filterProductList;
  bool _isClear = true;
  String _searchText = '';

  List<Product>? get searchProductList => _searchProductList;

  List<Product>? get filterProductList => _filterProductList;

  bool get isClear => _isClear;

  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    // notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
   // notifyListeners();
  }

  void searchProduct(String query, BuildContext context, {String type = 'all', bool isUpdate = false}) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    if(isUpdate) {
      notifyListeners();
    }

    ApiResponse apiResponse = await searchRepo!.getSearchProductList(query,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode, type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _filterProductList = [];
        _filterProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
      }
      //notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());
  }

  void saveSearchAddress(String searchAddress) async {
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
      searchRepo!.saveSearchAddress(searchAddress);
      // notifyListeners();
    }
  }

  void clearSearchAddress() async {
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }

  int _rating = -1;

  int get rating => _rating;

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }
}
