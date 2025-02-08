import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/pages/chatchooseuser.dart';
import 'package:sweet_chat/pages/chat0archived.dart';
import 'package:sweet_chat/pages/profil.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import 'package:sweet_chat/utils/loading/src2/four_rotating_dots/four_rotating_dots.dart';
// import 'package:sweet_chat/utils/fab/src/action_button_builder.dart';
import 'package:sweet_chat/utils/shimer.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import '../utils/loading/loading_overlay_pro.dart'; // import 'package:share_plus/share_plus.dart';
import 'package:sweet_chat/pages/chatcontent.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/decoration.dart';
// import 'package:sweet_chat/utils/fab/src/expandable_fab.dart';
import 'package:sweet_chat/utils/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.menu});
  final Widget menu;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// StreamController stc = StreamController();

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  String archived = "0";

  List<String> chatSelectionList = [];

  int filter = 0;

  bool loading = false, srchanim = false, hasFriends = false;
  TextEditingController searchctrl = TextEditingController();
  FirebaseFirestore fins = FirebaseFirestore.instance;

  ScrollController scCtrl = ScrollController(initialScrollOffset: 60);

  loadfriends() async {
    final chatDoc =
        await fins.collection('user').doc(connectedUser.profile.id).get();
    final friendsRefs = List<DocumentReference>.from(chatDoc.get('friends'));

    // ignore: unused_local_variable
    for (final ref in friendsRefs) {
      setState(() {
        hasFriends = true;
      });
      break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(connectedUser.profile.id.isNotEmpty){

    loadfriends();

    }
    // chargeement();

    setState(() {
      // archived = connectedUser.chats
      //     .where(
      //       (c) => c.archived == true,
      //     )
      //     .toList()
      //     .length
      //     .toString();

      // connectedUser.chats
      //     .where(
      //       (f) => f.archived == false,
      //     )
      //     .forEach(
      //       (element) => chatLst.add(element),
      //     );
    });
  }

  //

  // final _key = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      child: Scaffold(
        backgroundColor:
            /* context.watch<AppTheme>().isDark ? fondDark : */ Colors.white,

        /* floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        // duration: const Duration(milliseconds: 500),
        // distance: 200.0,
        // type: ExpandableFabType.up,
        // pos: ExpandableFabPos.left,
        // childrenOffset: const Offset(0, 20),
        // childrenAnimation: ExpandableFabAnimation.none,
        // fanAngle: 40,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          angle: 3.14 * 2,
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.close,
                size: 40,
                color: Colors.white,
              ),
            );
          },
        ),
        overlayStyle: ExpandableFabOverlayStyle(
          color: const Color.fromARGB(88, 0, 0, 0),
          blur: 5,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            child: const Icon(Icons.share),
            foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          backgroundColor: Colors.white,
            onPressed: () {
            },
          ),
          FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          backgroundColor: Colors.white,
            child: const Icon(Icons.group_add_outlined),
            onPressed: () {
            },
          ),
          FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          backgroundColor: Colors.white,
            child: const Icon(Icons.chat_outlined),
            onPressed: () {
              final state = _key.currentState;
              if (state != null) {
                debugPrint('isOpen:${state.isOpen}');
                state.toggle();
              }
              // Share.share(
              //       "Saluto.\n\n Cliquez sur le lien suivant pour vous s'inscrire\n.  \n\n Si vous avez reçu ce lien par erreur veuillez bien ne pas continuer");
             
            },
          ),
        ],
      ),
         */

        floatingActionButton: FloatingActionButton(
          foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () {
            ouvrirO(context, ChatChooseUser());
          },
        ),
        body: Stack(
          children: [
            Positioned(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      SizedBox(
                        height: srchanim ? 120 : 65,
                      ),
                    //  !hasFriends ? SizedBox() : _storyBoard([
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png",
                    //     "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png"
                    //   ]),

                      StreamBuilder<List<Friend>>(
                            stream: _getFriendsInfoStream(),
                            builder: (snContext, friendsSnapshot) {
                              if (friendsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox();// customShimmer();
                              }

                              if (!friendsSnapshot.hasData ||
                                  friendsSnapshot.data!.isEmpty) {
                                return SizedBox();
                              }

                              if (friendsSnapshot.hasError) {
                                return SizedBox(
                                );
                              }

                              final notifs = friendsSnapshot.data!;

                              return _storyBoard(notifs);
                            }),


                      Expanded(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: fins
                                .collection('user')
                                .doc(connectedUser.profile.id)
                                .snapshots(),
                            // _getChats(),
                            builder: (context1, notifSnapshot) {
                              if (notifSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return customShimmer();
                              }

                              if (notifSnapshot.hasError) {
                                return SizedBox(
                                  height: scrH(context),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          BoxIcons.bx_error,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Loading Error ! ${notifSnapshot.error}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final chData = notifSnapshot.data!.data()
                                  as Map<String, dynamic>;
                              final chatLst =
                                  List<DocumentReference>.from(chData['chats']);

                              // loadArchived(chatLst);

                              return
                                  /*  srchanim &&
                                        searchctrl.text.isNotEmpty &&
                                        notifs
                                            .where((e) => e.content
                                                .toLowerCase()
                                                .contains(
                                                    searchctrl.text.toLowerCase()))
                                            .isEmpty
                                    ? SizedBox(
                                        height: scrH(context) - 220,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.question_mark_outlined,
                                                size: 50,
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "No Result !",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : */
                                  chatLst.isEmpty
                                      ?   Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 320,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight: Radius
                                                                .circular(
                                                                    55)),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'imgs/flogow.png'),
                                                        opacity: 0.8,
                                                        fit: BoxFit.cover)),
                                                // child: Image.asset('imgs/${pages[index]['img2']}', ),
                                              ),
                                              // Icon(
                                              //   Icons.query_stats_outlined,
                                              //   size: 50,
                                              // ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "Nothing to Show !",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        top: 25),
                                                child: hasFriends
                                                    ? customButton(
                                                        theme.dred2,
                                                        Text(
                                                          'Start a new Chat',
                                                          style: wtTitle(
                                                              16,
                                                              1,
                                                              theme.dred4,
                                                              true,
                                                              false),
                                                        ),
                                                        15, () {
                                                        //
                                                        ouvrirO(context,
                                                            ChatChooseUser());
                                                      }, -1,
                                                        cp: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    40,
                                                                vertical: 15))
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    20),
                                                        child: Text(
                                                          "Go To \"Friends --> People\" and Add New Friends to Start Chatting !",
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: wtTitle(
                                                              16,
                                                              1,
                                                              theme.dred1,
                                                              true,
                                                              false),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          // color: Colors.redAccent,
                                          child: SingleChildScrollView(
                                              controller: scCtrl,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  /*  Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10, left: 10),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(children: [
                                                    Tooltip(
                                                      message: "All Chats",
                                                      waitDuration:
                                                          Duration(microseconds: 200),
                                                      preferBelow: false,
                                                      child: customButton(
                                                          filter == 0
                                                              ? theme.dred22
                                                              : Color.fromRGBO(
                                                                  252, 252, 252, 0.72),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                "All",
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  child: Icon(
                                                                filter == 0
                                                                    ? Icons.close
                                                                    : Icons.add,
                                                                color: Colors.black,
                                                                size: 15,
                                                              )),
                                                            ],
                                                          ),
                                                          25, () {
                                                        //
                                                        setState(() {
                                                          filter = 0;
                                                        });
                                                      }, 7, opt: 2, bc: theme.dred1),
                                                    ),
                                                    //
                                                    SizedBox(width: 10),
                                                    Tooltip(
                                                      message: "Unread Chats",
                                                      waitDuration:
                                                          Duration(microseconds: 200),
                                                      preferBelow: false,
                                                      child: customButton(
                                                          filter == 1
                                                              ? theme.dred22
                                                              : Color.fromRGBO(
                                                                  252, 252, 252, 0.72),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                "Unread",
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  child: Icon(
                                                                filter == 1
                                                                    ? Icons.close
                                                                    : Icons.add,
                                                                color: Colors.black,
                                                                size: 15,
                                                              )),
                                                            ],
                                                          ),
                                                          25, () {
                                                        //
                                                        setState(() {
                                                          filter = 1;
                                                        });
                                                      }, 7, opt: 2, bc: theme.dred1),
                                                    ),
                                                    /*  SizedBox(width: 10),
                                                    Tooltip(
                                                      message: "Favorites Chats",
                                                      waitDuration:
                                                          Duration(microseconds: 200),
                                                      preferBelow: false,
                                                      child: customButton(
                                                          filter == 2
                                                              ? theme.dred22
                                                              : Color.fromRGBO(
                                                                  252, 252, 252, 0.72),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                "Favorites",
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  child: Icon(
                                                                filter == 2
                                                                    ? Icons.close
                                                                    : Icons.add,
                                                                color: Colors.black,
                                                                size: 15,
                                                              )),
                                                            ],
                                                          ),
                                                          25, () {
                                                        //
                                                        setState(() {
                                                          filter = 2;
                                                        });
                                                      }, 7, opt: 2, bc: theme.dred1),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Tooltip(
                                                      message: "All Group Chats",
                                                      waitDuration:
                                                          Duration(microseconds: 200),
                                                      preferBelow: false,
                                                      child: customButton(
                                                          filter == 3
                                                              ? theme.dred22
                                                              : Color.fromRGBO(
                                                                  252, 252, 252, 0.72),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                "Groups",
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  child: Icon(
                                                                filter == 3
                                                                    ? Icons.close
                                                                    : Icons.add,
                                                                color: Colors.black,
                                                                size: 15,
                                                              )),
                                                            ],
                                                          ),
                                                          25, () {
                                                        //
                                                        setState(() {
                                                          filter = 3;
                                                        });
                                                      }, 7, opt: 2, bc: theme.dred1),
                                                    ),
                                                   */
                                                  ]),
                                                ),
                                              ),
                                               */

                                                  StreamBuilder(
                                                    stream: _getArchived(),
                                                    builder:
                                                        (context, snapshot) {
                                                      int e = 0;
                                                      if (snapshot.hasData) {
                                                        e = snapshot.data!;
                                                      }

                                                      return InkWell(
                                                          onTap: () {
                                                            //
                                                            if (e == 0) {
                                                              showsnack(context,
                                                                  "No Archived Chat !");
                                                            } else {
                                                              ouvrirO(context,
                                                                  ArchivedChatPage());
                                                            }
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .transparent), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 0,
                                                                        child: Container(
                                                                            height: 50,
                                                                            width: 50,
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.transparent,
                                                                            ),
                                                                            // padding: EdgeInsets.all(80),
                                                                            child: Icon(
                                                                              Icons.archive_outlined,
                                                                              size: 30,
                                                                              color: Colors.black,
                                                                            ))

                                                                        // CircleAvatar(radius: 30, child: dom.img.isEmpty ?
                                                                        // Text(user.nom[0], style: wtTitle(40, 1, Colors.white, true, false), textAlign: TextAlign.center,) : Image.network('$urlserveur/${dom.img}') ),

                                                                        ),
                                                                    //
                                                                    //
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                                                                            child: Column(children: [
                                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                Expanded(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                        child: Text(
                                                                                      'Archived Chats',
                                                                                      style: wtTitle(16, 1, Colors.black, true, false),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ))),
                                                                                Expanded(
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
                                                                                                e > 9 ? "9+" : e.toString(),
                                                                                                style: wtTitle(13, 1, Colors.white, true, false),
                                                                                              ),
                                                                                            ))),
                                                                                  ),
                                                                                )
                                                                              ])
                                                                            ])))
                                                                  ])));
                                                    },
                                                  ),
                                                  ...chatLst.map(
                                                    (elem) {
                                                      return StreamBuilder(
                                                        stream:
                                                            elem.snapshots(),
                                                        builder: (context2,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            // return customShimmer();
                                                            return Container();
                                                          }

                                                          if (snapshot
                                                              .hasError) {
                                                            return SizedBox(
                                                              // height: scrH(context),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      BoxIcons
                                                                          .bx_error,
                                                                      size: 50,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Text(
                                                                      "Loading Error ! ${snapshot.error}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          if (snapshot.data!
                                                                  .data() ==
                                                              null) {
                                                            return Container();
                                                          }

                                                          final chatData =
                                                              snapshot.data!
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>;

                                                          // Filter
                                                          if (chatData[
                                                              "archived"]) {
                                                            // archived =
                                                            //     (int.parse(archived) + 1)
                                                            //         .toString();
                                                            // print("Archived : $archived");
                                                            return Container();
                                                          }
                                                          if (searchctrl.text
                                                                  .isNotEmpty &&
                                                              !chatData["name"]
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      searchctrl
                                                                          .text
                                                                          .toLowerCase())) {
                                                            return Container();
                                                          }
                                                          if (filter == 1 &&
                                                              (chatData[
                                                                      "unread"] ==
                                                                  "0")) {
                                                            return Container();
                                                          }

                                                          return FutureBuilder(
                                                            future: _getChat(
                                                                chatData),
                                                            builder: (context3,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                // return Container();
                                                                return customShimmerUk();
                                                              }

                                                              if (snapshot
                                                                  .hasError) {
                                                                return SizedBox(
                                                                  // height: scrH(context),
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                          BoxIcons
                                                                              .bx_error,
                                                                          size:
                                                                              50,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          "Loading Error ! ${snapshot.error}",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }

                                                              final e = snapshot
                                                                  .data!;

                                                              return mdChat(
                                                                  context,
                                                                  e,
                                                                  chatSelectionList
                                                                      .contains(
                                                                          e.id),
                                                                  e.lastMsg
                                                                          .userId ==
                                                                      connectedUser
                                                                          .profile
                                                                          .id,
                                                                  () {
                                                                setState(() {
                                                                  if (!chatSelectionList
                                                                      .contains(
                                                                          e.id)) {
                                                                    chatSelectionList
                                                                        .add(e
                                                                            .id);
                                                                  }
                                                                });
                                                              }, () {
                                                                setState(() {
                                                                  if (chatSelectionList
                                                                      .isNotEmpty) {
                                                                    if (chatSelectionList
                                                                        .contains(
                                                                            e.id)) {
                                                                      chatSelectionList
                                                                          .remove(
                                                                              e.id);
                                                                    } else {
                                                                      chatSelectionList
                                                                          .add(e
                                                                              .id);
                                                                    }
                                                                  } else {
                                                                    // ouvrir
                                                                    chatSelectionList
                                                                        .clear();
                                                                    // ouvrirO(context, ChatScreenTest());
                                                                    ouvrirO(
                                                                        context,
                                                                        ChatContent(
                                                                          chat:
                                                                              e,
                                                                        ));
                                                                  }
                                                                });
                                                              });
                                                            },
                                                          );
                                                        },
                                                      );

                                                      //
                                                    },
                                                  ),
                                                ],
                                              )),
                                        );
                            }),
                      ),
                    ],
                  )),
            ),

            /* chatLst.isEmpty
                ? SizedBox(
                    height: scrH(context),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.query_stats_outlined,
                            size: 50,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Nothing to Show",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    // color: Colors.redAccent,
                    child: SingleChildScrollView(
                        controller: scCtrl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  Tooltip(
                                    message: "All Chats",
                                    waitDuration: Duration(microseconds: 200),
                                    preferBelow: false,
                                    child: customButton(
                                        filter == 0
                                            ? theme.dred22
                                            : Color.fromRGBO(
                                                252, 252, 252, 0.72),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "All",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                                child: Icon(
                                              filter == 0
                                                  ? Icons.close
                                                  : Icons.add,
                                              color: Colors.black,
                                              size: 15,
                                            )),
                                          ],
                                        ),
                                        25, () {
                                      //
                                      setState(() {
                                        filter = 0;
                                      });
                                    }, 7, opt: 2, bc: theme.dred1),
                                  ),
                                  //
                                  SizedBox(width: 10),
                                  Tooltip(
                                    message: "Unread Chats",
                                    waitDuration: Duration(microseconds: 200),
                                    preferBelow: false,
                                    child: customButton(
                                        filter == 1
                                            ? theme.dred22
                                            : Color.fromRGBO(
                                                252, 252, 252, 0.72),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Unread",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                                child: Icon(
                                              filter == 1
                                                  ? Icons.close
                                                  : Icons.add,
                                              color: Colors.black,
                                              size: 15,
                                            )),
                                          ],
                                        ),
                                        25, () {
                                      //
                                      setState(() {
                                        filter = 1;
                                      });
                                    }, 7, opt: 2, bc: theme.dred1),
                                  ),
                                  SizedBox(width: 10),
                                  Tooltip(
                                    message: "Favorites Chats",
                                    waitDuration: Duration(microseconds: 200),
                                    preferBelow: false,
                                    child: customButton(
                                        filter == 2
                                            ? theme.dred22
                                            : Color.fromRGBO(
                                                252, 252, 252, 0.72),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Favorites",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                                child: Icon(
                                              filter == 2
                                                  ? Icons.close
                                                  : Icons.add,
                                              color: Colors.black,
                                              size: 15,
                                            )),
                                          ],
                                        ),
                                        25, () {
                                      //
                                      setState(() {
                                        filter = 2;
                                      });
                                    }, 7, opt: 2, bc: theme.dred1),
                                  ),
                                  SizedBox(width: 10),
                                  Tooltip(
                                    message: "All Group Chats",
                                    waitDuration: Duration(microseconds: 200),
                                    preferBelow: false,
                                    child: customButton(
                                        filter == 3
                                            ? theme.dred22
                                            : Color.fromRGBO(
                                                252, 252, 252, 0.72),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Groups",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                                child: Icon(
                                              filter == 3
                                                  ? Icons.close
                                                  : Icons.add,
                                              color: Colors.black,
                                              size: 15,
                                            )),
                                          ],
                                        ),
                                        25, () {
                                      //
                                      setState(() {
                                        filter = 3;
                                      });
                                    }, 7, opt: 2, bc: theme.dred1),
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                //
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors
                                        .transparent), //gradient: const LinearGradient(colors: [ Colors.transparent, theme.dred2, theme.dred2]) ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 0,
                                        child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                            ),
                                            // padding: EdgeInsets.all(80),
                                            child: Icon(
                                              Icons.archive_outlined,
                                              size: 30,
                                              color: Colors.black,
                                            ))

                                        // CircleAvatar(radius: 30, child: dom.img.isEmpty ?
                                        // Text(user.nom[0], style: wtTitle(40, 1, Colors.white, true, false), textAlign: TextAlign.center,) : Image.network('$urlserveur/${dom.img}') ),

                                        ),
                                    //
                                    //
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5.0, left: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        child: Text(
                                                      'Archived Chats',
                                                      style: wtTitle(
                                                          16,
                                                          1,
                                                          Colors.black,
                                                          true,
                                                          false),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))),
                                                Expanded(
                                                  flex: 0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 1),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: InkWell(
                                                            onTap: () {
                                                              //
                                                            },
                                                            child: CircleAvatar(
                                                              radius: 13,
                                                              backgroundColor:
                                                                  theme.dred2,
                                                              child: Text(
                                                                int.parse(archived) >
                                                                        9
                                                                    ? "9+"
                                                                    : archived,
                                                                style: wtTitle(
                                                                    13,
                                                                    1,
                                                                    Colors
                                                                        .white,
                                                                    true,
                                                                    false),
                                                              ),
                                                            ))),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ...chatLst.map(
                              (e) {
                                return mdChat(
                                    context,
                                    e,
                                    chatSelectionList.contains(e),
                                    e.lastMsg.userId ==
                                        connectedUser.profile.id, () {
                                  setState(() {
                                    if (!e.checked) {
                                      chatSelectionList.add(e);
                                    }
                                  });
                                }, () {
                                  setState(() {
                                    if (chatSelectionList.isNotEmpty) {
                                      if (chatSelectionList.contains(e)) {
                                        chatSelectionList.remove(e);
                                      } else {
                                        chatSelectionList.add(e);
                                      }
                                    } else {
                                      // ouvrir
                                      chatSelectionList.clear();
                                      // ouvrirO(context, ChatScreenTest());
                                      ouvrirO(
                                          context,
                                          ChatContent(
                                            chat: e,
                                          ));
                                    }
                                  });
                                });
                              },
                            ),
                          ],
                        )),
                  ), */

            //
            Positioned(
              child: Container(
                // color: Colors.white,
                color:
                    /* context.watch<AppTheme>().isDark ? fondDark2 : */ Colors.white,
                child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: chatSelectionList.isNotEmpty
                        ? Row(
                            children: [
                              Expanded(
                                  flex: 0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 3,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            //
                                            setState(() {
                                              chatSelectionList.clear();
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_back_outlined,
                                            size: 25,
                                          )),
                                      SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  " ${chatSelectionList.length}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                  flex: 0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            // archive selected
                                            for (var idC in chatSelectionList) {
                                              await fins
                                                  .collection("chat")
                                                  .doc(idC)
                                                  .update({'archived': true});
                                            }
                                            setState(() {
                                              chatSelectionList.clear();
                                            });
                                          },
                                          child: Icon(
                                            Icons.archive_outlined,
                                            size: 30,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            // delete Selected
                                            for (var idC in chatSelectionList) {
                                              final ref = await fins
                                                  .collection("chat")
                                                  .doc(idC)
                                                  .get();

                                              await fins
                                                  .collection("user")
                                                  .doc(connectedUser.profile.id)
                                                  .update({
                                                'chats': FieldValue.arrayRemove(
                                                    [ref.reference])
                                              });

                                              await fins
                                                  .collection("chat")
                                                  .doc(idC)
                                                  .delete();
                                            }

                                            setState(() {
                                              chatSelectionList.clear();
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete_forever_outlined,
                                            size: 30,
                                          )),
                                    ],
                                  )),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(flex: 0, child: widget.menu),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      " Chats",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 0,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                //
                                                setState(() {
                                                  srchanim = !srchanim;
                                                  searchctrl.text = '';
                                                });
                                              },
                                              child: Icon(
                                                srchanim
                                                    ? Icons.clear_outlined
                                                    : Icons.search_outlined,
                                                size: 30,
                                              )),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          // InkWell(
                                          //     onTap: () {
                                          //       //
                                          //     },
                                          //     child: Icon(
                                          //       Icons.settings,
                                          //       size: 30,
                                          //     )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          PopupMenuButton(
                                            child: Icon(
                                              Icons.filter_list_outlined,
                                              size: 30,
                                            ),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  child: Tooltip(
                                                    message: "All Chats",
                                                    waitDuration: Duration(
                                                        microseconds: 200),
                                                    preferBelow: false,
                                                    child: customButton(
                                                        filter == 0
                                                            ? theme.dred22
                                                            : Color.fromRGBO(
                                                                252,
                                                                252,
                                                                252,
                                                                0.72),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Row(
                                                            // mainAxisSize:
                                                            //     MainAxisSize.min,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  "All",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              // SizedBox(
                                                              //   width: 10,
                                                              // ),
                                                              Expanded(
                                                                flex: 0,
                                                                child: InkWell(
                                                                    child: Icon(
                                                                  filter == 0
                                                                      ? Icons
                                                                          .close
                                                                      : Icons
                                                                          .add,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        25, () {
                                                      //
                                                      setState(() {
                                                        filter = 0;
                                                      });
                                                      fermer(context);
                                                    }, 7,
                                                        opt: 2,
                                                        bc: theme.dred1),
                                                  ),
                                                ),
                                                //
                                                PopupMenuItem(
                                                  child: Tooltip(
                                                    message: "Unread Chats",
                                                    waitDuration: Duration(
                                                        microseconds: 200),
                                                    preferBelow: false,
                                                    child: customButton(
                                                        filter == 1
                                                            ? theme.dred22
                                                            : Color.fromRGBO(
                                                                252,
                                                                252,
                                                                252,
                                                                0.72),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Row(
                                                            // mainAxisSize:
                                                            //     MainAxisSize.min,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  "Unread",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              // SizedBox(
                                                              //   width: 10,
                                                              // ),
                                                              Expanded(
                                                                flex: 0,
                                                                child: InkWell(
                                                                    child: Icon(
                                                                  filter == 1
                                                                      ? Icons
                                                                          .close
                                                                      : Icons
                                                                          .add,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        25, () {
                                                      //
                                                      setState(() {
                                                        filter = 1;
                                                      });
                                                      fermer(context);
                                                    }, 7,
                                                        opt: 2,
                                                        bc: theme.dred1),
                                                  ),
                                                ),
                                              ];
                                            },
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              !srchanim
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                              controller: searchctrl,
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  // domaineslst.clear();
                                                  // domaineslst.addAll(domaineslstori.where((e) => e
                                                  //     .nom
                                                  //     .toLowerCase()
                                                  //     .contains(searchctrl.text.toLowerCase())));
                                                });
                                              },
                                              onTapOutside: (event) {
                                                // setState(() {
                                                //   srchanim = false;
                                                // });
                                              },
                                              decoration: mydecoration(
                                                  "",
                                                  18,
                                                  15,
                                                  true,
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      width: 60,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.search,
                                                            color: Colors.black,
                                                            size: 25,
                                                          ),
                                                          SizedBox(width: 5),
                                                          SizedBox(
                                                              height: 20,
                                                              child:
                                                                  VerticalDivider(
                                                                color:
                                                                    theme.dred1,
                                                              )),
                                                        ],
                                                      )),
                                                  false,
                                                  SizedBox(),
                                                  const BorderRadius.all(
                                                      Radius.circular(50)))),
                                        ),
                                        //
                                      ],
                                    )
                            ],
                          ),
                  ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storyBoard(List<Friend> storyImages) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80, // Hauteur fixe pour la section des stories
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(mainAxisAlignment : MainAxisAlignment.start,
                children: [
                  _buildAddStoryButton(),
                  const SizedBox(width: 10.0),
                  ...storyImages
                      .map((image) => _buildStoryImage(image)),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildAddStoryButton() {
    return InkWell(
      onTap: () {
        ouvrirO(context, UserProfil());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink, width: 2.0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: CircleAvatar(
                    radius: 25,
                    backgroundColor: theme.dred22,
                    child: imageTemplate(connectedUser.profile.img)),
              ),
               Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    // child: const Icon(
                    //   Icons.check,
                    //   color: Colors.white,
                    //   size: 16,
                    // ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 50,
            child: Text("You",
              // connectedUser.profile.name.isEmpty? "You" : connectedUser.profile.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign : TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget imageTemplateStory(String url) {
    return url.isEmpty
        ? Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.dred22,
            ),
            // padding: EdgeInsets.all(80),
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ))
        : ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  8.0), // Pour des coins arrondis (facultatif)
              child: Image.network(
                url,
                width: 40,
                height: 40,
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
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.dred22,
                      ),
                      // padding: EdgeInsets.all(80),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ));
                },
              ),
            ));
  }

  Widget _buildStoryImage(Friend e) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap : () async {
                                            setState(() {
                                              loading = true;
                                            });

                                            Chat tmp = Chat(
                                                id: '',
                                                type: '0',
                                                name: e.friend.profile.name,
                                                unread: '0',
                                                lastMsg: Message(
                                                    id: '99',
                                                    date: '',
                                                    readState: '',
                                                    type: '',
                                                    name: '',
                                                    content: '',
                                                    size: '',
                                                    length: '',
                                                    userId: ''),
                                                img: e.friend.profile.img,
                                                users: [e.friend]);

                                            print(e.friend.profile.id);

                                            // GEt all chats
                                            List<dynamic> chatsRef = [];

                                            await fins
                                                .collection('user')
                                                .doc(connectedUser.profile.id)
                                                .get()
                                                .then((doc) async {
                                              chatsRef =
                                                  doc.data()!['chats'] ?? [];
                                            });

                                            // Loop
                                            for (var ref in chatsRef) {
                                              await fins
                                                  .doc(ref.path)
                                                  .get()
                                                  .then((doc) async {
                                                // Vérif
                                                if (doc.data()!['type'] ==
                                                    '0') {
                                                  for (var usRef
                                                      in doc.data()!['users'] ??
                                                          []) {
                                                    DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>
                                                        usDoc =
                                                        await usRef.get()
                                                            as DocumentSnapshot<
                                                                Map<String,
                                                                    dynamic>>;

                                                    if (usDoc.id ==
                                                        e.friend.profile.id) {
                                                      // true
                                                      DocumentReference
                                                          lastMsgref =
                                                          doc.data()!['lastMsg']
                                                              as DocumentReference;
                                                      // Récupérer les informations du document User référencé par friendRef
                                                      final lastMsgDoc =
                                                          await fins
                                                              .doc(lastMsgref
                                                                  .path)
                                                              .get();

                                                      Message lastMsg =
                                                          Message.fromJson(
                                                              lastMsgDoc
                                                                  .data()!);

                                                      tmp = Chat(
                                                          id: doc.data()!['id'],
                                                          type: doc
                                                              .data()!['type'],
                                                          name: doc
                                                              .data()!['name'],
                                                          unread: doc.data()![
                                                              'unread'],
                                                          lastMsg: lastMsg,
                                                          img: doc
                                                              .data()!['img'],
                                                          users: [e.friend]);
                                                    }
                                                  }
                                                }
                                              });
                                            }

                                            print("Chat ID :  ${tmp.id}");

                                            setState(() {
                                              loading = false;
                                            });

                                            ouvrirO(
                                                context,
                                                ChatContent(
                                                  chat: tmp,
                                                ));
                                          },
                                          child :
         Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.pink, width: 2.0),
              borderRadius: BorderRadius.circular(40),
            ),
            child: CircleAvatar(
                radius: 25,
                backgroundColor: theme.dred22,
                child: imageTemplate(e.friend.profile.img)),
          ),
          SizedBox(
            width: 50,
            child: Text(
              e.friend.profile.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),)
    );
  }

  Stream<int> _getArchived() async* {
    final userSnap =
        await fins.collection('user').doc(connectedUser.profile.id).get();

    int results = 0;

    // Friends
    final tmpcorRefs = userSnap.data()!['chats'] ?? [];
    print("nb refs : ${tmpcorRefs.length}");

    for (var ref in tmpcorRefs) {
      await fins.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        if (doc.data()!['archived']) {
          results++;
        }
      });
    }

