import 'dart:async';
import 'dart:io';

import 'package:icons_plus/icons_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/loading/src2/four_rotating_dots/four_rotating_dots.dart';
import 'package:sweet_chat/utils/loading/src2/hexagon_dots/hexagon_dots.dart';
import 'package:sweet_chat/utils/loading/src2/stretched_dots/stretched_dots.dart';
import 'package:sweet_chat/utils/loading/src2/three_arched_circle/three_arched_circle.dart';
import 'package:sweet_chat/utils/loading/src2/three_rotating_dots/three_rotating_dots.dart';
import 'package:flutter/material.dart';
import 'package:sweet_chat/utils/decoration.dart';

import 'classlist.dart';

//
//  Internet Wrapper

class TemplateWrapper extends StatefulWidget {
  const TemplateWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<TemplateWrapper> createState() => _TemplateWrapperState();
}

class _TemplateWrapperState extends State<TemplateWrapper> {
  //
  late final StreamSubscription<InternetStatus> listener;
  bool upped = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      upped = false;
    });
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          //
          setState(() {
            connectedToInternet = true;
          });
          // showsnack(context, "The internet is now connected");
          if (upped) {
            fermer(context);
            upped = false;
          }
          break;
        case InternetStatus.disconnected:
          //
          setState(() {
            connectedToInternet = false;
            upped = true;
          });
          // showsnack(context, "The internet is disconnected");
          customBottomSheetBuildContext(
              context,
              0.22,
              SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          height: 130,
                          // height: MediaQuery.of(context).size.height*0.4,
                          width: 130,
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
                                  image: AssetImage('imgs/network.jpg'))),
                        ),
//
                        Column(children: [
                          Text(
                            'No Internet !',
                            style: wtTitle(20, 1, theme.dred1, true, false),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Please Try Again',
                            style: wtTitle(15, 1, theme.dred1, false, false),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              listener.resume();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Retry',
                                    style: wtTitle(
                                        22, 1, theme.dred4, true, false),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.replay_outlined,
                                    size: 20,
                                    color: theme.dred4,
                                  )
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith(
                                    (states) => theme.dred2),
                                shape: WidgetStatePropertyAll(StadiumBorder())),
                          )
                        ])
                      ])
                ],
              )),
              isDismissible: false);

          break;
      }
    });

    listener.resume();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        bool exito = await customDiag(context, confirmDeconnexion());

        print(exito);

        if (exito) {
          exit(0);
        }
      },
      child: Scaffold(body: widget.child),
    );
  }

  Widget confirmDeconnexion() {
    return StatefulBuilder(builder: (context, setStatex) {
      return Column(
        children: [
          //
          // Close
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  fermer(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.dred1,
                      )),
                  child: Icon(
                    Icons.close,
                    color: theme.dred1,
                  ),
                ),
              ),
            ],
          ),
          //
          // Title
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Leave',
              style: wtTitle(20, 1, Colors.black, true, false),
            ),
          ),
          //
          //
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.dred2, width: 15)),
            child: Icon(
              Icons.info_outline_rounded,
              color: theme.dred1,
              size: 200,
            ),
          ),
          //
          // Textes
          //
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Are you sure you want to leave the app !?',
              style: wtTitle(16, 1, Colors.black, false, false),
              textAlign: TextAlign.center,
            ),
          ),
          //
          //
          // Boutons
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customButton(
                  theme.dred1,
                  Text(
                    'No',
                    style: wtTitle(18, 1, theme.dred4, true, false),
                  ),
                  15, () async {
                //
                // fermer(context);
                // ouvrirR(context, Sign());
                Navigator.pop(context, false);
              }, -1, cp: EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              customButton(
                  theme.dred4,
                  Text(
                    'Yes',
                    style: wtTitle(18, 1, theme.dred1, true, false),
                  ),
                  15, () async {
                //
                // fermer(context);
                // ouvrirR(context, Sign());
                Navigator.pop(context, true);
              }, -1,
                  cp: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  bc: theme.dred1)
            ],
          )
        ],
      );
    });
  }
}

//
//

