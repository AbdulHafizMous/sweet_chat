import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:badges/badges.dart' as badges;
//
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
//import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';

// Animation charge beaucoup données riverpod_infinite_scroll_pagination: ^1.0.3

User connectedUser = User(
    profile: Profile(
        id: '',
        numero: '',
        email: '',
        adress: "",
        name: "New User",
        pseudo: "",
        sexe: "",
        date: "",
        dateins: "",
        status: "",
        img: "",
        facebook: "",
        instagram: "",
        linkedin: "",
        bio: ""));

Future<int> mutualTmp(User a, User b) async {
FirebaseFirestore fins = FirebaseFirestore.instance;
  int res = 0;
  final docA = await fins.collection("user").doc(a.profile.id).get();
  final frsA = docA.data()!['friends'] ?? [];
  // 
  final docB = await fins.collection("user").doc(b.profile.id).get();
  final frsB = docB.data()!['friends'] ?? [];

  for (var fa in frsA) {
    DocumentSnapshot<Map<String, dynamic>> faDoc = await fa.get();
    DocumentReference usrRefA = faDoc.data()!['friend'] as DocumentReference;
    DocumentSnapshot<Map<String, dynamic>> usrADoc = await usrRefA.get() as DocumentSnapshot<Map<String, dynamic>>;
    DocumentReference profilARef = usrADoc.data()!['profile'] as DocumentReference;
    // DocumentSnapshot<Map<String, dynamic>> profileADoc = await profilARef.get() as DocumentSnapshot<Map<String, dynamic>>;

    for (var fb in frsB) {
      DocumentSnapshot<Map<String, dynamic>> fbDoc = await fb.get();
    DocumentReference usrRefB = fbDoc.data()!['friend'] as DocumentReference;
    DocumentSnapshot<Map<String, dynamic>> usrBDoc = await usrRefB.get() as DocumentSnapshot<Map<String, dynamic>>;
    DocumentReference profilBRef = usrBDoc.data()!['profile'] as DocumentReference;
    // DocumentSnapshot<Map<String, dynamic>> profileADoc = await profilARef.get() as DocumentSnapshot<Map<String, dynamic>>;

// 
      if (profilARef == profilBRef) {
        res++;
      }
    }
  }
  return res;
}

int mutualCount(User a, User b) {
  int res = 0;
  Future.wait([mutualTmp(a, b).then((value) => res = value)]);
  return res;
}

//
//

// Notifs
//
//
// String tokennotif = "";
//
//   Future envoiNotif(String token, String title, String body) async {
//   var url = 'https://fcm.googleapis.com/fcm/send';
//   Dio dio = Dio();
//   final response5 = await dio.post(
//     url,
//     data: json.encode({
//       "to": token,
//       //"registration_ids": util_notif,
//       "notification": {
//         "body": body,
//         "title": title,
//         //"click_action": "FLUTTER_NOTIFICATION_CLICK",
//         //"content_available": true,
//       },
//     }),
//     options: Options(
//       headers: {
//         "Authorization":
//             // "key=a3a121fa324afd13332d949288430720faf7f5d3",
//             "key=AAAAeFcNGjM:APA91bFud2A4PbTRlZeUWGFrI4tPXpi6ByfqTYFxduc0UaGg9iieOYdWGTz1ctNFuY01ahZoEH_0PE4TeumjOxyWUVlktS7wAv2jgjyhumBs8a2g_MLj4KFR9Wp2u1db3ox_JKEQbGTs",
//         "Content-Type": "application/json",
//         "charset": "utf-8"
//       },
//     ),
//   );

//   var vresponse = response5.statusCode;
//   print(vresponse.toString());

//   response5.statusCode;
//   print(response5.statusCode);

//   return null;
// }

