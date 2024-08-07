import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:delivrex/data/model/response/base/api_response.dart';
import 'package:delivrex/data/model/response/response_model.dart';
import 'package:delivrex/data/model/response/userinfo_model.dart';
import 'package:delivrex/data/repository/profile_repo.dart';
import 'package:delivrex/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;

  Future<void> getUserInfo(bool reload, {bool isUpdate = true}) async {
    if(reload || _userInfoModel == null){
      _userInfoModel = null;
    }
    if(_userInfoModel == null){
      ApiResponse apiResponse = await profileRepo!.getUserInfo();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
        OneSignal.login("${_userInfoModel!.id}");
        if(_userInfoModel!.email != null){
          OneSignal.User.addEmail(_userInfoModel!.email!);
        }
        if(_userInfoModel!.phone != null){
          OneSignal.User.addSms(_userInfoModel!.phone!);
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }

    if(isUpdate){
      notifyListeners();
    }

  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password, File? file, XFile? data, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, password, file, data, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }

}