Widget customButton(Color? bgcol, Widget child, double radius,
    void Function() ontap, double padding,
    {opt = 1, EdgeInsets cp = const EdgeInsets.all(0), double bw = 1, bc}) {
  bc = bc ?? theme.dred1;
  return opt == 1
      ? InkWell(
          onTap: ontap,
          child: Card(
            color: bgcol,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius))),
            child: Container(
                padding: padding < 0 ? cp : EdgeInsets.all(padding),
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                child: child),
          ),
        )
      : InkWell(
          child: Container(
              padding: padding < 0 ? cp : EdgeInsets.all(padding),
              decoration: BoxDecoration(
                  color: bgcol,
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  border: Border.all(width: bw, color: bc)),
              child: child),
          onTap: ontap,
        );
}

Widget customRate(double rate, {double sz = 20}) {
  List<Widget> ch = [];

  int d = rate.floor(), m = (rate - rate.floor()).ceil(), f = 5 - d - m;

  for (var i = 0; i < d; i++) {
    ch.add(
      Icon(
        Icons.star_outlined,
        size: sz,
        color: Colors.yellow,
        // fill: 1,
      ),
    );
  }
  for (var i = 0; i < m; i++) {
    ch.add(
      Icon(
        Icons.star_half_outlined,
        size: sz,
        color: Colors.yellow,
        // fill: rate - rate.floor(),
      ),
    );
  }
  for (var i = 0; i < f; i++) {
    ch.add(
      Icon(
        Icons.star_border_outlined,
        size: sz,
        color: Colors.yellow,
        // fill: 0,
      ),
    );
  }

  return Container(
    child: Row(
      children: ch,
    ),
  );
}

Widget customCard(Widget childWidget,
    {col = const Color.fromARGB(255, 255, 255, 255)}) {
  return Card(
    surfaceTintColor: col,
    color: col,
    elevation: 10,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: childWidget,
    ),
  );
}

Widget customIcon(
    Color? bcolor, Color? fcolor, IconData icondata, void Function() ontap,
    {double rd = 20, double sz = 30}) {
  return Container(
      // padding: EdgeInsets.all(pd),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 0.5,
          offset: Offset(0, 5),
          color: Color.fromARGB(47, 0, 0, 0),
          spreadRadius: 1,
        )
      ], shape: BoxShape.circle),
      child: InkWell(
          onTap: ontap,
          child: CircleAvatar(
            radius: rd,
            backgroundColor: bcolor,
            child: Icon(
              icondata,
              size: sz,
              color: fcolor,
            ),
          )));
}

Widget socialLinks() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      customIcon(
          Color.fromARGB(255, 68, 99, 255), Colors.white, Icons.person, () {}),
      customIcon(
          Color.fromARGB(255, 255, 81, 68), Colors.white, Icons.person, () {}),
      customIcon(
          Color.fromARGB(255, 68, 105, 255), Colors.white, Icons.person, () {}),
      customIcon(
          Color.fromARGB(255, 255, 68, 68), Colors.white, Icons.person, () {}),
    ],
  );
}

Widget userProfile(BuildContext context, Profile user) {
  IconData usricon = Icons.person_outlined;

  return SizedBox(
    width: 420,
    child: Stack(alignment: Alignment.topRight, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Card(
          elevation: 10,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(30))),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                //border: Border.all(color: theme.dred1, style: BorderStyle.solid),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(30)),
                color: Color.fromARGB(108, 106, 255,
                    0)), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 0,
                    child: user.img.isEmpty
                        ? Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.dred1,
                            ),
                            // padding: EdgeInsets.all(80),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.pseudo[user.pseudo.length - 1],
                                  style:
                                      wtTitle(35, 1, Colors.white, true, false),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  user.pseudo[0],
                                  style:
                                      wtTitle(20, 1, Colors.white, true, false),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ))
                        : Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.dred1,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage('${user.img}'))),
                          )

                    // CircleAvatar(radius: 30, child: dom.img.isEmpty ?
                    // Text(user.nom[0], style: wtTitle(40, 1, Colors.white, true, false), textAlign: TextAlign.center,) : Image.network('${dom.img}') ),

                    ),
                //
                //
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 25),
                            child: Text(
                              '${user.name} ',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: wtTitle(16, 1, theme.dred1, true, false),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        // Row

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.work_outline_outlined,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  "personnal devlopment",
                                  style:
                                      wtTitle(14, 1, theme.dred3, true, false),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                            Expanded(
                                flex: 0,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_half_outlined,
                                      size: 20,
                                      opticalSize: 1,
                                      color: Colors.amber,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Text(
                                        "4.8",
                                        style: wtTitle(
                                            15, 1, theme.dred3, true, false),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                                height: 15,
                                child: VerticalDivider(
                                  thickness: 2,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  width: 10,
                                )),
                            Expanded(
                                flex: 0,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      size: 20,
                                      opticalSize: 1,
                                      color: Color.fromARGB(249, 3, 149, 62),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Text(
                                        '39+',
                                        style: wtTitle(
                                            15, 1, theme.dred3, true, false),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Contacter',
                                  style:
                                      wtTitle(14, 1, theme.dred1, true, false),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        )

                        //
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
          child: customIcon(Colors.white, theme.dred3, usricon, () {},
              rd: 15, sz: 20)),
    ]),
  );
}