//
    yield results;
  }

  Future<Chat> _getChat(Map<String, dynamic> chatData) async {
    DocumentReference lastmsgRef = chatData['lastMsg'] as DocumentReference;

    DocumentSnapshot<Map<String, dynamic>> lastmsgDoc =
        await lastmsgRef.get() as DocumentSnapshot<Map<String, dynamic>>;

    Message lstMsg = Message.fromJson(lastmsgDoc.data()!);

    Chat not = Chat(
        id: chatData['id'],
        type: chatData['type'],
        name: chatData['name'],
        unread: chatData['unread'],
        lastMsg: lstMsg,
        img: chatData['img'],
        users: []);

    not.isTyping = chatData['isTyping'];
    not.isTypingTxt = chatData['isTypingTxt'];

    List<dynamic> usrRefs = chatData['users'] ?? [];

    for (var ref in usrRefs) {
      final usrDoc = await fins.doc(ref.path).get();
      DocumentReference profilRef =
          usrDoc.data()!['profile'] as DocumentReference;
      DocumentSnapshot<Map<String, dynamic>> profileDoc =
          await profilRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      User user = User(profile: Profile.fromJson(profileDoc.data()!));
      user.online = usrDoc.data()!['online'];
      user.visible = usrDoc.data()!['visible'];
      not.users.add(user);
    }
    return not;
  }

