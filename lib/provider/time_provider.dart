import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  Duration? _duration;
  Timer? _timer;
  Duration? get duration => _duration;

  Future<void> countDownTimer(OrderModel order, BuildContext context) async {
    DateTime orderTime;
    if(Provider.of<SplashProvider>(context, listen: false).configModel!.timeFormat == '12') {
      orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${order.deliveryDate} ${order.deliveryTime}');

    }else{
      orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${order.deliveryDate} ${order.deliveryTime}');
    }

    DateTime endTime = orderTime.add(Duration(minutes: int.parse(order.preparationTime!)));
    _duration = endTime.difference(DateTime.now());
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(!_duration!.isNegative && _duration!.inSeconds > 0) {
        _duration = _duration! - const Duration(seconds: 1);
        notifyListeners();
      }

    });
    if(_duration!.isNegative) {
      _duration = const Duration();
    }_duration = endTime.difference(DateTime.now());

  }

}