Widget loadingAnimation() {
  return Column(
    children: [
      // LoadingBumpingLine.circle(),
      // LoadingDoubleFlipping.circle(),
      // LoadingFadingLine.circle(),
      // LoadingFlipping.circle(),
      // LoadingFilling.square(),
      // LoadingJumpingLine.circle(),

      // TwistingDots(size: 45, leftDotColor: theme.dred1, rightDotColor: theme.dred3),
      // Beat(color: theme.dred1, size: 45),
      // BouncingBall(size: 45, color: theme.dred1),
      // NewtonCradle(size: 45, color: theme.dred1),
      // StretchedDots(size: 45, color: theme.dred1),

      Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: HexagonDots(color: theme.dred2, size: 130),
          ),
          Positioned(
            child: StretchedDots(color: theme.dred1, size: 50),
          )
        ],
      )
    ],
  );
}

Widget customLoadingOP(Widget child) {
  return LoadingOverlayPro(
      overLoading: Column(
        children: [
          // LoadingBumpingLine.circle(),
          // LoadingDoubleFlipping.circle(),
          // LoadingFadingLine.circle(),
          // LoadingFlipping.circle(),
          // LoadingFilling.square(),
          // LoadingJumpingLine.circle(),

          // TwistingDots(size: 45, leftDotColor: theme.dred1, rightDotColor: theme.dred3),
          // Beat(color: theme.dred1, size: 45),
          // BouncingBall(size: 45, color: theme.dred1),
          // NewtonCradle(size: 45, color: theme.dred1),
          // StretchedDots(size: 45, color: theme.dred1),

          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: ThreeArchedCircle(color: theme.dred1, size: 120),
              ),
              Positioned(
                child: ThreeRotatingDots(color: theme.dred2, size: 60),
              )
            ],
          )
        ],
      ),
      progressIndicator: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(right : 8.0),
          //   child: Text('Chargement', style: wtTitle(20, 1, theme.dred4, true, false), ),
          // ),
          LoadingFadingLine.circle(
            borderColor: theme.dred1,
          ),
        ],
      ),
      isLoading: true,
      child: child);
}

// Widget customDelayedAnim(String begin, Duration delay, Widget child,
//     {Duration duration = const Duration(milliseconds: 800)}) {
//   Offset ofs = Offset(0, 0);
//   if (begin == 'left') {
//     ofs = Offset(-1, 0);
//   }
//   if (begin == 'right') {
//     ofs = Offset(1, 0);
//   }
//   if (begin == 'top') {
//     ofs = Offset(0, -1);
//   }
//   if (begin == 'bottom') {
//     ofs = Offset(0, 1);
//   }
//   return DelayedDisplay(
//     fadingDuration: duration,
//     delay: delay,
//     slidingBeginOffset: ofs,
//     child: child,
//   );
// }

//

