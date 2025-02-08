import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_chat/auth_service.dart';
import 'package:sweet_chat/pages/about.dart';
import 'package:sweet_chat/pages/chat.dart';
import 'package:sweet_chat/pages/friends.dart';
import 'package:sweet_chat/pages/notifs.dart';
import 'package:sweet_chat/pages/profil.dart';
import 'package:sweet_chat/pages/rateus.dart';
import 'package:sweet_chat/pages/sign.dart';
import 'package:sweet_chat/utils/bnb/convex_bottom_bar-master/convex_bottom_bar.dart';
// import 'package:sweet_chat/utils/bnb/animated_notch_bottom_bar/src/models/bottom_bar_item_model.dart';
// import 'package:sweet_chat/utils/bnb/animated_notch_bottom_bar/src/notch_bottom_bar.dart';
// import 'package:sweet_chat/utils/bnb/animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
// import 'package:sweet_chat/utils/bnb/flutter_floating_bottom_bar/src/bottom_bar.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/loading/src2/four_rotating_dots/four_rotating_dots.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:sweet_chat/notification_service.dart';
import '../theme.dart';
import '../utils/decoration.dart';

class ManuPage extends StatefulWidget {
  const ManuPage({Key? key}) : super(key: key);

  @override
  _ManuPageState createState() => _ManuPageState();
}

