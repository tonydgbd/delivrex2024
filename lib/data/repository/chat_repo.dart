import 'dart:async';
import 'dart:io';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


class ChatRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ChatRepo({required this.dioClient, required this.sharedPreferences});


  Future<ApiResponse> getDeliveryManMessage(int orderId,int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.getDeliverymanMessageUri}?offset=$offset&limit=100&order_id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAdminMessage(int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.getAdminMessageUrl}?offset=$offset&limit=100');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<http.StreamedResponse> sendMessageToDeliveryMan(String message, List<XFile> file, int? orderId, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sendMessageToDeliveryManUrl}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    for(int i=0; i<file.length;i++){
      Uint8List list = await file[i].readAsBytes();
      var part = http.MultipartFile('image[]', file[i].readAsBytes().asStream(), list.length, filename: file[i].path);
      request.files.add(part);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
      'order_id': orderId.toString(),
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> sendMessageToAdmin(String message, List<XFile> file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sendMessageToAdminUrl}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    for(int i=0; i<file.length;i++){
      Uint8List list = await file[i].readAsBytes();
      var part = http.MultipartFile('image[]', file[i].readAsBytes().asStream(), list.length, filename: file[i].path);
      request.files.add(part);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


  Future<http.StreamedResponse> sendMessage(String message, List<XFile> images, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.getImagesUrl}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(ResponsiveHelper.isMobilePhone()) {
      for(int i = 0; i < images.length; i++) {
        File file = File(images[i].path);
        request.files.add(http.MultipartFile('image[]', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));

      }
    }else if(ResponsiveHelper.isWeb()) {
      for(int i = 0; i < images.length; i++) {
        Uint8List list = await images[i].readAsBytes();
        request.files.add(http.MultipartFile('image[]', images[i].readAsBytes().asStream(), list.length, filename: images[0].path));
      }
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

}