Widget mdNotif(BuildContext context, Notif notif,
    {void Function()? delete,
    void Function()? confirm,
    void Function()? optdelete,
    void Function()? optgo,
    void Function()? optgo2}) {
  Widget child = Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          notif.img.isEmpty
              ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  // padding: EdgeInsets.all(80),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ))
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('${notif.img}'))),
                )
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        '${notif.content} ',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: wtTitle(15, 1, theme.dred3, false, false),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          height: 3,
          color: const Color.fromARGB(255, 189, 189, 189),
          width: scrW(context),
        ),
      ),
      notif.readState == '1'
          ? SizedBox()
          : InkWell(
              onTap: optgo,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: Text(
                          " Mark as read",
                          style: wtTitle(18, 1, theme.dred3, true, false),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                  ],
                ),
              ),
            ),
      InkWell(
        onTap: optdelete,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Text(
                    " Remove This Notification",
                    style: wtTitle(18, 1, theme.dred3, true, false),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))),
            ],
          ),
        ),
      ),
    ],
  );
  return Stack(
    alignment: Alignment.topRight,
    children: [
      InkWell(
        onTap: optgo2,
        onLongPress: () {
          customBottomSheetBuildContext(
              context, 0.3, SingleChildScrollView(child: child));
        },
        child: Card(
          elevation: 3,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: notif.readState == '1'
                    ? Colors.white
                    : theme
                        .dred22), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 0,
                    child: notif.img.isEmpty
                        ? Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            // padding: EdgeInsets.all(80),
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ))
                        : Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage('${notif.img}'))),
                          )

                    // CircleAvatar(radius: 30, child: dom.img.isEmpty ?
                    // Text(user.nom[0], style: wtTitle(40, 1, Colors.white, true, false), textAlign: TextAlign.center,) : Image.network('${dom.img}') ),

                    ),
                //
                //
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 25),
                            child: Text(
                              '${notif.content} ',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: wtTitle(16, 1, theme.dred3, true, false),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        // Row

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.date_range_outlined, //timer_outlined
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  tempsEcoule(DateTime.parse(notif.date)),
                                  style:
                                      wtTitle(14, 1, theme.dred3, true, false),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //
                        // Oblitéré
                        /*  notif.type != '0'
                            ? SizedBox()
                            : notif.readState == '0' &&
                                    connectedUser.friends
                                        .where(
                                          (f) =>
                                              !f.approved &&
                                              !f.requesting &&
                                              f.friend.profile.id ==
                                                  notif.userid,
                                        )
                                        .isNotEmpty
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        customButton(
                                            theme.dred1,
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Confirm',
                                                textAlign: TextAlign.center,
                                                style: wtTitle(15, 1,
                                                    theme.dred4, true, false),
                                              ),
                                            ),
                                            15,
                                            confirm!,
                                            -1,
                                            cp: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20)),
                                        customButton(
                                            Colors.grey,
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Delete',
                                                textAlign: TextAlign.center,
                                                style: wtTitle(15, 1,
                                                    theme.dred4, true, false),
                                              ),
                                            ),
                                            15,
                                            delete!,
                                            -1,
                                            cp: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20)),
                                      ])
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        connectedUser.friends
                                                .where(
                                                  (f) =>
                                                      f.approved &&
                                                      !f.requesting &&
                                                      f.friend.profile.id ==
                                                          notif.userid,
                                                )
                                                .isNotEmpty
                                            ? Text(
                                                'Confirmed',
                                                textAlign: TextAlign.center,
                                                style: wtTitle(15, 1,
                                                    theme.dred1, true, false),
                                              )
                                            : Text(
                                                'Refused',
                                                textAlign: TextAlign.center,
                                                style: wtTitle(15, 1,
                                                    Colors.grey, true, false),
                                              )
                                      ])
 */
                        //
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
          right: 10,
          child: customIcon(
              Colors.white, theme.dred3, Icons.settings_suggest_outlined, () {
            customBottomSheetBuildContext(
                context, 0.4, SingleChildScrollView(child: child));
          }, rd: 15, sz: 20)),
    ],
  );
}

