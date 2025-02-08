import 'package:flutter/material.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import '../utils/decoration.dart';
import '../utils/custom.dart';
import '../signin/signin1.dart';
import '../signup/signup3.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> with SingleTickerProviderStateMixin {
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//     final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
//   switch (status) {
//     case InternetStatus.connected:
//       // The internet is now connected
//       break;
//     case InternetStatus.disconnected:
//       // The internet is now disconnected
//       break;
//   }
// });
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 55.0, left: 15, right: 15),
              height: MediaQuery.of(context).size.height * 0.80,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'JOIN',
                      style: wtTitle(30, 1, context.watch<AppTheme>().themeclass.dred1, true, false),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      height: 350,
                      // height: MediaQuery.of(context).size.height*0.4,
                      width: 350,
                      // width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: context.watch<AppTheme>().themeclass.dred1),
                          boxShadow: [
                            BoxShadow(
                                color: context.watch<AppTheme>().themeclass.dred1,
                                blurRadius: 50,
                                blurStyle: BlurStyle.outer,
                                spreadRadius: -10)
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage('imgs/wt3.jpg'))),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'THE TEAM',
                      style: wtTitle(25, 1, context.watch<AppTheme>().themeclass.dred1, true, false),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Get Rolled Up, invite your Friends and Start Chatting Now !',
                        style: wtTitle(15, 1, context.watch<AppTheme>().themeclass.dred3, true, false),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              // height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.watch<AppTheme>().themeclass.dred2,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // setState(() {
                        //   isLoading = true;
                        // });
            
                        ouvrirO(context, const SignUp3());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Sign Up',
                          style: wtTitle(25, 1.5, context.watch<AppTheme>().themeclass.dred4, true, false),
                        ),
                      ),
                      style: ButtonStyle(
                          // backgroundColor: MaterialStateColor.resolveWith((states) => context.watch<AppTheme>().themeclass.dred),
                          shape: WidgetStatePropertyAll(StadiumBorder())),
                    ),
                    // const Padding(
                    //   padding:  EdgeInsets.symmetric(vertical: 1.0),
                    //   child: VerticalDivider(
                    //     color: Colors.black,
                    //     width: 5,
                    //     thickness: 2,
                    //   ),
                    // ),
                    Text('|',
                                                          style: wtTitle(
                                                              18,
                                                              1,
                                                              context
                                                      .watch<AppTheme>()
                                                      .themeclass
                                                      .dred4,
                                                              true,
                                                              false)),
                    TextButton(
                      onPressed: () {
                        // setState(() {
                        //   loading = true;
                        // });
                        ouvrirO(context, const SignIn1());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Sign In',
                          style: wtTitle(25, 1.5, context.watch<AppTheme>().themeclass.dred4, true, false),
                        ),
                      ),
                      style: ButtonStyle(
                          // backgroundColor: MaterialStateColor.resolveWith((states) => context.watch<AppTheme>().themeclass.dred),
                          shape: WidgetStatePropertyAll(StadiumBorder())),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
