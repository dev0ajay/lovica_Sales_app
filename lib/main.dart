import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/push_notif_model.dart';

// import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkForInitialMessage();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const LovicaApp());
}

// For handling notification when the app is in terminated state
checkForInitialMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    PushNotification notification = PushNotification(
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
      dataTitle: initialMessage.data['title'],
      dataBody: initialMessage.data['body'],
    );
    print(
        'checkForInitialMessage _firebaseMessagingBackgroundHandler :: Message title: ${notification.title}, body: ${notification.body}');

  }
}