Widget mdFriendRequest(
  BuildContext context,
  Friend user, {
  void Function()? delete,
  void Function()? confirm,
  void Function()? profile,
}) {
  int mutual = mutualCount(connectedUser, user.friend);
  return InkWell(
    onTap: profile,
    child: Card(
      elevation: 3,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors
                .white), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 0, child: 
                CircleAvatar(radius: 30, backgroundColor: theme.dred22, child: imageTemplate(user.friend.profile.img) ),

                ),
            //
            //
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Row(
                          children: [
                            Text(
                              '${user.friend.profile.name}${user.friend.profile.pseudo.isEmpty ? '' : " (${user.friend.profile.pseudo})"}',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: wtTitle(16, 1, theme.dred3, true, false),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    // Row

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.date_range_outlined, //timer_outlined
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                                child: Text(
                              tempsEcoule(DateTime.parse(user.date)),
                              style: wtTitle(14, 1, theme.dred3, true, false),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.group_outlined, //timer_outlined
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                                child: Text(
                              "$mutual mutual Friend(s)",
                              style: wtTitle(14, 1, theme.dred3, true, false),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customButton(
                            theme.dred1,
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Confirm',
                                textAlign: TextAlign.center,
                                style: wtTitle(15, 1, theme.dred4, true, false),
                              ),
                            ),
                            15,
                            confirm!,
                            -1,
                            cp: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20)),
                        customButton(
                            Colors.grey,
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Delete',
                                textAlign: TextAlign.center,
                                style: wtTitle(15, 1, theme.dred4, true, false),
                              ),
                            ),
                            15,
                            delete!,
                            -1,
                            cp: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20)),
                      ],
                    )

                    //
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget mdYourFriend(
  BuildContext context,
  Friend user, {
  void Function()? message,
  void Function()? profile,
  void Function()? profile2,
  void Function()? retrieve,
}) {
  int mutual = mutualCount(connectedUser, user.friend);
  Widget child = Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [imageTemplate(user.friend.profile.img)],
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        "You're Friends Since ${user.date}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: wtTitle(15, 1, theme.dred3, false, false),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          height: 3,
          color: const Color.fromARGB(255, 189, 189, 189),
          width: scrW(context),
        ),
      ),
      InkWell(
        onTap: profile,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.person,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Text(
                    " Profil",
                    style: wtTitle(18, 1, theme.dred3, true, false),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: message,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.chat_outlined,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Text(
                    " Message",
                    style: wtTitle(18, 1, theme.dred3, true, false),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))),
            ],
          ),
        ),
      ),

      /* InkWell(
        onTap: block,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.block_outlined,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Text(
                    " Block",
                    style: wtTitle(18, 1, theme.dred3, true, false),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))),
            ],
          ),
        ),
      ),
       */
      InkWell(
        onTap: retrieve,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.person_remove_outlined,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Text(
                    " Unfriend",
                    style: wtTitle(18, 1, theme.dred3, true, false),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))),
            ],
          ),
        ),
      ),
    ],
  );
  return Stack(
    alignment: Alignment.topRight,
    children: [
      InkWell(
        onTap: profile2,
        onLongPress: () {
          customBottomSheetBuildContext(
              context, 0.4, SingleChildScrollView(child: child));
        },
        child: Card(
          elevation: 3,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors
                    .white), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 0, child: 
                    CircleAvatar(radius: 30, backgroundColor: theme.dred22, child: imageTemplate(user.friend.profile.img)),

                    ),
                //
                //
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 25),
                            child: Row(
                              children: [
                                Text(
                                  '${user.friend.profile.name}${user.friend.profile.pseudo.isEmpty ? '' : " (${user.friend.profile.pseudo})"}',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      wtTitle(16, 1, theme.dred3, true, false),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        // Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.group_outlined, //timer_outlined
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  "$mutual mutual Friend(s)",
                                  style:
                                      wtTitle(14, 1, theme.dred3, true, false),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //

                        //
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
          right: 10,
          child: customIcon(
              Colors.white, theme.dred3, Icons.settings_suggest_outlined, () {
            customBottomSheetBuildContext(
                context, 0.4, SingleChildScrollView(child: child));
          }, rd: 15, sz: 20)),
    ],
  );
}