Map serviceAccount = {
  "type": "service_account",
  "project_id": "sweet-chat-vf",
  "private_key_id": "a3a121fa324afd13332d949288430720faf7f5d3",
  "private_key":
      "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3e6dkbFdco+zi\nXvtApq8Hyof0tz9QxJkG0bpm6CBHVwNKEpy7Ke5FU+QnG5XQkNchLGpgQILgZjRt\nuUDEsWJBPAwHgES/Ce7UsYQ45KHFAlm8LoR1UhtTTN6/MFW7WiYRGeEo3EuKnRvP\nSv/AbWK6Ztprc1Esf83VJ9DzsrKhGd2NZ5sSk5EUGDkETpsVWBPuUeVOsICrZvE/\n8wNpJHZnfYI8GMtd752eEW0NI1hmJ9wSeOYR17+4mYU6lLFQirHBXwJAx+V/2jA5\naGokchycGuz0qI+M5enVcBY6GBqqyuC9tvbKY7IIasIgeuU5Ke0V7xakkkRCB6HO\nBp7Ln06ZAgMBAAECggEAR3/xrpIDhy+/90TBDyQFL/mN+mBQVYaPBVfEFibdsT8o\nonxXRB4mYjC7RzwaKODQXHaE64YoGg7p3loi8aMYIUinfWLQJ0vVHGAioNMDcRSl\n6E2OQ3Of/1mEsadBuVT7YY2ersAN1fG8LQ7SU+esYewDsHyLBNa23Jn79INN1bXn\n0WwJzL4IsROoo0C85q1hY5V47UIBhavps+qkUOb8x7oMh3ha7DrdxgrlAhXyZGxw\nkGcO1N6J78YgQ+xHSYHKL2CgTMr0pnXhZ4fhbR73MZGLIlfOnYdFuq5D+zot0gxD\n22DpTXJI+R6Xi1tYjuzM747Y068lzyo17zVTmc3AwwKBgQDn7u4i/+3rsf9k8RPQ\nmnJSeAS575RBvhTYkSkMIvGVoa+hSVQWWNr7uJAd6e9fROq05ggTlnqC9t3Pd33W\nYt3cI+R66uIAV6lPwrqkFOVwDb4R9YXm4HN4nHfxRol2Umr+Vn4jMcqHt+a4QNsJ\nnOq3IMX8khwJimDobUhmcQ6sbwKBgQDKhbD+xgy5bNv9eG8cLqQ3tN+GoirHJcMN\n1Vpmi8xDwiHRWwzRAE+t4ZbKTHAB8oNoK9ur6jtaVa7b1opiuMb8Pwx1G4kHEb3f\nM5HaHnD9SOIonoYc/BRX+Oulz5/QEB6/tVtkjP1SW05ZEwYmQcfvhRVe30EKqfAo\n2LQgtzbJdwKBgCknl2/0c9ZHzmat9HMmhLSngUcxAOCthutqzprNtIp1l0GKTnZs\nq+bQuBnmwcfo5bDVxIcdQ33rqi4/KMAa6P1ADTHWbeXbqDpz9kRZROEePyTWqTzv\nhO3Y7duNRaUOONgKpvU9x49PjYwSTguloWx/T0Ji9sCmok173sX2t8DXAoGABBgx\n3OTKKxGNXRGLRYmX3lx0zHcI4F/eErCGlF4tMg2Bu4bYun0EH2LZNpvXA+MQTxHb\n7hzdOFVVJLKwt5A+zajEqrV0zsTIDvQu9bb519UaZXHXCkz6aFDrCr4o3/8DcCLN\nhznmgTzBV8GvtSRNU4VgSju/R+Tpqxm+go7Rt78CgYEA1W7JbeUTo1iKomCKHZG2\n4QEEfib9M5dsoGWg+kRuKfqhyCDaHR9ltyCwSWEsXq8UDiam6Ersc9syrC7HBRpL\n2/s9i9V/bjODleoa5rs9/7LMm5axjdOMu6Bp982ao3PzJtdX1ypmI0cPBV7rFW0L\npOJm6WXPgVU01xYcLzHX+1w=\n-----END PRIVATE KEY-----\n",
  "client_email":
      "firebase-adminsdk-fbsvc@sweet-chat-vf.iam.gserviceaccount.com",
  "client_id": "111417455447564730472",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url":
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40sweet-chat-vf.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

Future<String> obtainCredentials() async {
  var accountCredentials = ServiceAccountCredentials.fromJson({
    "private_key_id": serviceAccount['private_key_id'], //"<please fill in>",
    "private_key": serviceAccount['private_key'], // "<please fill in>",
    "client_email": serviceAccount[
        'client_email'], // "<please fill in>@developer.gserviceaccount.com",
    "client_id": serviceAccount[
        'client_id'], // "<please fill in>.apps.googleusercontent.com",
    "type": serviceAccount['type'], // "service_account"
  });
  var scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

  var client = http.Client();
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
          accountCredentials, scopes, client);

  //print("mon credentials est : ${credentials.accessToken.data}");

  client.close();
  return credentials.accessToken.data;
}

