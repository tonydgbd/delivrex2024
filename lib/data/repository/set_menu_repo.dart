import 'package:delivrex/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrex/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrex/data/model/response/base/api_response.dart';
import 'package:delivrex/utill/app_constants.dart';

class SetMenuRepo {
  final DioClient? dioClient;
  SetMenuRepo({required this.dioClient});

  Future<ApiResponse> getSetMenuList() async {
    try {
      final response = await dioClient!.get(AppConstants.setMenuUri,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}