import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:delivrex/data/model/body/place_order_body.dart';
import 'package:delivrex/data/model/response/base/api_response.dart';
import 'package:delivrex/data/model/response/delivery_man_model.dart';
import 'package:delivrex/data/model/response/distance_model.dart';
import 'package:delivrex/data/model/response/order_details_model.dart';
import 'package:delivrex/data/model/response/order_model.dart';
import 'package:delivrex/data/model/response/response_model.dart';
import 'package:delivrex/data/model/response/timeslote_model.dart';
import 'package:delivrex/data/repository/order_repo.dart';
import 'package:delivrex/helper/api_checker.dart';
import 'package:delivrex/helper/date_converter.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/main.dart';
import 'package:delivrex/provider/splash_provider.dart';
import 'package:delivrex/utill/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  final SharedPreferences? sharedPreferences;
  OrderProvider({required this.sharedPreferences, required this.orderRepo});

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? _historyOrderList;
  List<OrderDetailsModel>? _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel? _trackModel;
  ResponseModel? _responseModel;
  int _addressIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  DeliveryManModel? _deliveryManModel;
  String? _orderType = 'delivery';
  int _branchIndex = 0;
  List<TimeSlotModel>? _timeSlots;
  List<TimeSlotModel>? _allTimeSlots;
  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;
  double _distance = -1;
  bool _isRestaurantCloseShow = true;
  String _paymentMethod = '';

  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel? get trackModel => _trackModel;
  ResponseModel? get responseModel => _responseModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  DeliveryManModel? get deliveryManModel => _deliveryManModel;
  String? get orderType => _orderType;
  int get branchIndex => _branchIndex;
  List<TimeSlotModel>? get timeSlots => _timeSlots;
  List<TimeSlotModel>? get allTimeSlots => _allTimeSlots;
  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;
  double get distance => _distance;
  bool get isRestaurantCloseShow => _isRestaurantCloseShow;
  String get paymentMethod => _paymentMethod;

  void changeStatus(bool status, {bool notify = false}) {
    _isRestaurantCloseShow = status;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo!.getOrderList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response!.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'out_for_delivery' ||
            orderModel.orderStatus == 'confirmed') {
          _runningOrderList!.add(orderModel);
        } else if (orderModel.orderStatus == 'delivered' ||
            orderModel.orderStatus == 'returned' ||
            orderModel.orderStatus == 'failed' ||
            orderModel.orderStatus == 'canceled') {
          _historyOrderList!.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<List<OrderDetailsModel>?> getOrderDetails(String orderID) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    ApiResponse apiResponse = await orderRepo!.getOrderDetails(orderID);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      print(apiResponse.response!.data.runtimeType);
      (apiResponse.response!.data as List).forEach((orderDetail) {
        // print(orderDetail);
        _orderDetails!.add(OrderDetailsModel.fromJson(orderDetail));
      });
    } else {
      _orderDetails = [];
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
    return _orderDetails;
  }

  Future<void> getDeliveryManData(String? orderID) async {
    ApiResponse apiResponse = await orderRepo!.getDeliveryManData(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future<ResponseModel?> trackOrder(
      String? orderID, OrderModel? orderModel, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if (!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if (orderModel == null) {
      _isLoading = true;
      ApiResponse apiResponse = await orderRepo!.trackOrder(orderID);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _trackModel = OrderModel.fromJson(apiResponse.response!.data);
        _responseModel =
            ResponseModel(true, apiResponse.response!.data.toString());
      } else {
        _responseModel = ResponseModel(
            false, ApiChecker.getError(apiResponse).errors![0].message);
        ApiChecker.checkApi(apiResponse);
      }
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    _isLoading = false;
    notifyListeners();
    return _responseModel;
  }

  Future<void> placeOrder(
      PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.placeOrder(placeOrderBody);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String? message = apiResponse.response!.data['message'];
      String orderID = apiResponse.response!.data['order_id'].toString();
      callback(true, message, orderID, placeOrderBody.deliveryAddressId);
    } else {
      callback(
          false,
          getTranslated('payment_process_is_interrupted', Get.context!),
          '-1',
          -1);
    }

    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void clearPrevData() {
    _paymentMethod = '';
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
    _distance = -1;
  }

  void cancelOrder(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.cancelOrder(orderID);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      OrderModel? orderModel;
      for (var order in _runningOrderList!) {
        if (order.id.toString() == orderID) {
          orderModel = order;
        }
      }
      _runningOrderList!.remove(orderModel);
      _showCancelled = true;
      callback(apiResponse.response!.data['message'], true, orderID);
    } else {
      callback(apiResponse.error.errors[0].message, false, '-1');
    }
    notifyListeners();
  }

  Future<void> updatePaymentMethod(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.updatePaymentMethod(orderID);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      int? orderIndex;
      for (int index = 0; index < _runningOrderList!.length; index++) {
        if (_runningOrderList![index].id.toString() == orderID) {
          orderIndex = index;
          break;
        }
      }
      if (orderIndex != null) {
        _runningOrderList![orderIndex].paymentMethod = 'cash_on_delivery';
      }
      _trackModel!.paymentMethod = 'cash_on_delivery';
      callback(apiResponse.response!.data['message'], true);
    } else {
      callback(apiResponse.error.errors[0].message, false);
    }
    notifyListeners();
  }

  void setOrderType(String? type, {bool notify = true}) {
    _orderType = type;
    if (notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    _distance = -1;
    notifyListeners();
  }

  Future<void> initializeTimeSlot(BuildContext context) async {
    final scheduleTime = Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .restaurantScheduleTime!;
    int? duration = Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .scheduleOrderSlotDuration;
    _timeSlots = [];
    _allTimeSlots = [];
    _selectDateSlot = 0;
    int minutes = 0;
    DateTime now = DateTime.now();
    for (int index = 0; index < scheduleTime.length; index++) {
      DateTime openTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateConverter.convertStringTimeToDate(scheduleTime[index].openingTime!)
            .hour,
        DateConverter.convertStringTimeToDate(scheduleTime[index].openingTime!)
            .minute,
      );

      DateTime closeTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateConverter.convertStringTimeToDate(scheduleTime[index].closingTime!)
            .hour,
        DateConverter.convertStringTimeToDate(scheduleTime[index].closingTime!)
            .minute,
      );

      if (closeTime.difference(openTime).isNegative) {
        minutes = openTime.difference(closeTime).inMinutes;
      } else {
        minutes = closeTime.difference(openTime).inMinutes;
      }
      if (duration! > 0 && minutes > duration) {
        DateTime time = openTime;
        for (;;) {
          if (time.isBefore(closeTime)) {
            DateTime start = time;
            DateTime end = start.add(Duration(minutes: duration));
            if (end.isAfter(closeTime)) {
              end = closeTime;
            }
            _timeSlots!.add(TimeSlotModel(
                day: int.tryParse(scheduleTime[index].day!),
                startTime: start,
                endTime: end));
            _allTimeSlots!.add(TimeSlotModel(
                day: int.tryParse(scheduleTime[index].day!),
                startTime: start,
                endTime: end));
            time = time.add(Duration(minutes: duration));
          } else {
            break;
          }
        }
      } else {
        _timeSlots!.add(TimeSlotModel(
            day: int.tryParse(scheduleTime[index].day!),
            startTime: openTime,
            endTime: closeTime));
        _allTimeSlots!.add(TimeSlotModel(
            day: int.tryParse(scheduleTime[index].day!),
            startTime: openTime,
            endTime: closeTime));
      }
    }
    validateSlot(_allTimeSlots!, 0, notify: false);
  }

  void sortTime() {
    _timeSlots!.sort((a, b) {
      return a.startTime!.compareTo(b.startTime!);
    });

    _allTimeSlots!.sort((a, b) {
      return a.startTime!.compareTo(b.startTime!);
    });
  }

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if (_allTimeSlots != null) {
      validateSlot(_allTimeSlots!, index);
    }
    notifyListeners();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex,
      {bool notify = true}) {
    _timeSlots = [];
    int day = 0;
    if (dateIndex == 0) {
      day = DateTime.now().weekday;
    } else {
      day = DateTime.now().add(const Duration(days: 1)).weekday;
    }
    if (day == 7) {
      day = 0;
    }
    for (var slot in slots) {
      if (day == slot.day &&
          (dateIndex == 0 ? slot.endTime!.isAfter(DateTime.now()) : true)) {
        _timeSlots!.add(slot);
      }
    }

    if (notify) {
      notifyListeners();
    }
  }

  Future<bool> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    bool isSuccess = false;
    ApiResponse response =
        await orderRepo!.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      print(response.response);
      if (response.response!.statusCode == 200 &&
          response.response!.data['status'] == 'OK') {
        isSuccess = true;
        print(response.response!.data);
        _distance = DistanceModel.fromJson(response.response!.data)
                .rows![0]
                .elements![0]
                .distance!
                .value! /
            1000;
      } else {
        _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
      }
    } catch (e) {
      print(e);
      _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
    }
    notifyListeners();
    return isSuccess;
  }

  Future<void> setPlaceOrder(String placeOrder) async {
    await sharedPreferences!.setString(AppConstants.placeOrderData, placeOrder);
  }

  String? getPlaceOrder() {
    return sharedPreferences!.getString(AppConstants.placeOrderData);
  }

  Future<void> clearPlaceOrder() async {
    await sharedPreferences!.remove(AppConstants.placeOrderData);
  }

  double getDistanceBetween(LatLng startLatLng, LatLng endLatLng) {
    return Geolocator.distanceBetween(
      startLatLng.latitude,
      startLatLng.longitude,
      endLatLng.latitude,
      endLatLng.longitude,
    );
  }
}
