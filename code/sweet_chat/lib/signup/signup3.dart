import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/auth_service.dart';
import 'package:sweet_chat/pages/menu.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/widgets.dart';
// import 'package:flutter_countries/flutter_countries.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/decoration.dart';
import '../signup/signup4.dart';

import '../utils/custom.dart';

class SignUp3 extends StatefulWidget {
  const SignUp3({super.key});

  @override
  State<SignUp3> createState() => _SignUp3State();
}

TextEditingController email = TextEditingController();
bool loading = false;

class _SignUp3State extends State<SignUp3> {
  final keyform = GlobalKey<FormState>();

// Future _load() async{
//    // await Countries.getall().then((value) => countryList = value );
//   await Countries.every().then((value) => countries = value);
//   await States.byCountryId(countries.firstWhere((e) => e.phoneCode=='229').id.toString()).then((value) => regionslist = value );
//   // await Cities.byStateId(region.id.toString()).then((value) => citieslist = value );

// }
  final AuthService _authService =
      AuthService(); // Instance du service d'authentification

  /// **Connexion avec Google**
  void _handleGoogleLogin() async {
    setState(() => loading = true);

    final user = await _authService.signInWithGoogle(context);

    setState(() => loading = false);

    if (user != null) {
      setState(() {
        connectedUser.profile.id = user.uid;
      });
      // Rediriger vers la page des discussions après une connexion réussie
      fermer(context);
      ouvrirR(context, const ManuPage());
    } else {
      showsnack(context, "Error During Google Login.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // _load();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: SliverOverlapAbsorberHandle(),
                  sliver: SliverAppBar(
                    expandedHeight: 300,
                    floating: true,
                    pinned: true,
                    elevation: 50,
                    backgroundColor: theme.dred2,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        'Sign Up',
                        style: wtTitle(30, 1, theme.dred4, true, false),
                      ),
                      background: Container(
                        margin: EdgeInsets.all(30),
                        height: 300,
                        // height: MediaQuery.of(context).size.height*0.4,
                        width: 300,
                        // width: double.maxFinite,
                        decoration: BoxDecoration(
                            border: Border.all(color: theme.dred1),
                            boxShadow: [
                              BoxShadow(
                                  color: theme.dred1,
                                  blurRadius: 50,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: -10)
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                alignment: Alignment.center,
                                image: AssetImage('imgs/wt5.png'))),
                      ),
                    ),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              // controller: 0
              child: Column(
                children: [
                  const SizedBox(
                    height: 92,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        color: theme.dred2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        child: Center(
                          child: Form(
                            key: keyform,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 45.0, left: 15, right: 15),
                                  // height: MediaQuery.of(context).size.height*0.850,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Get Started !',
                                        style: wtTitle(
                                            25, 1, theme.dred1, true, false),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Create your own account !',
                                          style: wtTitle(
                                              15, 1, theme.dred3, true, false),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'First Add your E-Mail Adress',
                                          style: wtTitle(
                                              15, 1, theme.dred3, true, false),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      TextFormField(
                                          controller: email,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'E-mail Required !';
                                            } else if (emailRegex
                                                    .hasMatch(value) ==
                                                false) {
                                              return 'Invalid E-mail Adress';
                                            }
                                            return null;
                                          },
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          // inputFormatters: [FormatTelph()],
                                          style: wtTitle(
                                              18, 1, theme.dred3, true, false),
                                          decoration: mydecoration(
                                              "E-mail Adress",
                                              18,
                                              18,
                                              true,
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(
                                                        Icons.mail_outlined,
                                                        color: Colors.black,
                                                      ),
                                                      Text('|',
                                                          style: wtTitle(
                                                              18,
                                                              1,
                                                              Colors.black,
                                                              true,
                                                              false))
                                                    ],
                                                  )),
                                              false,
                                              const SizedBox(
                                                width: 0,
                                              ),
                                              BorderRadius.circular(30))),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: TextButton(
                                          onPressed: () async {
                                            if (keyform.currentState!
                                                .validate()) {
                                              bool res = await doesUserExist(
                                                  email.text);
                                              print(email.text);
                                              print("exist : $res");
                                              if (res) {
                                                showsnack(context,
                                                    "User Already Registered. Just Login Please !");
                                              } else {
                                                setState(() {
                                                  loading = true;
                                                });
                                                String code =
                                                    intcodegenerator(4, []);
                                                print(code);
                                                await envoimail(
                                                    context,
                                                    '1',
                                                    code,
                                                    email
                                                        .text); //normalement sur le mail connectedUser.profile.email


                                                         connectedUser = User(
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

                                                // Pour gérer le code envoyé
                                                connectedUser.profile.email =
                                                    email.text;
                                                connectedUser.profile.confcode =
                                                    code;

                                                setState(() {
                                                  loading = false;
                                                });

                                                //
                                                ouvrirO( context, const SignUp4());
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateColor.resolveWith(
                                                      (states) => theme.dred2),
                                              shape:
                                                  const WidgetStatePropertyAll(
                                                      StadiumBorder())),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: wtTitle(
                                                      22,
                                                      1.5,
                                                      context
                                                          .watch<AppTheme>()
                                                          .themeclass
                                                          .dred4,
                                                      true,
                                                      false),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 20,
                                                  color: context
                                                      .watch<AppTheme>()
                                                      .themeclass
                                                      .dred4,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 15,
                                      ),

                                      // Divider OU
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: context
                                                  .watch<AppTheme>()
                                                  .themeclass
                                                  .dred1,
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "Continue With",
                                              style: TextStyle(
                                                  color: context
                                                      .watch<AppTheme>()
                                                      .themeclass
                                                      .dred1),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: context
                                                  .watch<AppTheme>()
                                                  .themeclass
                                                  .dred1,
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 25),

                                      // Bouton Continuer avec Google
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _handleGoogleLogin();
                                        },
                                        icon: Brand(
                                          Brands.google,
                                          size: 25,
                                        ),
                                        label: const Text("Google"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          side: BorderSide(
                                              color: context
                                                  .watch<AppTheme>()
                                                  .themeclass
                                                  .dred1),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 10),
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  doesUserExist(String email) async {
    final snap = await FirebaseFirestore.instance
        .collection('profile')
        .where('email', isEqualTo: email) 
        .get();

    return snap.docs.isNotEmpty;
  }
}
