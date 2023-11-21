import 'dart:async';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/repository/notification_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/data/repository/chat_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  final NotificationRepo? notificationRepo;
  ChatProvider({required this.chatRepo, required this.notificationRepo});

  List<bool>? _showDate;
  List<XFile>? _imageFiles;
  // XFile _imageFile;
  bool _isSendButtonActive = false;
  final bool _isSeen = false;
  final bool _isSend = true;
  bool _isMe = false;
  bool _isLoading= false;
  bool get isLoading => _isLoading;

  List<bool>? get showDate => _showDate;
  List<XFile>? get imageFiles => _imageFiles;
  // XFile get imageFile => _imageFile;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;
  final List<Messages>  _deliveryManMessage = [];
  List<Messages>?  _messageList = [];
  List<Messages>? get messageList => _messageList;
  List<Messages> get deliveryManMessage => _deliveryManMessage;
  final List<Messages>  _adminManMessage = [];
  List<Messages> get adminManMessages => _adminManMessage;
  List <XFile>?_chatImage = [];
  List<XFile>? get chatImage => _chatImage;

  Future<void> getMessages (BuildContext? context, int offset, int? orderId, bool isFirst) async {
    ApiResponse apiResponse;
    if(isFirst) {
      _messageList = null;
    }
    //
    if(orderId == null) {
      apiResponse = await chatRepo!.getAdminMessage(1);
    }else {
      apiResponse = await chatRepo!.getDeliveryManMessage(orderId, 1);
    }
    if (apiResponse.response != null&& apiResponse.response!.data['messages'] != {} && apiResponse.response!.statusCode == 200) {
      _messageList = [];
      _messageList?.addAll(ChatModel.fromJson(apiResponse.response!.data).messages!);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFiles = [];
      _chatImage = [];
    }else {
      _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 30);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    notifyListeners();
  }
  void removeImage(int index){
    chatImage!.removeAt(index);
    notifyListeners();
  }


  Future<http.StreamedResponse> sendMessage(String message, BuildContext context, String token, OrderModel? order) async {
    http.StreamedResponse response;
    _isLoading = true;
    // notifyListeners();
    if(order == null) {
      response = await chatRepo!.sendMessageToAdmin(message, _chatImage!, token);
    }else {
      response = await chatRepo!.sendMessageToDeliveryMan(message, _chatImage!, order.id, token);
    }
    if (response.statusCode == 200) {
      getMessages(Get.context!,1, order?.id, false);
      _isLoading = false;
    }
    _imageFiles = [];
    _chatImage = [];
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImageList(List<XFile> images) {
    _imageFiles = [];
    _imageFiles = images;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

}