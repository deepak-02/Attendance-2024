import 'dart:convert';
import 'package:attendance/screens/home/leave/leave_requests.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../screens/AdminScreens/leave/leave_requests_admin.dart';
import '../screens/home/late/late_requests.dart';

Future handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  // showLocalNotification(message.notification!);
  print("Title : ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");

  if (message.notification != null) {
    handleMessage(message);
  }
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  // if message data has a certain route specified go there , else no navigation allowed
  if (message.data['click'] == "user") {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => const LeaveRequests()));
  } else if (message.data["click"] == "admin") {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => const LeaveRequestsAdmin()));
  } else if (message.data["click"] == "lateUser") {
    print(message.data["click"]);
    print("late User");
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => const LateRequests()));
  } else if (message.data["click"] == "lateAdmin") {
    print(message.data["click"]);
    print("late Admin");
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => const LateRequests()));
  }
}

void showLocalNotification(
    RemoteNotification notification, Map<String, dynamic> payload) async {
  final localNotifications = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: '@drawable/ic_launcher', // Replace with your app's launcher icon
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidChannel);

  await localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(payload),
  );
}

Future<void> initNotification(
    FlutterLocalNotificationsPlugin localNotifications) async {
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@drawable/ic_launcher');

  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print("Body: $body");
      });

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await localNotifications.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaa");
    print("$notificationResponse");
    print("${notificationResponse.payload}");
    // handleMessage(message);
    // if message data has a certain route specified go there , else no navigation allowed
    var payload = jsonDecode(notificationResponse.payload.toString());
    if (payload['click'] == "user") {
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (context) => const LeaveRequests()));
    } else if (payload["click"] == "admin") {
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (context) => const LeaveRequestsAdmin()));
    } else if (payload["click"] == "lateUser") {
      print(payload["click"]);
      print("late User");
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (context) => const LateRequests()));
    } else if (payload["click"] == "lateAdmin") {
      print(payload["click"]);
      print("late Admin");
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (context) => const LateRequests()));
    }
  });
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    handleMessage(initialMessage);
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;
    showLocalNotification(message.notification!, message.data);
    // handleMessage(message);
    print("Title : ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  });
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token NOT: $fCMToken');
    // add token to database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fCMToken', fCMToken!);

    initPushNotifications();
    initNotification(_localNotifications);
  }
}
