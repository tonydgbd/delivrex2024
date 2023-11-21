import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/repository/splash_repo.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../data/model/response/policy_model.dart';
import '../helper/api_checker.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;

  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  final DateTime _currentTime = DateTime.now();
  PolicyModel? _policyModel;
  bool _cookiesShow = true;



  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  DateTime get currentTime => _currentTime;
  PolicyModel? get policyModel => _policyModel;
  bool get cookiesShow => _cookiesShow;
  

  Future<bool> initConfig() async {
    ApiResponse apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;

      if(!kIsWeb) {
        if(!Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()){
          await Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
        }
      }



      if(_configModel != null && _configModel!.branches != null && !isBranchSelectDisable()){
        await splashRepo?.setBranchId(_configModel!.branches![0]!.id!);
      }
      notifyListeners();
    } else {
      isSuccess = false;

      showCustomSnackBar(ApiChecker.getError(apiResponse).errors![0].message);
    }
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  bool isRestaurantClosed(bool today) {
    DateTime date = DateTime.now();
    if(!today) {
      date = date.add(const Duration(days: 1));
    }
    int weekday = date.weekday;
    if(weekday == 7) {
      weekday = 0;
    }
    for(int index = 0; index <  _configModel!.restaurantScheduleTime!.length; index++) {
      if(weekday.toString() ==  _configModel!.restaurantScheduleTime![index].day) {
        return false;
      }
    }
    return true;
  }

  bool isRestaurantOpenNow(BuildContext context) {
    if(isRestaurantClosed(true)) {
      return false;
    }
    int weekday = DateTime.now().weekday;
    if(weekday == 7) {
      weekday = 0;
    }
    for(int index = 0; index <  _configModel!.restaurantScheduleTime!.length; index++) {
      if(weekday.toString() ==  _configModel!.restaurantScheduleTime![index].day && DateConverter.isAvailable(
            _configModel!.restaurantScheduleTime![index].openingTime!,
            _configModel!.restaurantScheduleTime![index].closingTime!,
            context,
          )) {
        return true;
      }
    }
    return false;
  }

  Future<bool> getPolicyPage() async {
    ApiResponse apiResponse = await splashRepo!.getPolicyPage();
    bool isSuccess;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _policyModel = PolicyModel.fromJson(apiResponse.response!.data);
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      ApiChecker.checkApi(apiResponse);
    }

    return isSuccess;
  }

  void cookiesStatusChange(String? data) {
    if(data != null){
      splashRepo!.sharedPreferences!.setString(AppConstants.cookiesManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) => splashRepo!.sharedPreferences!.getString(AppConstants.cookiesManagement) != null
      && splashRepo!.sharedPreferences!.getString(AppConstants.cookiesManagement) == data;

  int getActiveBranch(){
    int branchActiveCount = 0;
    for(int i = 0; i < _configModel!.branches!.length; i++){
      if(_configModel!.branches![i]!.status ?? false) {
        branchActiveCount++;
        if(branchActiveCount > 1){
          break;
        }
      }
    }
    if(branchActiveCount == 0){
       splashRepo?.setBranchId(-1);
    }
    return branchActiveCount;
  }

  bool isBranchSelectDisable()=> getActiveBranch() != 1;
}