Future<List> envoiNotifnew(String tokenuser, String title, String body) async {
  String accestoken = await obtainCredentials();

  var sortiemap = {
    'message': {
      'token': tokenuser,
      'notification': {
        'title': title,
        'body': body,
      }
    }
  };

  String sortieString = json.encode(sortiemap);

  var url2 = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/sweet-chat-vf/messages:send');

  try {
    var response = await http.post(
      url2,
      body: sortieString,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $accestoken"
      },
    );

    print(
        "reponse notif : ${response.body} :: status code ${response.statusCode}");

    if (response.statusCode == 200) {
    } else {}
  } catch (e) {
    print("erreur $e");
  }

  return [];
}

//

selectFile() async {
  //

  // var bytes;
  //
  final file = await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg', 'jpeg'],
    allowMultiple: false,
  );
  if (file != null) {
    // final file1 = file.files.single;
    // String filename = file1.name;
    // bytes = file.files.single.bytes;
    // var typfich = file.files.single.extension!;

    return file.files.single;
  }

  return null;
}

var cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://812198243497171:10S5OUsWuc3ivDvdxUmepM7VFeA@dyta23qnc');

uploadFile(file, String id) async {
  cloudinary.config.urlConfig.secure = true;
  var response = await cloudinary.uploader().upload(File(file),
      params: UploadParams(
          publicId: id,
          uniqueFilename: true,
          // folder: "imgs",
          overwrite: true));
  print(response?.data?.publicId);
  print(response?.data?.secureUrl);

  return response?.data?.secureUrl ?? "";

  //
}

Future<String> uploadAudio(File audioFile) async {
  var url = Uri.parse("$urlserveur/upload");

  String resulto = "";

  try {
    var request = http.MultipartRequest('POST', url)
      // ..fields['upload_preset'] = 'ton_upload_preset'
      ..headers.addAll({
        'Content-Type': 'application/json',
        'apikey': '74720f09-4e91-45fe-8fb6-92765e341fdb'
      })
      ..fields.addAll({
        'chemin': "upload/tmp_docs/",
      })
      ..files.add(await http.MultipartFile.fromPath('file', audioFile.path,
          filename: audioFile.path.split('/').last));

    var response2 = await request.send();

    if (response2.statusCode == 200) {
      final responseBody = await response2.stream.bytesToString();
      print(jsonDecode(responseBody));
      resulto =
          "https://outilsco.com/api_outilsco/public/upload/tmp_docs/${audioFile.path.split('/').last}";
    } else {
      print("Erreur du serveur, veuillez réessayer");
      // msgerreur(
      //     context, 'Mail non envoyé, erreur du serveur, veuillez réessayer');
    }
  } catch (e) {
    print("Erreur, Vérifiez votre connexion internet");
    // msgerreur(
    //     context, 'Mail non envoyé, erreur, Vérifiez votre connexion internet');
    print(e);
  }
  return resulto;
}

//

// String ctsheme = 'https', cthost = 'outilsco.com';
String ctsheme = 'http', cthost = 'localhost';
String urlserveur = 'https://outilsco.com/api_outilsco/public/api';
// String urlserveur = 'http://localhost/canaldm';

bool connectedToInternet = true;

double scrW(context) {
  return MediaQuery.of(context).size.width;
}

double scrH(context) {
  return MediaQuery.of(context).size.height;
}

List colslst = [
  // Color.fromARGB(131, 0, 0, 0),
  // Colors.red,
  Color.fromARGB(255, 233, 104, 61),
  Color.fromARGB(255, 255, 145, 0),
  Color.fromARGB(255, 110, 233, 61),
  Color.fromARGB(255, 61, 233, 78),
  Color.fromARGB(255, 13, 227, 250),
  Color.fromARGB(255, 28, 156, 247),
  Color.fromARGB(255, 78, 61, 233),
  Color.fromARGB(255, 173, 61, 233),
  Color.fromARGB(255, 233, 61, 196),
  Color.fromARGB(255, 233, 61, 61),
];

Color randomColor() {
  return colslst[Random().nextInt(colslst.length)];
}

