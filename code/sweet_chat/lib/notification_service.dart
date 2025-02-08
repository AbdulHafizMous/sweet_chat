import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sweet_chat/utils/custom.dart';
// await NotificationService().initNotifications();
/* 
curl -X POST "https://fcm.googleapis.com/fcm/send" \
     -H "Authorization: key=YOUR_SERVER_KEY" \
     -H "Content-Type: application/json" \
     -d '{
       "to": "DEVICE_FCM_TOKEN",
       "notification": {
         "title": "Nouveau message",
         "body": "Vous avez reçu un message !"
       }
     }'
 */

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(context) async {
    // Demander la permission pour recevoir des notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission acceptée !");
    } else {
      print("Permission refusée.");
    }

    // Écouter les notifications en arrière-plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification reçue : ${message.notification?.title}");
      showToast(context, message.notification?.title??"", message.notification?.body??"" );
    });

    // Gérer les notifications en cliquant dessus
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification cliquée !");
    });

    // Récupérer le token FCM
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token : $token");
  }
}

Future<void> saveDeviceToken(String userId) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance.collection('profile').doc(userId).update({
      'token':  token,
    });
  }
}

Future<String> getUserToken(String userId) async {
  final doc = await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .get();
  return doc.data()!["token"];
}