class _ManuPageState extends State<ManuPage>
    with SingleTickerProviderStateMixin {
  TextStyle boldTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);

  List<SampleListModel> sideMenu = [], bottomMenu = [];

  Widget menuTrigger = SizedBox();

  load() async {
    await chargementUser();

    await NotificationService().initNotifications(context);
      await saveDeviceToken(connectedUser.profile.id);

    // if (connectedUser.profile.id.isNotEmpty) {
    //   print("Sending Notif");
    //   String token = await getUserToken(connectedUser.profile.id);
    //   envoiNotifnew(token, "Hello Guy", "You're Successfull Connected !");
    // }
  }

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double angle = 0;
  bool d1Open = false;

  late int isSelected = -1;

  bool loading = false;
  // final NotchBottomBarController _controller =
  //     NotchBottomBarController(index: 1);
  int currentPage = 1;
  Widget currentPageWidget = const SizedBox();

  closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      angle = 0;
      scaleFactor = 1;
      d1Open = false;
    });
  }

  openDrawer() {
    setState(() {
      xOffset = 200;
      yOffset = 80;
      scaleFactor = 0.8;
      angle = 6.18;
      d1Open = true;
    });

    // setStatusBarColor(context.watch<AppTheme>().themeclass.dred1);
    setState(() {});
  }

  final streamController = StreamController<int>();

  @override
  void initState() {
    super.initState();
    print("Ok init");

    streamController.stream.listen((event) {
      print(event);
      print(d1Open);
      setState(() {});
    });

    menuTrigger = IconButton(
      icon: Icon(d1Open ? Icons.arrow_back : Icons.menu, size: 24),
      onPressed: () {
        if (d1Open) {
          closeDrawer();
        } else {
          setState(() {
            xOffset = 200;
            yOffset = 80;
            scaleFactor = 0.8;
            angle = 6.18;
            d1Open = true;
            streamController.add(1);
          });

          // setStatusBarColor(context.watch<AppTheme>().themeclass.dred1);
        }
      },
    );

    sideMenu.add(
      SampleListModel(
        title: "Profil",
        icon: Icons.person_outlined,
        launchWidget: UserProfil(),
      ),
    );
    // sideMenu.add(
    //   SampleListModel(
    //     title: "Feeds",
    //     icon: Icons.card_giftcard,
    //     launchWidget: UserProfil(),
    //   ),
    // );
    // sideMenu.add(
    //   SampleListModel(
    //     title: "Help",
    //     icon: Icons.help_outline_outlined,
    //     launchWidget: UserProfil(),
    //   ),
    // );
    sideMenu.add(
      SampleListModel(
        title: "About Us",
        icon: Icons.info_outline,
        launchWidget: AboutPage(),
      ),
    );
    sideMenu.add(
      SampleListModel(
        title: "Rate Us",
        icon: Icons.star_border,
        launchWidget: RateUs(),
      ),
    );

//
    bottomMenu.add(
      SampleListModel(
        title: "Friends",
        icon: Icons.groups_outlined,
        count: 1,
        launchWidget: FriendsPage(
          menu: menuTrigger,
        ),
      ),
    );
    bottomMenu.add(
      SampleListModel(
        title: "Chat",
        icon: Icons.chat_outlined,
        count: 15,
        launchWidget: ChatPage(
          menu: menuTrigger,
        ),
      ),
    );
    bottomMenu.add(
      SampleListModel(
        title: "Notifications",
        icon: Icons.notifications_none,
        count: 3,
        launchWidget: NotifsPage(
          menu: menuTrigger,
        ),
      ),
    );

    currentPageWidget = ChatPage(
      menu: menuTrigger,
    );

    print(connectedUser.profile.toJson());
    load();
    setState(() {
      print("Ok");
    });
  }

  @override
  void dispose() {
    // customDiag(context, confirmDeconnexion());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWrapper(
        child: Container(
      color: context.watch<AppTheme>().themeclass.top,
      child: SafeArea(
        top: true,
        child: StreamBuilder(
          stream: _getNotifs(),
          builder: (context, snapshot) {
            List<int> lstNotifs = [0, 0, 0];
            if (snapshot.hasData) {
              lstNotifs = snapshot.data!;
            }

            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    color: context.watch<AppTheme>().themeclass.dred1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    context.read<AppTheme>().toogle();
                                  });
                                  final pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString(
                                      "theme", isDarkTheme ? '1' : '0');
                                  // showsnack(context, "Soon Available !");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Text(
                                        '${isDarkTheme ? 'Dark' : 'Light'} Mode',
                                        style: wtTitle(
                                            15, 1, Colors.white, true, false),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    //
                                    Switch(
                                      // mouseCursor: SystemMouseCursors.move,

                                      thumbIcon: WidgetStateProperty
                                          .resolveWith((states) => Icon(
                                                !isDarkTheme
                                                    ? Icons
                                                        .brightness_4_outlined
                                                    : Icons.dark_mode_outlined,
                                                color: context
                                                    .watch<AppTheme>()
                                                    .themeclass
                                                    .dred4,
                                                size: 18,
                                              )),
                                      activeColor:
                                          Color.fromARGB(255, 30, 19, 19),
                                      inactiveThumbColor:
                                          Color.fromARGB(255, 255, 101, 101),
                                      value: isDarkTheme,
                                      onChanged: (value) async {
                                        setState(() {
                                          context.read<AppTheme>().toogle();
                                        });
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        pref.setString(
                                            "theme", isDarkTheme ? '1' : '0');
                                        // showsnack(context, "Soon Available !");
                                      },
                                    ),
                                    //
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            closeDrawer();
                            ouvrirO(context, UserProfil());
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              children: [
                                // Icon(Icons.account_circle,
                                //     color: Colors.white, size: 70),
                                Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                connectedUser.stories.isNotEmpty
                                                    ? Colors.green
                                                    : Colors.white,
                                            width: 3)),
                                    padding: EdgeInsets.all(2),
                                    child: connectedUser.profile.img.isEmpty
                                        ? Container(
                                            height: 80,
                                            width: 80,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            // padding: EdgeInsets.all(80),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  connectedUser.profile.name
                                                              .split(' ')
                                                              .length >
                                                          2
                                                      ? connectedUser
                                                          .profile.name
                                                          .split(' ')[0][0]
                                                      : connectedUser
                                                          .profile.name
                                                          .substring(0, 1),
                                                  style: wtTitle(
                                                      30,
                                                      1,
                                                      context
                                                          .watch<AppTheme>()
                                                          .themeclass
                                                          .dred1,
                                                      true,
                                                      false),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  connectedUser.profile.name
                                                              .split(' ')
                                                              .length >
                                                          2
                                                      ? connectedUser
                                                          .profile.name
                                                          .split(' ')[1][0]
                                                      : connectedUser
                                                          .profile.name
                                                          .substring(1, 2),
                                                  style: wtTitle(
                                                      55,
                                                      1,
                                                      context
                                                          .watch<AppTheme>()
                                                          .themeclass
                                                          .dred1,
                                                      true,
                                                      false),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )
                                            // Icon(
                                            //   Icons.person,
                                            //   size: 70,
                                            //   color: Colors.grey,
                                            // )
                                            )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Pour des coins arrondis (facultatif)
                                              child: Image.network(
                                                connectedUser.profile.img,
                                                width: 65.0,
                                                height: 65.0,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    // Si l'image est complètement chargée, on l'affiche directement
                                                    return child;
                                                  }
                                                  // Pendant le chargement, on affiche un indicateur de chargement
                                                  return Center(
                                                      child: FourRotatingDots(
                                                          color: Colors.black,
                                                          size: 20)
                                                      // CircularProgressIndicator(
                                                      //   value: loadingProgress.expectedTotalBytes != null
                                                      //       ? loadingProgress.cumulativeBytesLoaded /
                                                      //           (loadingProgress.expectedTotalBytes ?? 1)
                                                      //       : null,
                                                      // ),
                                                      );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
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
                                            ))

                                    // Container(
                                    //     height: 80,
                                    //     width: 80,
                                    //     decoration: BoxDecoration(
                                    //         shape: BoxShape.circle,
                                    //         color: Colors.white,
                                    //         image: DecorationImage(
                                    //             fit: BoxFit.cover,
                                    //             image: NetworkImage(
                                    //                 '$urlserveur/${connectedUser.profile.img}'))),
                                    //   ),
                                    ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Text(connectedUser.profile.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            ...List.generate(
                              sideMenu.length,
                              (index) {
                                SampleListModel data = sideMenu[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      tileColor: isSelected == index
                                          ? Color(0xFF513AAF)
                                          : Colors.transparent,
                                      title: Text(
                                        data.title ?? "",
                                        style: TextStyle(
                                          color: isSelected == index
                                              ? Colors.white
                                              : Colors.white54,
                                        ),
                                      ),
                                      leading: Icon(
                                        data.icon,
                                        color: isSelected == index
                                            ? Colors.white
                                            : Colors.white54,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isSelected = index;
                                          closeDrawer();
                                          ouvrirO(context,
                                              sideMenu[index].launchWidget);
                                        });

                                        // setState(() {
                                        //   currentPageWidget =
                                        //        ?? Container();
                                        // });
                                      },
                                    ),
                                    index != sideMenu.length - 1
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                        vertical: 8),
                                                child: Container(
                                                  height: 1,
                                                  color: const Color.fromARGB(
                                                      255, 189, 189, 189),
                                                  width: 70,
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: isDarkTheme
                                ? const Color.fromARGB(234, 255, 255, 255)
                                : Color.fromARGB(255, 255, 163, 163),
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.logout_outlined,
                                color: !isDarkTheme
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 0, 0),
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                customDiag(context, confirmDeconnexion());
                              },
                              label: Text('Log Out',
                                  style: wtTitle(
                                      18,
                                      1.5,
                                      !isDarkTheme
                                          ? Colors.white
                                          : Color.fromARGB(255, 0, 0, 0),
                                      true,
                                      false)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      closeDrawer();
                      setState(() {});
                    },
                    onPanUpdate: (d) {
                      closeDrawer();
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: d1Open
                            ? BorderRadius.circular(16)
                            : BorderRadius.circular(0),
                      ),
                      transform: Matrix4.translationValues(xOffset, yOffset, 0)
                        ..scale(scaleFactor)
                        ..rotateZ(angle),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Row(
                          //   children: [
                          //     IconButton(
                          //       icon: Icon(d1Open ? Icons.arrow_back : Icons.menu,
                          //           size: 24),
                          //       onPressed: () {
                          //         if (d1Open) {
                          //           closeDrawer();
                          //         } else {
                          //           xOffset = 200;
                          //           yOffset = 80;
                          //           scaleFactor = 0.8;
                          //           angle = 6.18;
                          //           d1Open = true;
                          //           setStatusBarColor(context.watch<AppTheme>().themeclass.dred1);
                          //         }
                          //         setState(() {});
                          //       },
                          //     ),
                          //     SizedBox(width: 8),
                          //     Text('Sweet Chat',
                          //         style: TextStyle(
                          //             fontSize: 20, fontWeight: FontWeight.bold)),
                          //   ],
                          // ),
                          Expanded(
                              child: Scaffold(
                                  bottomNavigationBar: wbottom(lstNotifs),
                                  // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                                  // floatingActionButton:  Container(
                                  //   margin: EdgeInsets.symmetric(horizontal: 15),
                                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(200), color: Colors.red),
                                  //   child: wbottom()) ,
                                  body: currentPageWidget)

                              // Container(
                              //   alignment: Alignment.center,
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       sideMenu[isSelected].launchWidget??Container(),

                              //     ],
                              //   )
                              // )
                              ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

  /*  badges.Badge(
          position: badges.BadgePosition.topEnd(top: -10, end: -12),
          showBadge: true,
          ignorePointer: false,
          onTap: () {},
          badgeContent: const Icon(Icons.my_location_outlined,
              color: Colors.white, size: 30),
          badgeAnimation: const badges.BadgeAnimation.rotation(
            animationDuration: Duration(seconds: 1),
            colorChangeAnimationDuration: Duration(seconds: 1),
            loopAnimation: true,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          badgeStyle: const badges.BadgeStyle(
            shape: badges.BadgeShape.circle,
            badgeColor: Color.fromARGB(255, 255, 0, 0),
            padding: EdgeInsets.all(5),
            // borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.white, width: 2),
            elevation: 3,
          ),
          child: customButton(context.watch<AppTheme>().themeclass.dred1, const Text('Map Test'), 15, () {
            ouvrirO(context, MapTest());
            // I18n.of(context).locale = (I18n.localeStr == "fr_fr")
            //     ? const Locale("en", "US")
            //     : const Locale("fr", "FR");
          }, 15),
        ), */

  Widget wbottom1() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        // color: context.watch<AppTheme>().isDark
        //       ? fondDark2
        //       : context.watch<AppTheme>().themeclass.dred22,
      ),
      child: BottomNavigationBar(
        currentIndex: currentPage,
        selectedItemColor: Colors.white,
        backgroundColor: context.watch<AppTheme>().isDark
            ? fondDark2
            : context.watch<AppTheme>().themeclass.dred22,
        items: bottomMenu
            .map(
              (e) => BottomNavigationBarItem(
                  icon: StreamBuilder(
                    stream: _getNotifs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        e.count = snapshot.data![bottomMenu.indexOf(e)];

                        return e.count == 0
                            ? Icon(e.icon)
                            : customBadge(
                                Icon(e.icon),
                                Text(
                                  e.count! > 9 ? "9+" : e.count.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ));
                      }

                      return Icon(e.icon);
                    },
                  ),
                  label: e.title),
            )
            .toList(),
        onTap: (value) {
          setState(() {
            currentPage = value;
            currentPageWidget = bottomMenu[value].launchWidget ?? Container();
          });
        },
      ),
    );
  }

  Stream<List<int>> _getNotifs() async* {
    final userSnap = await FirebaseFirestore.instance
        .collection('user')
        .doc(connectedUser.profile.id)
        .get();

    List<int> results = [];
    // if (index == 0) {
    // Friends
    int val = 0;
    final tmpcorRefs = userSnap.data()!['friends'] ?? [];
    print("nb refs : ${tmpcorRefs.length}");

    for (var ref in tmpcorRefs) {
      await FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        if (doc.data()!['requesting']) {
          val++;
        }
      });
    }
    results.add(val);
    // } else if (index == 1) {
    // Chats
    val = 0;
    final tmpcorRefs2 = userSnap.data()!['chats'] ?? [];
    print("nb refs : ${tmpcorRefs2.length}");

    for (var ref in tmpcorRefs2) {
      await FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        if (!doc.data()!['archived'] && doc.data()!['unread'] != "0") {
          val++;
        }
      });
    }
    results.add(val);
    // } else if (index == 2) {
    // Notifs
    val = 0;
    final tmpcorRefs3 = userSnap.data()!['notifs'] ?? [];
    print("nb refs : ${tmpcorRefs3.length}");

    for (var ref in tmpcorRefs3) {
      await FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        if (doc.data()!['readState'] == '0') {
          val++;
        }
      });
    }
    results.add(val);
    // }