Widget customBadge(Widget child, Widget content, {bool animate = false}) {
  return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -15, end: -15),
      showBadge: true,
      ignorePointer: false,
      onTap: () {},
      badgeContent: content,
      // badgeAnimation: const badges.BadgeAnimation.rotation(
      //   animationDuration: Duration(seconds: 1),
      //   colorChangeAnimationDuration: Duration(seconds: 1),
      //   loopAnimation: true,
      //   curve: Curves.fastOutSlowIn,
      //   colorChangeAnimationCurve: Curves.easeInCubic,
      // ),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.circle,
        badgeColor: theme.dred1,
        padding: EdgeInsets.all(5),
        // borderRadius: BorderRadius.circular(4),
        // borderSide: BorderSide(color: Colors.white, width: 2),
        elevation: 3,
      ),
      child: child);
}

void ouvrirO(context, page) {
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

void ouvrirR(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

void fermer(context) {
  Navigator.of(context).pop();
}

void showsnack(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: theme.dred1),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 228, 228),
      duration: Duration(milliseconds: 1000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showToast(BuildContext context, String title, String content,
    {ToastificationType type = ToastificationType.success}) {
  toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: type,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 8),
    title: Text(title),
    // you can also use RichText widget for title and description parameters
    description:  Text(content),// RichText(text: TextSpan(text: content)),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 500),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    icon: const Icon(Icons.notifications_active_outlined),
    showIcon: true, // show or hide the icon
    primaryColor: Color(0xffEE5366),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xffEE5366) ),
    boxShadow: const [
      // BoxShadow(
      //   color: Color(0x07000000),
      //   blurRadius: 16,
      //   offset: Offset(0, 16),
      //   spreadRadius: 0,
      // )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

Future timepicker(BuildContext context) async {
  final TimeOfDay? tempchoix =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  // ignore: use_build_context_synchronously
  return tempchoix == null ? '' : tempchoix.format(context);

  //  timepicker(context).then((value) => textheuredp.text=value); UTILISATION
}

Future datepicker(BuildContext context) async {
  final DateTime? tempchoix = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 15),
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: DateTime(DateTime.now().year - 10));
  // ignore: use_build_context_synchronously
  return tempchoix ?? '';

  // datepicker(context).then((value) => textheuredp.text=value);  UTILISATION
}

String engtimetofrench(String engtime) {
  if (engtime.isEmpty) {
    return '';
  }
  int hr = int.parse(engtime.split(' ')[0].split(':')[0]);
  int min = int.parse(engtime.split(' ')[0].split(':')[1]);
  String ampm = engtime.split(' ')[1];
  if (ampm == 'PM' && hr != 12) {
    hr += 12;
  } else if (ampm == 'PM' && hr == 12) {
    hr = 0;
  }
  return '${hr.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

  /* engtimetofrench(value) UTILISATION */
}

DateTime doubletodatetime(DateTime depart, double nbhr) {
  int day = (nbhr / 24).floor();
  nbhr -= day * 24;
  int hr = nbhr.toInt() % 24;
  nbhr -= hr;
  int min = (nbhr * 60).floor();
  nbhr = ((nbhr * 60) - min);
  int sec = (nbhr * 60).floor();

  // print('jr : $day , hr : $hr , min : $min , sec : $sec');

  DateTime date =
      depart.add(Duration(days: day, hours: hr, minutes: min, seconds: sec));
  return date;
}

DateTime strtoDateTime(String str) {
  if (str.split(' ').length == 2) {
    List date = str.split(' ')[0].split('-');
    List heure = str.split(' ')[1].split(':');
    return DateTime(
      int.parse(date[0]),
      int.parse(date[1]),
      int.parse(date[2]),
      //
      int.parse(heure[0]),
      int.parse(heure[1]),
      int.parse(heure[2]),
    );
  }
  List date = str.split(' ')[0].split('-');
  return DateTime(
    int.parse(date[0]),
    int.parse(date[1]),
    int.parse(date[2]),
    //
  );
}

String intcodegenerator(int length, List<String> notin) {
  List<int> code = [];
  String codestr = '';
  do {
    code = List.generate(length, (_) => Random().nextInt(10));
    codestr = code.join();
  } while (notin.contains(codestr));
  return codestr;
}

