// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel chanel = AndroidNotificationChannel(
    'hih_importance_chanel', //id
    'High Importance Notifications', //titre
    description: 'This chanel is used ...',
    importance: Importance.high,
    playSound: true);

final _localNotifications = FlutterLocalNotificationsPlugin();

Future<void> handlerBackgrounMessage(RemoteMessage message) async {
  print("id message: ${message.messageId}");
  print("Titre : ${message.notification?.title}");
  print("Corps : ${message.notification?.body}");
  print("Payload : ${message.data}");
  // CSetnotif().futurenotif(context,sigleetbs);
}

class FireBaseNotification {
  final _freBaseNotification = FirebaseMessaging.instance;

  Future initLocalNotification() async {
    // const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@mipmap-hdpi/ic_launcher');
    const settings = InitializationSettings(
        android: android, iOS: DarwinInitializationSettings());
    await _localNotifications.initialize(
      settings,
      // onSelectNotification: (payload) {
      //   final message = RemoteMessage.fromMap(jsonDecode(payload!));
      //   print(message.notification!.title);
      // },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(chanel);
  }

  Future<String> intNotification() async {
    await _freBaseNotification.requestPermission();
    var tokennotif = (await _freBaseNotification.getToken())!;
    print("Lo Token de lUser :: : $tokennotif");
    FirebaseMessaging.onBackgroundMessage(handlerBackgrounMessage);
    FirebaseMessaging.onMessage.listen((message) {
      //  CSetnotif().futurenotif(sigleetbs);
      final notifcation = message.notification;
      if (notifcation == null) return;
      _localNotifications.show(
          notifcation.hashCode,
          notifcation.title,
          notifcation.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              chanel.id,
              chanel.name,
              channelDescription: chanel.description,
              // icon: '@drawable/ic_launcher',
              // other properties...
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
    // initLocalNotification();
    return tokennotif;
  }
}
