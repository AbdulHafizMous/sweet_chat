import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_chat/pages/menu.dart';
import 'package:sweet_chat/pages/sign.dart';
import 'package:sweet_chat/pages/walk.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  //
  String firstTime = pref.getString("firstTime") ?? "";
  if (firstTime.isEmpty) {
    pref.setString("firstTime", '0');
  }
  // theme
  if (pref.getString("theme") == null) {
    pref.setString("theme", '0');
    isDarkTheme = false;
    theme = LightTheme();
  } else {
    print('defined');
    isDarkTheme = pref.getString("theme") == '0' ? false : true;
    theme = pref.getString("theme") == '0' ? LightTheme() : DarkTheme();
  }

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 
  

    // await obtainCredentials();

//

// Connect

  runApp(ChangeNotifierProvider(
    create: (context) => AppTheme(
        dred1: Color(0xffEE5366),
        dred2: Color(0xffff8aad),
        dred22: Color.fromARGB(179, 255, 138, 173),
        dred3: Color.fromARGB(131, 0, 0, 0),
        dred4: Color.fromARGB(255, 255, 255, 255),
        top: Color(0xffEE5366)),
    child: MainApp(
      firstTime: firstTime,
    ),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.firstTime});
  final String firstTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // themeMode: context.watch<AppTheme>().thememode,
        // theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        // home: firstTime.isEmpty ? WalkThrough() : Sign(),

        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: loadingAnimation());
            } else if (snapshot.hasData) {
              print( snapshot.data!.uid);
              connectedUser.profile.id = snapshot.data!.uid;
              return const ManuPage(); // Redirige vers la discussion si connecté
            } else {
              return firstTime.isEmpty ? WalkThrough() : Sign();
            }
          },
        ));
  }
}

// class TemplateWrapper2 extends StatefulWidget {
//   const TemplateWrapper2({super.key, required this.child});
//   final Widget child;

//   @override
//   State<TemplateWrapper2> createState() => _TemplateWrapper2State();
// }

// class _TemplateWrapper2State extends State<TemplateWrapper2> {
//   //
//   @override
//   void initState() {
//     super.initState();
//     checkInternet();

//   print("connected : $connectedToInternet");

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: !connectedToInternet
//             ? Center(
//                 child: Row(
//                 children: [
//                   Text('No Internet'),
//                   TextButton(
//                       onPressed: () {
//                         checkInternet();
//                         setState(() {});
//                       },
//                       child: Text("Retry"))
//                 ],
//               ))
//             : widget.child);
//   }
// }

// void checkInternet() async {
//   // Connection
//   bool result = await InternetConnection().hasInternetAccess;
//   connectedToInternet = result;
//   print(connectedToInternet);
// }