String passwordGenerator(int length) {
  const caracteresPermis =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
  Random random = Random();
  String resultat = '';

  while (resultat.length <= length) {
    int index = random.nextInt(caracteresPermis.length);
    String caractere = caracteresPermis[index];
    if (!resultat.contains(caractere) && caractere.isNotEmpty) {
      resultat += caractere;
    }
  }
  return resultat;
}

String datetoday(DateTime date, [String fren = 'fr']) {
  const List daysfr = [
    'lundi',
    'mardi',
    'mercredi',
    'jeudi',
    'vendredi',
    'samedi',
    'dimanche'
  ];
  const List daysen = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  if (fren == 'fr') {
    return daysfr[date.weekday - 1];
  }
  return daysen[date.weekday - 1];
}

String datetomonth(DateTime date, [String fren = 'fr']) {
  const List daysfr = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'aout',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];
  const List daysen = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  if (fren == 'fr') {
    return daysfr[date.month - 1];
  }
  return daysen[date.month - 1];
}

Future msgerreur(BuildContext context, String msg) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Erreur !'),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      });
}

Future msgsucces(BuildContext context, String msg) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Succès !'),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      });
}

Future customDiag(BuildContext context, Widget child) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          scrollable: true,
          // title: const Text('Succès !'),
          content: child,
          // actions: [
          //   TextButton(
          //       onPressed: () {
          //         Navigator.pop(context);
          //         // if (page != Null) {
          //         //   ouvrirR(context, page);
          //         // }
          //       },
          //       child: const Text('OK'))
          // ],
        );
      });
}

String tempsEcoule(DateTime datec, [String fren = 'en']) {
  String resultat = "";

  Duration duree = DateTime.now().difference(datec);

  if (datec.year < DateTime.now().year) {
    resultat = "${datec.day} ${datetomonth(datec, fren)}, ${datec.year}";
  } else if ((datec.month < DateTime.now().month) ||
      ((datec.month == DateTime.now().month)) &&
          (DateTime.now().day - datec.day >= 7)) {
    resultat = "${datec.day} ${datetomonth(datec, fren)}";
  } else if (DateTime.now().day - datec.day >= 2) {
    resultat = fren == 'fr'
        ? "Il y a ${DateTime.now().day - datec.day} jrs"
        : "${DateTime.now().day - datec.day} days ago";
  } else if (DateTime.now().day - datec.day == 1) {
    resultat = fren == 'fr' ? "Hier" : "Yesterday";
  } else if (duree.inHours >= 1) {
    resultat = fren == 'fr'
        ? "Il y a ${duree.inHours} hr."
        : "${duree.inHours} hr. ago";
  } else if (duree.inMinutes >= 1) {
    resultat = fren == 'fr'
        ? "Il y a ${duree.inMinutes} min"
        : "${duree.inMinutes} min ago";
  } else if (duree.inSeconds >= 1) {
    resultat = fren == 'fr'
        ? "Il y a ${duree.inSeconds} sec"
        : "${duree.inSeconds} sec ago";
  }
  return resultat;
}

String chatTime(context, DateTime datec, [String fren = 'fr']) {
  // String rs = '';
  TimeOfDay tm = TimeOfDay.fromDateTime(datec);

//   if (fren == 'fr') {
//     rs = "${tm.hour}h ${tm.minute}min";
//   } else {
//     if(tm.hour > 12){
//  rs = "${tm.hour}:${tm.minute} PM";
//     } else {
//  rs = "${tm.hour}:${tm.minute} AM";

//     }
//   }

  return DateTime.now().difference(datec).inDays < 1
      ? tm.format(context)
      : DateTime.now().difference(datec).inDays < 2
          ? "Yesterday"
          : "${datec.day}/${datec.month}/${datec.year}";
}

customBottomSheetBuildContext(context, double height, Widget child,
    {bool isDismissible = false}) {
  showModalBottomSheet(
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return FractionallySizedBox(heightFactor: height, child: child);
    },
  );
}

