import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
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

class ArchivedChatPage extends StatefulWidget {
  const ArchivedChatPage({super.key});

  @override
  State<ArchivedChatPage> createState() => _ArchivedChatPageState();
}

// StreamController stc = StreamController();

class _ArchivedChatPageState extends State<ArchivedChatPage>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  List<String> chatSelectionList = [];

  int filter = 0;

  bool loading = false, srchanim = false;
  TextEditingController searchctrl = TextEditingController();
  FirebaseFirestore fins = FirebaseFirestore.instance;

  ScrollController scCtrl = ScrollController(initialScrollOffset: 60);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // load();
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
      child: Container(
      color: context.watch<AppTheme>().themeclass.top,
      child: SafeArea(
        top: true,
        child: Scaffold(
        backgroundColor:
            context.watch<AppTheme>().isDark ? fondDark : Colors.white,

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

        body: Stack(
          children: [
            Scaffold(
                body: StreamBuilder<DocumentSnapshot>(
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
                              mainAxisAlignment: MainAxisAlignment.center,
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

                      final chData =
                          notifSnapshot.data!.data() as Map<String, dynamic>;
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
                              ? SizedBox(
                                  height: scrH(context),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.query_stats_outlined,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Nothing to Show !",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 60,
                                          ),
                                          ...chatLst.map(
                                            (elem) {
                                              return StreamBuilder(
                                                stream: elem.snapshots(),
                                                builder: (context2, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    // return customShimmer();
                                                    return Container();
                                                  }

                                                  if (snapshot.hasError) {
                                                    return SizedBox(
                                                      // height: scrH(context),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              BoxIcons.bx_error,
                                                              size: 50,
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              "Loading Error ! ${snapshot.error}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  final chatData = snapshot
                                                          .data!
                                                          .data()
                                                      as Map<String, dynamic>;

                                                  // Filter
                                                  if (!chatData["archived"]) {
                                                    // archived =
                                                    //     (int.parse(archived) + 1)
                                                    //         .toString();
                                                    // print("Archived : $archived");
                                                    return Container();
                                                  }
                                                  if (searchctrl
                                                          .text.isNotEmpty &&
                                                      !chatData["name"]
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(searchctrl
                                                              .text
                                                              .toLowerCase())) {
                                                    return Container();
                                                  }
                                                  if (filter == 1 &&
                                                      (chatData["unread"] ==
                                                          "0")) {
                                                    return Container();
                                                  }

                                                  return FutureBuilder(
                                                    future: _getChat(chatData),
                                                    builder:
                                                        (context3, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return customShimmerUk();
                                                      }

                                                      if (snapshot.hasError) {
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
                                                                  height: 15,
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
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      final e = snapshot.data!;

                                                      return mdChat(
                                                          context,
                                                          e,
                                                          chatSelectionList
                                                              .contains(e.id),
                                                          e.lastMsg.userId ==
                                                              connectedUser
                                                                  .profile
                                                                  .id, () {
                                                        setState(() {
                                                          if (!chatSelectionList
                                                              .contains(e.id)) {
                                                            chatSelectionList
                                                                .add(e.id);
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
                                                                  .remove(e.id);
                                                            } else {
                                                              chatSelectionList
                                                                  .add(e.id);
                                                            }
                                                          } else {
                                                            // ouvrir
                                                            chatSelectionList
                                                                .clear();
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
                                                  );
                                                },
                                              );

                                              //
                                            },
                                          ),
                                        ],
                                      )),
                                );
                    })),

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
            Container(
              // color: Colors.white,
              color:
                  context.watch<AppTheme>().isDark ? fondDark2 : Colors.white,
              child: Positioned(
                top: 0,
                child: Padding(
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                                .update({'archived': false});
                                          }
                                          setState(() {
                                            chatSelectionList.clear();
                                          });
                                        },
                                        child: Icon(
                                          Icons.unarchive_outlined,
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
                                                .doc(connectedUser.profile.id).update({
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
                                Expanded(
                                    flex: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back, size: 24),
                                      onPressed: () {
                                        fermer(context);
                                      },
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    " Archived Chats",
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
                                                          : Color.fromRGBO(252,
                                                              252, 252, 0.72),
                                                      SizedBox(
                                                        width: double.infinity,
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
                                                                    : Icons.add,
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
                                                      opt: 2, bc: theme.dred1),
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
                                                          : Color.fromRGBO(252,
                                                              252, 252, 0.72),
                                                      SizedBox(
                                                        width: double.infinity,
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
                                                                    : Icons.add,
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
                                                      opt: 2, bc: theme.dred1),
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
    )));
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

  //
}