Widget mdYourFriendToChat(
  BuildContext context,
  Friend user, {
  void Function()? message,
}) {
  int mutual = mutualCount(connectedUser, user.friend);
  return Stack(
    alignment: Alignment.topRight,
    children: [
      InkWell(
        onTap: message,
        child: Card(
          elevation: 3,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors
                    .white), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 0, child: 
                    CircleAvatar(radius: 30, backgroundColor: theme.dred22, child: imageTemplate(user.friend.profile.img), ),

                    ),
                //
                //
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 25),
                            child: Row(
                              children: [
                                Text(
                                  '${user.friend.profile.name}${user.friend.profile.pseudo.isEmpty ? '' : " (${user.friend.profile.pseudo})"}',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      wtTitle(16, 1, theme.dred3, true, false),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        // Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.group_outlined, //timer_outlined
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  "$mutual mutual Friend(s)",
                                  style:
                                      wtTitle(14, 1, theme.dred3, true, false),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //

                        //
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
          right: 10,
          child: customIcon(
              Colors.white, theme.dred3, Bootstrap.messenger, message!,
              rd: 15, sz: 20)),
    ],
  );
}

Widget mdFriendAddable(BuildContext context, User user, bool requested,
    {void Function()? add,
    void Function()? cancel,
    void Function()? profile,
    void Function()? profile2}) {
  int mutual = mutualCount(connectedUser, user);
  // bool requested = false;
  return InkWell(
    onTap: profile2,
    child: Card(
      elevation: 3,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors
                .white), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 0, child: 
                // Container(
                //     height: 65,
                //     width: 65,
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.grey,
                //         image: DecorationImage(
                //             fit: BoxFit.cover,
                //             image: NetworkImage(
                //                 '${user.profile.img}'))),
                //   )

                CircleAvatar(radius: 30, backgroundColor: theme.dred22, child: imageTemplate(user.profile.img) ),
                ),
            //
            //
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Row(
                          children: [
                            Text(
                              '${user.profile.name}${user.profile.pseudo.isEmpty ? '' : " (${user.profile.pseudo})"}',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: wtTitle(16, 1, theme.dred3, true, false),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    // Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              requested
                                  ? Icons.timer_outlined
                                  : Icons.group_outlined, //
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                                child: Text(
                              requested
                                  ? "Friend Request Sent"
                                  : "$mutual mutual Friend(s)",
                              style: wtTitle(14, 1, theme.dred3, true, false),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !requested
                            ? customButton(
                                theme.dred1,
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    'Add Friend',
                                    textAlign: TextAlign.center,
                                    style: wtTitle(
                                        15, 1, theme.dred4, true, false),
                                  ),
                                ),
                                15,
                                add!,
                                -1,
                                cp: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20))
                            : customButton(
                                Colors.grey,
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    'Cancel Request',
                                    textAlign: TextAlign.center,
                                    style: wtTitle(
                                        15, 1, theme.dred4, true, false),
                                  ),
                                ),
                                15,
                                cancel!,
                                -1,
                                cp: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20)),
                      ],
                    )

                    //
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget mdChat(BuildContext context, Chat chat, bool checked, bool byMe,
    void Function() longP, void Function() onTap) {
  Widget secondRow = SizedBox(), message = SizedBox();

  if (chat.lastMsg.type == '0') {
    message = Text(
      chat.lastMsg.content,
      style: wtTitle(16, 1, theme.dred3, true, false),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  } else if (chat.lastMsg.type == '1') {
    message = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 0,
          child: Icon(
            Icons.camera_alt_outlined,
            color: Colors.black,
            size: 15,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Photo",
            style: wtTitle(16, 1, theme.dred3, true, false),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  } else if (chat.lastMsg.type == '2') {
    message = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 0,
          child: Icon(
            Icons.keyboard_voice_outlined,
            color: Colors.black,
            size: 15,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Audio (${chat.lastMsg.length})",
            style: wtTitle(16, 1, theme.dred3, true, false),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  } else if (chat.lastMsg.type == '3') {
    message = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 0,
          child: Icon(
            Icons.videocam_outlined,
            color: Colors.black,
            size: 15,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Video",
            style: wtTitle(16, 1, theme.dred3, true, false),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  } else if (chat.lastMsg.type == '4') {
    message = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 0,
          child: Icon(
            Icons.file_present_outlined,
            color: Colors.black,
            size: 15,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Text(
            chat.lastMsg.name,
            style: wtTitle(16, 1, theme.dred3, true, false),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  } else {
    message = Text(
      " - - - ",
      style: wtTitle(16, 1, theme.dred3, true, false),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  //
  if (chat.isTyping) {
    message = Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            chat.isTypingTxt,
            style: wtTitle(16, 1, theme.dred1, true, false),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 8),
            child: LoadingJumpingLine.circle(
              backgroundColor: theme.dred1,
              size: 15,
            ))
      ],
    );
  }

  //

  if (byMe) {
    Widget iconState = SizedBox();
    if (chat.lastMsg.readState == '0') {
      iconState = Icon(
        Icons.access_time_outlined,
        color: Colors.black,
        size: 15,
      );
    } else if (chat.lastMsg.readState == '1') {
      iconState = Icon(
        Icons.check,
        color: Colors.black,
        size: 15,
      );
    } else if (chat.lastMsg.readState == '2') {
      iconState = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 15,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (chat.lastMsg.readState == '3') {
      iconState = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  child: Icon(
                    Icons.check,
                    color: theme.dred1,
                    size: 15,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Icon(
                    Icons.check,
                    color: theme.dred1,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    secondRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: iconState,
          ),
        ),
        Expanded(flex: 1, child: message),
      ],
    );
  } else {
    secondRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: message),
        chat.lastMsg.readState == '4' || chat.unread == "0"
            ? SizedBox()
            : Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 1),
                  child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: InkWell(
                          onTap: () {
                            //
                          },
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: theme.dred2,
                            child: Text(
                              int.parse(chat.unread) > 9 ? "9+" : chat.unread,
                              style: wtTitle(13, 1, Colors.white, true, false),
                            ),
                          ))),
                ),
              ),
      ],
    );
  }

  //

  // if (chat.isTyping) {
  //   secondRow = Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Expanded(
  //           flex: 1,
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.only(left: 8),
  //                 child: Text(
  //                   chat.isTypingTxt,
  //                   style: wtTitle(16, 1, theme.dred1, true, false),
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               Padding(
  //                   padding: EdgeInsets.only(left: 8),
  //                   child: LoadingJumpingLine.circle(
  //                     backgroundColor: theme.dred1,
  //                     size: 15,
  //                   ))
  //             ],
  //           )),
  //     ],
  //   );
  // }

  return InkWell(
    onTap: onTap,
    onLongPress: longP,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: !checked
              ? Colors.transparent
              : theme
                  .dred22), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Positioned(
                    child: InkWell(
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                                color: chat.users.isEmpty ||
                                        (chat.users.isNotEmpty &&
                                            chat.users[0].stories.isNotEmpty)
                                    ? theme.dred1
                                    : Colors.grey,
                                width: 3)),
                        padding: EdgeInsets.all(2),
                        child: chat.img.isEmpty
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                // padding: EdgeInsets.all(80),
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ))
                            : Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage('${chat.img}'))),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white)),
                          padding: EdgeInsets.all(1.8),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: chat.users[0].online
                                    ? Color(0xffEE5366)
                                    : Colors.grey),
                          ),
                        ),
                      )),
                  !checked
                      ? SizedBox()
                      : Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.dred1,
                                  border: Border.all(color: Colors.white)),
                              padding: EdgeInsets.all(1),
                              child: const Icon(
                                Icons.check_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ))
                ],
              )

              // CircleAvatar(radius: 30, child: dom.img.isEmpty ?
              // Text(user.nom[0], style: wtTitle(40, 1, Colors.white, true, false), textAlign: TextAlign.center,) : Image.network('${dom.img}') ),

              ),
          //
          //
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0, left: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Text(
                            '${chat.name} ',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: wtTitle(18, 1, Colors.black, true, false),
                          ))),
                      Expanded(
                        flex: 0,
                        child: Container(
                            child: Text(
                          chatTime(context, DateTime.parse(chat.lastMsg.date)),
                          style: wtTitle(13, 1, theme.dred3, true, false),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Row

                  secondRow
                  //
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget imageTemplate(String url) {
  return url.isEmpty
      ? Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.dred22,
          ),
          // padding: EdgeInsets.all(80),
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ))
      : ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                8.0), // Pour des coins arrondis (facultatif)
            child: Image.network(
              url,
              width: 65.0,
              height: 65.0,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  // Si l'image est complètement chargée, on l'affiche directement
                  return child;
                }
                // Pendant le chargement, on affiche un indicateur de chargement
                return Center(
                    child: FourRotatingDots(color: Colors.black, size: 20)
                    // CircularProgressIndicator(
                    //   value: loadingProgress.expectedTotalBytes != null
                    //       ? loadingProgress.cumulativeBytesLoaded /
                    //           (loadingProgress.expectedTotalBytes ?? 1)
                    //       : null,
                    // ),
                    );
              },
              errorBuilder: (context, error, stackTrace) {
                // Si l'image ne peut pas être chargée, afficher l'image par défaut depuis le backend
                return Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.dred22,
                    ),
                    // padding: EdgeInsets.all(80),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ));
              },
            ),
          ));
}