Future<String> envoimail(
    BuildContext context, String vtr, String msg, String to,
    {String passwd = '', String npi = '', path = '', nb = ''}) async {
  var url2 = "$urlserveur/envoimail";

  String fromData = jsonEncode({
    'vartraitement': "1",
    'email': to,
    'codemail': msg,
  });

  try {
    final response2 = await http.post(
      Uri.parse(url2),
      headers: {
        'Content-Type': 'application/json',
        'apikey': '74720f09-4e91-45fe-8fb6-92765e341fdb'
      },
      body: fromData,
    );

    if (response2.statusCode == 200) {
      print(response2.body);
      var resultat = json.decode(response2.body);
      if (resultat == "succes") {
        print("Mail Envoyé");
      } else {
        print("Erreur mail non envoyé, veuillez réessayer");
        // msgerreur(context, 'Erreur mail non envoyé, veuillez réessayer');
      }
    } else {
      print("Erreur du serveur, veuillez réessayer");
      // msgerreur(
      //     context, 'Mail non envoyé, erreur du serveur, veuillez réessayer');
    }
  } catch (e) {
    print("Erreur, Vérifiez votre connexion internet");
    // msgerreur(
    //     context, 'Mail non envoyé, erreur, Vérifiez votre connexion internet');
    print(e);
  }
  return '';
}

Future<bool> customuploadFile(String chemin, String filename, var bytes) async {
  // String lienfinal = '';
  try {
    FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(bytes, filename: filename)});

    Response response = await Dio()
        .post("$urlserveur/upload.php", data: formData, queryParameters: {
      "chemin": chemin,
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      print("File upload response: $response");
      var datainfo = json.decode(response.data);
      // print(datainfo);
      if (datainfo["status"] == true) {
        print('succès');
        // setState(() {
        //   lienfinal =
        //       "upload/user_${connectedUser.profile.id}/docs/docdom_${e.id}_$iddom.${e.typfich}";
        //   print("chemin: $urlserveur/$lienfinal");

        //   //
        // });
        //
        //

        //
      }
    }

    //_showSnackBarMsg(response.data['message']);
  } catch (e) {
    print("expectation Caugch: $e");
  }
  //
  return false;

  //
}

//

// Future admsgsucces(BuildContext context, String msg) {
//   return AwesomeDialog(
//                       context: context,
//                       dialogType: DialogType.success,
//                       buttonsBorderRadius: const BorderRadius.all(
//                         Radius.circular(2),
//                       ),
//                       animType: AnimType.rightSlide,
//                       title: 'Passing Data Back',
//                       titleTextStyle: const TextStyle(
//                         fontSize: 32,
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       desc: 'Dialog description here...',
//                       showCloseIcon: true,
//                       btnCancelOnPress: () {},
//                       btnOkOnPress: () {},
//                       autoDismiss: false,
//                       onDismissCallback: (type) {
//                         Navigator.of(context).pop(type);
//                       },
//                       barrierColor: Colors.purple[900]?.withOpacity(0.54),
//                     ).show();
// }

String obscur(String string, int startind, int endind, String pattern) {
  return '${string.substring(0, startind).padRight(endind, pattern)}${string.substring(endind, string.length)}';
}

String hider(String string, int maxchar, String pattern, int patternlen) {
  return '${string.substring(0, maxchar - 1 - patternlen)}${pattern * patternlen}';
//  return'${string.substring(0,maxchar-1-patternlen).padRight(patternlen, '*')}';
}
//
// hider(dom.nom, 12, '.', 3)

// 8min + 1maj + 1chiff + 1special
RegExp remdp = RegExp(
    r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z0-9!@#$%^&*(),.?":{}|<>]{6,}$');

RegExp passRegex = RegExp(r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>]{8,}$');

RegExp npiRegex = RegExp(r'^[0-9]{10}$');
RegExp ifuRegex = RegExp(r'^[0-9]{13}$');

RegExp numeroRegex2 = RegExp(r'^[0-9]{8}$');

RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

RegExp numeroRegex1 = RegExp(r'^\+(?:[0-9] ?){6,14}[0-9]$');

RegExp datenaissRegex =
    RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/((19|20)\d\d)$');

RegExp doubleRegex = RegExp(r'^\d+\.?\d{0,2}');

RegExp fbkRegex =
    RegExp(r'^(http|https)://(www\.)?facebook.com/([a-zA-Z0-9.]{3,})/?$');
RegExp instaRegex =
    RegExp(r'^(http|https)://(www\.)?instagram.com/([a-zA-Z0-9._]{3,})/?$');
RegExp linRegex =
    RegExp(r'^(http|https)://(www\.)?linkedin.com/in/([a-zA-Z0-9-]{3,})/?$');
RegExp twtrRegex =
    RegExp(r'^(http|https)://(www\.)?twitter.com/([a-zA-Z0-9_]{1,15})/?$');
