import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class WalletRepo {
  final DioClient? dioClient;
  WalletRepo({required this.dioClient});

  Future<ApiResponse> getWalletTransactionList(String offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.walletTransactionUrl}?offset=$offset&limit=10');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoyaltyTransactionList(String offset, String type) async {
    try {
      final response = await dioClient!.get('${AppConstants.loyaltyTransactionUrl}?offset=$offset&limit=10&type=$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> pointToWallet({int? point}) async {
    try {
      final response = await dioClient!.post(AppConstants.loyaltyPointTransferUrl, data: {'point' : point});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}