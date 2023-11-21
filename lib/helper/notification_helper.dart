import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/chat_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/screens/notification/notification_screen.dart';
import 'package:flutter_restaurant/view/screens/notification/widget/notifiation_popup_dialog.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class NotificationHelper {


  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {

        PayloadModel payload = PayloadModel.fromJson(jsonDecode('${notificationResponse.payload}'));
        try{
          if(notificationResponse.payload!.isNotEmpty) {
            if(payload.orderId != null && payload.orderId != 'null' && payload.orderId != '') {

              Get.navigator!.push(MaterialPageRoute(builder: (context) =>
                  OrderDetailsScreen(orderModel: null, orderId: int.tryParse(payload.orderId!))),
              );
            }else if(payload.type == 'message') {
              Navigator.pushNamed(Get.context!, Routes.getChatRoute(orderModel: null));
            }else if(payload.type == 'general'){
              Get.navigator!.push(
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            }
          }
        }catch (e) {
          debugPrint('error ===> $e');
        }
        return;
      },);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {


      if(message.data['type'] == 'message') {
        int? id;
        id = int.tryParse('${message.data['order_id']}');
        Provider.of<ChatProvider>(Get.context!, listen: false).getMessages(Get.context, 1, id , false);
      }

      showNotification(message, flutterLocalNotificationsPlugin, kIsWeb);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.data['type'] == 'message') {
        int? id;
        id = int.tryParse('${message.data['order_id']}');
        Provider.of<ChatProvider>(Get.context!, listen: false).getMessages(Get.context, 1, id , false);
      }

      try{
        if(message.notification!.titleLocKey != null && message.notification!.titleLocKey!.isNotEmpty) {
          Get.navigator!.push(
              MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderModel: null, orderId: int.parse(message.notification!.titleLocKey!))));
        }
      }catch (e) {
        debugPrint('error ===> $e');
      }
    });

  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String? title;
    String? body;
    String? orderID;
    String? image;
    String? type = '';

    if(data) {
      title = message.data['title'];
      body = message.data['body'];
      orderID = message.data['order_id'];
      image = (message.data['image'] != null && message.data['image'].isNotEmpty)
          ? message.data['image'].startsWith('http') ? message.data['image']
          : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;


    }else {
      title = message.notification!.title;
      body = message.notification!.body;
      orderID = message.notification!.titleLocKey;
      if(Platform.isAndroid) {
        image = (message.notification!.android!.imageUrl != null && message.notification!.android!.imageUrl!.isNotEmpty)
            ? message.notification!.android!.imageUrl!.startsWith('http') ? message.notification!.android!.imageUrl
            : '${AppConstants.baseUrl}/storage/app/public/notification/${message.notification!.android!.imageUrl}' : null;
      }else if(Platform.isIOS) {
        image = (message.notification!.apple!.imageUrl != null && message.notification!.apple!.imageUrl!.isNotEmpty)
            ? message.notification!.apple!.imageUrl!.startsWith('http') ? message.notification!.apple!.imageUrl
            : '${AppConstants.baseUrl}/storage/app/public/notification/${message.notification!.apple!.imageUrl}' : null;
      }
    }

    if(message.data['type'] != null) {
      type = message.data['type'];
    }

    Map<String, String> payloadData = {
      'title' : '$title',
      'body' : '$body',
      'order_id' : '$orderID',
      'image' : '$image',
      'type' : '$type',
    };

    PayloadModel payload = PayloadModel.fromJson(payloadData);

    if(kIsWeb) {
      showDialog(
          context: Get.context!,
          builder: (context) => Center(
            child: NotificationPopUpDialog(payload),
          )
      );
    }




    if(image != null && image.isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(payload, fln);
      }catch(e) {
        await showBigTextNotification(payload, fln);
      }
    }else {
      await showBigTextNotification(payload, fln);
    }
  }


  static Future<void> showBigTextNotification(PayloadModel payload, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      payload.body!, htmlFormatBigText: true,
      contentTitle: payload.title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.appName, AppConstants.appName, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, payload.title, payload.body, platformChannelSpecifics, payload: jsonEncode(payload.toJson()));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      PayloadModel payload, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile( payload.image!, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile( payload.image!, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: payload.title, htmlFormatContentTitle: true,
      summaryText:  payload.body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.appName, AppConstants.appName,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0,  payload.title,  payload.body, platformChannelSpecifics, payload: jsonEncode(payload.toJson()));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }



}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");


}

class PayloadModel {
  PayloadModel({
    this.title,
    this.body,
    this.orderId,
    this.image,
    this.type,
  });

  String? title;
  String? body;
  String? orderId;
  String? image;
  String? type;

  factory PayloadModel.fromRawJson(String str) => PayloadModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayloadModel.fromJson(Map<String, dynamic> json) => PayloadModel(
    title: json["title"],
    body: json["body"],
    orderId: json["order_id"],
    image: json["image"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "order_id": orderId,
    "image": image,
    "type": type,
  };
}

