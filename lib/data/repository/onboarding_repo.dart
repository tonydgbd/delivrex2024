import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:delivrex/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrex/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrex/data/model/response/base/api_response.dart';
import 'package:delivrex/data/model/response/onboarding_model.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/utill/images.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onBoardingOne, getTranslated('make_your_choice_order', context), getTranslated('you_can_choice_the_best', context)),
        OnBoardingModel(Images.onBoardingTwo, getTranslated('select_delivery_location', context), getTranslated('select_accurate_location', context)),
        OnBoardingModel(Images.onBoardingThree, getTranslated('delivery_to_your_home', context), getTranslated('get_food_delivery_at_home', context)),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
