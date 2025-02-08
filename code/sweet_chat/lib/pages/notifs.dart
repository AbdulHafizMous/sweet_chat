import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/pages/profilanyuser.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/shimer.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/widgets.dart';

class NotifsPage extends StatefulWidget {
  const NotifsPage({super.key, required this.menu});
  final Widget menu;
  @override
  State<NotifsPage> createState() => _NotifsPageState();
}

class _NotifsPageState extends State<NotifsPage>
    with SingleTickerProviderStateMixin {
  bool loading = false, srchanim = false;
  TextEditingController searchctrl = TextEditingController();
  FirebaseFirestore fins = FirebaseFirestore.instance;

  // List<Notif> notifs = [];

  Future<void> chargeement() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer.periodic(const Duration(seconds: 120), (timer) {
    //   print(timer.tick);
    //   setState(() {});
    // });
    // chargeement();
    searchctrl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      child: Scaffold(
        body: Stack(
          children: [
            Scaffold(
                body: StreamBuilder<List<Notif>>(
                    stream:
                        // FirebaseFirestore.instance.collection('user').snapshots(),
                        _getNotifs(),
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

                      final notifs = notifSnapshot.data!
                          // .where(
                          //   (d) => d.id != connectedUser.profile.id,
                          // )
                          // .toList()
                          ;

                      return srchanim &&
                              searchctrl.text.isNotEmpty &&
                              notifs
                                  .where((e) => e.content
                                      .toLowerCase()
                                      .contains(searchctrl.text.toLowerCase()))
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
                          : notifs.isEmpty
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
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: srchanim ? 120 : 65,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ListView.builder(
                                        itemCount: ((!srchanim ||
                                                    (srchanim &&
                                                        searchctrl
                                                            .text.isEmpty))
                                                ? notifs
                                                : notifs.where((e) => e.content
                                                    .toLowerCase()
                                                    .contains(searchctrl.text
                                                        .toLowerCase())))
                                            .length,
                                        // notifs.length,
                                        itemBuilder: (context2, index) {
                                          final e = ((!srchanim ||
                                                      (srchanim &&
                                                          searchctrl
                                                              .text.isEmpty))
                                                  ? notifs
                                                  : notifs.where((e) => e
                                                      .content
                                                      .toLowerCase()
                                                      .contains(searchctrl.text
                                                          .toLowerCase())))
                                              .toList()[index];
                                          //  notifs[index];

                                          // Utilisation d'un StreamBuilder pour récupérer le profil correspondant
                                          return mdNotif(
                                            context,
                                            e,
                                            confirm: () {
                                              // setState(() {
                                              //   connectedUser.friends
                                              //       .firstWhere(
                                              //         (f) =>
                                              //             !f.approved &&
                                              //             !f.requesting &&
                                              //             f.friend.profile.id == e.userid,
                                              //       )
                                              //       .approved = true;
                                              //   e.readState = '1';
                                              // });
                                            },
                                            delete: () {
                                              // setState(() {
                                              //   connectedUser.friends.removeWhere(
                                              //     (f) =>
                                              //         !f.approved &&
                                              //         !f.requesting &&
                                              //         f.friend.profile.id == e.userid,
                                              //   );
                                              //   e.readState = '1';
                                              // });
                                            },
                                            optdelete: () async {
                                              // connectedUser.notifs.remove(e);
                                              DocumentReference profile2 = fins
                                                  .collection('notif')
                                                  .doc(e.id);
                                              await fins
                                                  .collection('user')
                                                  .doc(connectedUser.profile.id)
                                                  .update({
                                                'notifs':
                                                    FieldValue.arrayRemove(
                                                        [profile2]),
                                              });
                                              //
                                              // Supprimer notif
                                              await fins
                                                  .collection('notif')
                                                  .doc(e.id)
                                                  .delete();

                                              setState(() {
                                                fermer(context);
                                              });
                                            },
                                            optgo: () async {
                                              await fins
                                                  .collection('notif')
                                                  .doc(e.id)
                                                  .update({
                                                'readState': '1',
                                              });
                                              //
                                              //  Get User to go to profile
                                              final userSnapshot = await fins
                                                  .collection('user')
                                                  .doc(e.userid)
                                                  .get();
                                              final ref = userSnapshot['profile']
                                                  as DocumentReference;

                                              DocumentSnapshot<
                                                        Map<String, dynamic>>
                                                    profileDoc = await ref.get()
                                                        as DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>;

                                                User user = User(
                                                    profile: Profile.fromJson(
                                                        profileDoc.data()!));

                                                user.online = userSnapshot['online'];
                                                user.visible = userSnapshot['visible'];

                                              // 
                                              //
                                              setState(() {
                                                fermer(context);
                                                // e.readState = '1';
                                                // connectedUser.notifs.remove(e);
                                                ouvrirO(
                                                    context,
                                                    AnyUserProfil(
                                                      user: user,
                                                    ));
                                              });
                                            },
                                            optgo2: () async {
                                              await fins
                                                  .collection('notif')
                                                  .doc(e.id)
                                                  .update({
                                                'readState': '1',
                                              });
                                              //
                                              //  Get User to go to profile
                                              final userSnapshot = await fins
                                                  .collection('user')
                                                  .doc(e.userid)
                                                  .get();
                                              final ref = userSnapshot['profile']
                                                  as DocumentReference;

                                              DocumentSnapshot<
                                                        Map<String, dynamic>>
                                                    profileDoc = await ref.get()
                                                        as DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>;

                                                User user = User(
                                                    profile: Profile.fromJson(
                                                        profileDoc.data()!));

                                                user.online = userSnapshot['online'];
                                                user.visible = userSnapshot['visible'];

                                              // 
                                              //
                                              setState(() {
                                                // e.readState = '1';
                                                // connectedUser.notifs.remove(e);
                                                ouvrirO(
                                                    context,
                                                    AnyUserProfil(
                                                      user: user,
                                                    ));
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                    })),

            /*   connectedUser.notifs.isEmpty
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
                            "Nothing to Show !",
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
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: srchanim ? 120 : 65,
                        ),
                        ...((!srchanim || (srchanim && searchctrl.text.isEmpty))
                                ? connectedUser.notifs
                                : connectedUser.notifs.where((e) => e.content
                                    .toLowerCase()
                                    .contains(searchctrl.text.toLowerCase())))
                            .map(
                          (e) {
                            return mdNotif(
                              context,
                              e,
                              confirm: () {
                                // setState(() {
                                //   connectedUser.friends
                                //       .firstWhere(
                                //         (f) =>
                                //             !f.approved &&
                                //             !f.requesting &&
                                //             f.friend.profile.id == e.userid,
                                //       )
                                //       .approved = true;
                                //   e.readState = '1';
                                // });
                              },
                              delete: () {
                                // setState(() {
                                //   connectedUser.friends.removeWhere(
                                //     (f) =>
                                //         !f.approved &&
                                //         !f.requesting &&
                                //         f.friend.profile.id == e.userid,
                                //   );
                                //   e.readState = '1';
                                // });
                              },
                              optdelete: () {
                                setState(() {
                                  fermer(context);
                                  connectedUser.notifs.remove(e);
                                });
                              },
                              optgo: () {
                                setState(() {
                                  fermer(context);
                                  e.readState = '1';
                                  // connectedUser.notifs.remove(e);
                                });
                              },
                              optgo2: () {
                                setState(() {
                                  e.readState = '1';
                                  // connectedUser.notifs.remove(e);
                                });
                              },
                            );
                          },
                        ),
                        //
                        srchanim &&
                                searchctrl.text.isNotEmpty &&
                                connectedUser.notifs
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
                            : SizedBox()
                      ],
                    )),
                  ),
 */
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
             
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 0, child: widget.menu),
                          Expanded(
                            flex: 1,
                            child: Text(
                              " Notifications",
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
                                      onTap: () {
                                        //
                                        customDiag(context, confirmDiag());
                                      },
                                      child: Icon(
                                        Icons.check_circle_outline_outlined,
                                        size: 30,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                ],
                              )),
                        ],
                      ),

                      //

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
                                              padding: const EdgeInsets.only(
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
                                                      child: VerticalDivider(
                                                        color: theme.dred1,
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
          ],
        ),
      ),
    );
  }

  Stream<List<Notif>> _getNotifs() async* {
    List<Future<Notif?>> futures = [];

    final usSnap = await FirebaseFirestore.instance
        .collection('user')
        .doc(connectedUser.profile.id)
        .get();

    List<dynamic> notifssRefs = usSnap.data()!['notifs'] ?? [];

    for (var ref in notifssRefs) {
      futures
          .add(FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        Notif not = Notif.fromJson(doc.data()!);
        return not;
      }));
    }

    // Attendre que toutes les futures soient complétées
    var results = await Future.wait(futures);

    // Filtrer les résultats pour ne garder que ceux qui ne sont pas null
    yield results
        .where((friendInfo) => friendInfo != null)
        .cast<Notif>()
        .toList();
  }

  Widget confirmDiag() {
    //
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
              'Are you sure you really mant to make this ?',
              style: wtTitle(18, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          // Icons
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Color.fromARGB(135, 74, 78, 195), width: 15)),
            child: Icon(
              Icons.question_mark_outlined,
              color: const Color.fromARGB(255, 94, 82, 255),
              size: 100,
            ),
          ),
          // Texte2
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'All Notifications will be marked as readed !',
              style: wtTitle(16, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          //

          // Boutons
          SizedBox(
            height: 8,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              customButton(
                  theme.dred1,
                  Text(
                    'Confirm',
                    style: wtTitle(16, 1, theme.dred4, true, false),
                  ),
                  15, () async {
                //
                //  Enregistrer
                final usSnap = await FirebaseFirestore.instance
                    .collection('user')
                    .doc(connectedUser.profile.id)
                    .get();

                List<dynamic> notifssRefs = usSnap.data()!['notifs'] ?? [];

                for (var ref in notifssRefs) {
                  await fins.doc(ref.path).update({
                    'readState': '1',
                  });
                }
                setState(() {
                  fermer(context);
                });
              }, -1, cp: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            ],
          )
        ],
      );
    });
  }
}
