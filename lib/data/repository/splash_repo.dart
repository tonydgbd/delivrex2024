import 'package:delivrex/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrex/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrex/data/model/response/base/api_response.dart';
import 'package:delivrex/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response =
          await dioClient!.get(AppConstants.baseUrl + AppConstants.configUri);
          // print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences!.containsKey(AppConstants.theme)) {
      return sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      return sharedPreferences!.setString(
          AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if (!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      return sharedPreferences!.setString(
          AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }
    if (!sharedPreferences!.containsKey(AppConstants.onBoardingSkip)) {
      return sharedPreferences!.setBool(AppConstants.onBoardingSkip, true);
    }
    if (!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }
    // if(!sharedPreferences.containsKey(AppConstants.cookiesManagement)) {
    //   return sharedPreferences.st(AppConstants.cookiesManagement, false);
    // }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }

  Future<ApiResponse> getPolicyPage() async {
    try {
      final response = await dioClient!.get(AppConstants.policyPage);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  int getBranchId() => sharedPreferences!.getInt(AppConstants.branch) ?? -1;

  Future<void> setBranchId(int id) async {
    await sharedPreferences!.setInt(AppConstants.branch, id);
    if (id != -1) {
      await dioClient!.updateHeader(
          getToken: sharedPreferences!.getString(AppConstants.token));
    }
  }
}