//
    yield results;
  }

  Widget wbottom(List<int> lstNotifs) {
    return ConvexAppBar.badge(
      {
        0: lstNotifs[0] == 0
            ? SizedBox.shrink()
            : Container(
                height: 20,
                width: 20,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle, border : Border.all(color : Colors.white)),
                padding: EdgeInsets.all(1),
                child: Text(
                  lstNotifs[0] > 9 ? "9+" : lstNotifs[0].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
        1: lstNotifs[1] == 0
            ? SizedBox.shrink()
            : Container(
                height: 20,
                width: 20,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle,  border : Border.all(color : Colors.white)),
                padding: EdgeInsets.all(1),
                child: Text(
                  lstNotifs[1] > 9 ? "9+" : lstNotifs[1].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
        2: lstNotifs[2] == 0
            ? SizedBox.shrink()
            : Container(
                height: 
                20,
                width: 20,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle, border : Border.all(color : Colors.white)),
                padding: EdgeInsets.all(1),
                child: Text(
                  lstNotifs[2] > 9 ? "9+" : lstNotifs[2].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
      },
      badgeMargin: EdgeInsets.only(left: 30, bottom: 30),
      initialActiveIndex: currentPage,
      activeColor: Colors.white,
      // curve: ,
      backgroundColor: context.watch<AppTheme>().isDark
          ? fondDark2
          : context.watch<AppTheme>().themeclass.dred1,
      items: bottomMenu
          .map((e) => TabItem(
                icon: e.icon,
                title: e.title,
              ))
          .toList(),
      onTap: (int i) {
        setState(() {
          currentPage = i;
          currentPageWidget = bottomMenu[i].launchWidget ?? Container();
        });
      },
    );
  }

  /* 

  late TabController tabController =
      TabController(length: 3, vsync: this, initialIndex: 1);
  Widget wbottom3() {
    return BottomBar(
      clip: Clip.none,
      fit: StackFit.expand,
      icon: (width, height) => Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: null,
          icon: Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
            size: width,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(500),
      duration: Duration(milliseconds: 500),
      curve: Curves.decelerate,
      showIcon: true,
      width: MediaQuery.of(context).size.width * 0.8,
      barColor: context.watch<AppTheme>().isDark
          ? fondDark2
          : context.watch<AppTheme>().themeclass.dred22,
      start: 3,
      end: 0,
      offset: 5,
      barAlignment: Alignment.bottomCenter,
      iconHeight: 30,
      iconWidth: 30,
      reverse: true,
      barDecoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(500),
      ),
      iconDecoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(500),
      ),
      hideOnScroll: true,
      scrollOpposite: false,
      onBottomBarHidden: () {},
      onBottomBarShown: () {},
      body: (context, controller) => TabBarView(
        controller: tabController,
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        children: bottomMenu
            .map(
              (e) => Center(child: Text('Ok')),
            )
            .toList(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBar(
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          controller: tabController,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color:
                    // currentPage <= 4 ? colors[currentPage] : unselectedColor,
                    Colors.white,
                width: 4,
              ),
              insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
          tabs: bottomMenu
              .map(
                (e) => SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customBadge(
                          Icon(e.icon),
                          Text(
                            '9+',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      SizedBox(
                        height: 5,
                      ),

                      // Text(e.title??"")
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
 */

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
                        color: context.watch<AppTheme>().themeclass.dred1,
                      )),
                  child: Icon(
                    Icons.close,
                    color: context.watch<AppTheme>().themeclass.dred1,
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
              'Log Out',
              style: wtTitle(20, 1, Colors.black, true, false),
            ),
          ),
          //
          //
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: context.watch<AppTheme>().themeclass.dred2,
                    width: 15)),
            child: Icon(
              Icons.info_outline_rounded,
              color: context.watch<AppTheme>().themeclass.dred1,
              size: 200,
            ),
          ),
          //
          // Textes
          //
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Are you sure you want to logout !?',
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
                  context.watch<AppTheme>().themeclass.dred1,
                  Text(
                    'Log Out',
                    style: wtTitle(
                        18,
                        1,
                        context.watch<AppTheme>().themeclass.dred4,
                        true,
                        false),
                  ),
                  15, () async {
                // Relancer lAPI

                final AuthService authService = AuthService();
                await authService.logout(context);
                fermer(context);
                ouvrirR(context, Sign());
              }, -1, cp: EdgeInsets.symmetric(horizontal: 30, vertical: 10))
            ],
          )
        ],
      );
    });
  }
}

class SampleListModel {
  Widget? leading;
  String? title;
  String? subTitle;
  int? count;
  Widget? trailing;
  IconData? icon;
  IconData? alternateIcon;
  Function? onTap;
  Color? colors;
  Widget? launchWidget;

  SampleListModel(
      {this.leading,
      this.title,
      this.subTitle,
      this.colors,
      this.icon,
      this.alternateIcon,
      this.trailing,
      this.count,
      this.onTap,
      this.launchWidget});
}
