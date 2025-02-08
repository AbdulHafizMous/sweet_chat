import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/auth_service.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/widgets.dart';
import '../utils/decoration.dart';
import '../utils/custom.dart';
// import '../menu.dart';
import '../pages/menu.dart';

class SignIn1 extends StatefulWidget {
  const SignIn1({super.key});

  @override
  State<SignIn1> createState() => _SignIn1State();
}

class _SignIn1State extends State<SignIn1> {
  final keyform = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool cache = true, loading = false;

  final AuthService _authService =
      AuthService(); // Instance du service d'authentification

  /// **Connexion avec Email et Mot de Passe**
  void checkUser() async {
    setState(() => loading = true);

    final user = await _authService.login(
      email.text.trim(),
      password.text.trim(),
    );

    setState(() => loading = false);

    if (user != null) {
      setState(() {
        connectedUser.profile.id = user.uid;
        // showsnack(context, user.uid);
      });
      // Rediriger vers la page des discussions après une connexion réussie
      fermer(context);
      ouvrirR(context, const ManuPage());
    } else {
      // Afficher une erreur si la connexion échoue
      showsnack(context,
          "Sign In Error. Check your Internet and retry !");
    }
  }

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
      showsnack(context, "Google Login Error.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setState(() {
      loading = false;
      // email.text = connectedUser.profile.email.isNotEmpty
      //     ? connectedUser.profile.email
      //     : "abdulmoustapha64@gmail.com";
      // email.text = "abdulmoustapha64@gmail.com";
      // password.text = "azerty1234@";
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      // LoadingJumpingLine.square(backgroundColor: context.watch<AppTheme>().themeclass.dred1 ),
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
                    backgroundColor:
                        context.watch<AppTheme>().themeclass.dred22,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        'Sign In',
                        style: wtTitle(
                            30,
                            1,
                            context.watch<AppTheme>().themeclass.dred4,
                            true,
                            false),
                      ),
                      background: Container(
                        margin: EdgeInsets.all(30),
                        height: 300,
                        // height: MediaQuery.of(context).size.height*0.4,
                        width: 300,
                        // width: double.maxFinite,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    context.watch<AppTheme>().themeclass.dred1),
                            boxShadow: [
                              BoxShadow(
                                  color: context
                                      .watch<AppTheme>()
                                      .themeclass
                                      .dred1,
                                  blurRadius: 50,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: -10)
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                alignment: Alignment.center,
                                image: AssetImage('imgs/wt1.jpg'))),
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
                        color: context.watch<AppTheme>().themeclass.dred22,
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
                                      top: 25.0, left: 15, right: 15),
                                  // height: MediaQuery.of(context).size.height*0.850,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Welcome Back !',
                                        style: wtTitle(
                                            25,
                                            1,
                                            context
                                                .watch<AppTheme>()
                                                .themeclass
                                                .dred1,
                                            true,
                                            false),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Few Steps to access your wall !',
                                          style: wtTitle(
                                              15,
                                              1,
                                              context
                                                  .watch<AppTheme>()
                                                  .themeclass
                                                  .dred3,
                                              true,
                                              false),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
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
                                              18,
                                              1,
                                              context
                                                  .watch<AppTheme>()
                                                  .themeclass
                                                  .dred3,
                                              true,
                                              false),
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
                                      TextFormField(
                                          obscureText: cache,
                                          controller: password,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Password Required !';
                                            }
                                            return null;
                                          },
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.text,
                                          // inputFormatters: [FormatTelph()],
                                          style: wtTitle(
                                              18,
                                              1,
                                              context
                                                  .watch<AppTheme>()
                                                  .themeclass
                                                  .dred3,
                                              true,
                                              false),
                                          decoration: mydecoration(
                                              "Password",
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
                                                        Icons.password_outlined,
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
                                                      Text('|',
                                                          style: wtTitle(
                                                              18,
                                                              1,
                                                              Colors.black,
                                                              true,
                                                              false)),
                                                      cache == true
                                                          ? IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  cache = false;
                                                                });
                                                              },
                                                              icon: Icon(Icons
                                                                  .visibility_outlined),
                                                              color:
                                                                  Colors.black,
                                                            )
                                                          : IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  cache = true;
                                                                });
                                                              },
                                                              icon: Icon(Icons
                                                                  .visibility_off_outlined),
                                                              color:
                                                                  Colors.black,
                                                            )
                                                    ],
                                                  )),
                                              BorderRadius.circular(30))),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: TextButton(
                                          onPressed: () {
                                            if (keyform.currentState!
                                                .validate()) {
                                              checkUser();
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Log In',
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
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateColor.resolveWith(
                                                      (states) => context
                                                          .watch<AppTheme>()
                                                          .themeclass
                                                          .dred2),
                                              shape: WidgetStatePropertyAll(
                                                  StadiumBorder())),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 20,
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
                                      const SizedBox(height: 15),

                                      // Bouton Continuer avec Google
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _handleGoogleLogin();
                                        },
                                        icon: Brand(
                                          Brands.google,
                                          size: 25,
                                        ),
                                        //  Icon(Bootstrap.google, size : 25, color: Color.fromARGB(255, 255, 81, 68),),
                                        label:
                                            const Text("Google"),
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
}