/* 
  Stream<List<Chat>> _getChats() async* {
    List<Future<Chat?>> futures = [];
    int archivedCnt = 0;

    print("Id Userr");
    print(connectedUser.profile.id);

    final usSnap =
        await fins.collection('user').doc(connectedUser.profile.id).get();

    List<dynamic> chatRefs = usSnap.data()!['chats'] ?? [];

    print("Nb chats : ${chatRefs.length}");

    for (var ref in chatRefs) {
      futures.add(fins.doc(ref.path).get().then((doc) async {
        //
        if (!doc.data()!['archived']) {
          DocumentReference lastmsgRef =
              doc.data()!['lastMsg'] as DocumentReference;

          DocumentSnapshot<Map<String, dynamic>> lastmsgDoc =
              await lastmsgRef.get() as DocumentSnapshot<Map<String, dynamic>>;

          Message lstMsg = Message.fromJson(lastmsgDoc.data()!);

          Chat not = Chat(
              id: doc.data()!['id'],
              type: doc.data()!['type'],
              name: doc.data()!['name'],
              unread: doc.data()!['unread'],
              lastMsg: lstMsg,
              img: doc.data()!['img'],
              users: []);

          List<dynamic> usrRefs = doc.data()!['users'] ?? [];

          for (var ref in usrRefs) {
            final usrDoc = await fins.doc(ref.path).get();
            DocumentReference profilRef =
                usrDoc.data()!['profile'] as DocumentReference;
            DocumentSnapshot<Map<String, dynamic>> profileDoc =
                await profilRef.get() as DocumentSnapshot<Map<String, dynamic>>;

            User user = User(profile: Profile.fromJson(profileDoc.data()!));
            user.online = usrDoc.data()!['online'];
            user.visible = usrDoc.data()!['visible'];
            not.users.add(user);
          }
          return not;
        } else {
          archivedCnt++;

          return null;
        }
      }));
    }

    // Attendre que toutes les futures soient complétées
    var results = await Future.wait(futures);

    archived = archivedCnt.toString();

    // Filtrer les résultats pour ne garder que ceux qui ne sont pas null
    yield results
        .where((friendInfo) => friendInfo != null)
        .cast<Chat>()
        .toList();
  }
 */
  Widget customSlide(el, Widget child) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {
          // confirmdelete(el);
        }),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              // confirmdelete(el);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      // endActionPane: ActionPane(
      //   motion: const ScrollMotion(),
      //   children: [
      //     SlidableAction(
      //       // An action can be bigger than the others.
      //       flex: 2,
      //       onPressed: (_) => controller.openEndActionPane(),
      //       backgroundColor: const Color(0xFF7BC043),
      //       foregroundColor: Colors.white,
      //       icon: Icons.archive,
      //       label: 'Archive',
      //     ),
      //     SlidableAction(
      //       onPressed: (_) => controller.close(),
      //       backgroundColor: const Color(0xFF0392CF),
      //       foregroundColor: Colors.white,
      //       icon: Icons.save,
      //       label: 'Save',
      //     ),
      //   ],
      // ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: child,
    );
  }

 Stream<List<Friend>> _getFriendsInfoStream() async* {
    List<Future<Friend?>> futures = [];

    final doc =
        await fins.collection('user').doc(connectedUser.profile.id).get();
    List<dynamic> friendsRefs = doc.data()!['friends'] ?? [];
    //         .doc(connectedUser.profile.id)

    for (var ref in friendsRefs) {
      futures
          .add(FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        if (!doc.data()!['requesting'] && doc.data()!['approved']) {
          DocumentReference friendRef =
              doc.data()!['friend'] as DocumentReference;
          // Récupérer les informations du document User référencé par friendRef
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await friendRef.get() as DocumentSnapshot<Map<String, dynamic>>;
          //
          DocumentReference profilRef =
              userDoc.data()!['profile'] as DocumentReference;
          DocumentSnapshot<Map<String, dynamic>> profileDoc =
              await profilRef.get() as DocumentSnapshot<Map<String, dynamic>>;

          User user = User(profile: Profile.fromJson(profileDoc.data()!)); 
          user.online = userDoc.data()!['online'];
  user.visible = userDoc.data()!['visible'];

          Friend friend = Friend(
              id: doc.data()!['id'], date: doc.data()!['date'], friend: user);

          return friend;
        } else {
          return null; // Ignorer les amis qui ne sont pas en demande
        }
      }));
    }

    // Attendre que toutes les futures soient complétées
    var results = await Future.wait(futures);

    // Filtrer les résultats pour ne garder que ceux qui ne sont pas null
    yield results
        .where((friendInfo) => friendInfo != null)
        .cast<Friend>()
        .toList();

    // Écouter les changements dans la collection friends
    // for (var ref in friendsRefs) {
    //   yield* FirebaseFirestore.instance.doc(ref.path).snapshots().asyncMap((doc) async {
    //     if (doc.data()!['requesting']) {
    //        DocumentReference friendRef = doc.data()!['friend'] as DocumentReference;
    //       // Récupérer les informations du document User référencé par friendRef
    //       DocumentSnapshot<Map<String, dynamic>> userDoc = await friendRef.get() as DocumentSnapshot<Map<String, dynamic>>;
    //       //
    //       DocumentReference profilRef = userDoc.data()!['profile'] as DocumentReference;
    //       DocumentSnapshot<Map<String, dynamic>> profileDoc = await profilRef.get() as DocumentSnapshot<Map<String, dynamic>>;

    //       User user = User(profile: Profile.fromJson(profileDoc.data()!));

    //     Friend friend = Friend(date: doc.data()!['date'], friend: user );

    //       return friend;
    //     } else {
    //       return null; // Ignorer si 'requesting' est faux
    //     }
    //   });
    // }
  }

  //
}
