import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateConverter {
  static String formatDate(DateTime? dateTime, BuildContext context, {bool isSecond = true}) {
    return isSecond
        ?  DateFormat('yyyy-MM-dd ${_timeFormatter(context)}:ss').format(dateTime!) :
    DateFormat('yyyy-MM-dd ${_timeFormatter(context)}').format(dateTime!);
  }

  static String dateToTimeOnly(DateTime dateTime, BuildContext context) {
    return DateFormat(_timeFormatter(context)).format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }
  static String localDateToIsoStringAMPM(DateTime dateTime, BuildContext context) {
    return DateFormat('yyyy-MM-dd ${_timeFormatter(context)}').format(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time, BuildContext context) {
    return DateFormat(_timeFormatter(context)).format(DateFormat('HH:mm').parse(time));
  }

  static bool isAvailable(String start, String end, BuildContext context, {DateTime? time}) {
    DateTime currentTime;
    if(time != null) {
      currentTime = time;
    }else {
      currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
    }
    DateTime start0 = DateFormat('hh:mm:ss').parse(start);
    DateTime end0 = DateFormat('hh:mm:ss').parse(end);
    DateTime startTime = DateTime(currentTime.year, currentTime.month, currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end0.hour, end0.minute, end0.second);
    if(endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String convertTimeRange(String start, String end) {
    DateTime startTime = DateFormat('HH:mm:ss').parse(start);
    DateTime endTime = DateFormat('HH:mm:ss').parse(end);
    return '${DateFormat('hh:mm aa').format(startTime)} - ${DateFormat('hh:mm aa').format(endTime)}';
  }

  static DateTime stringTimeToDateTime(String time) {
    return DateFormat('HH:mm:ss').parse(time);
  }

  static String deliveryDateAndTimeToDate(String deliveryDate, String deliveryTime, BuildContext context) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(deliveryDate);
    DateTime time = DateFormat('HH:mm').parse(deliveryTime);
    return '${DateFormat('dd-MMM-yyyy').format(date)} ${DateFormat(_timeFormatter(context)).format(time)}';
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static String convertToWeekNameAndTime(DateTime date) {
    return DateFormat('EEEE  hh:mm aa').format(date);
  }

  static String _timeFormatter(BuildContext context) {
    return Provider.of<SplashProvider>(context, listen: false).configModel!.timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static String? getWeekName(String index) {
    String? weekName;
    switch (index) {
      case '0': weekName = 'Sunday';
      break;
      case '1': weekName = 'Monday';
      break;
      case '2': weekName = 'Tuesday';
      break;
      case '3': weekName = 'Wednesday';
      break;
      case '4': weekName = 'Thursday';
      break;
      case '5': weekName = 'Friday';
      break;
      case '6': weekName = 'Saturday';
      break;
    }
    return weekName;
}


}
