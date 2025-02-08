import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/shimer.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/pages/chatcontent.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/widgets.dart';

class ChatChooseUser extends StatefulWidget {
  const ChatChooseUser({super.key});

  @override
  State<ChatChooseUser> createState() => _ChatChooseUserState();
}

class _ChatChooseUserState extends State<ChatChooseUser> {
  bool loading = false, srchanim = true;
  FirebaseFirestore fins = FirebaseFirestore.instance;
  TextEditingController searchctrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(connectedUser.profile.id);
  }

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
                  appBar: AppBar(
                    title: Text(
                      'Choose Friend',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.white,
                  ),
                  body:

                      // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      //     stream: FirebaseFirestore.instance
                      //         .collection('user')
                      //         .doc(connectedUser.profile.id)
                      //         .snapshots(),
                      //     builder: (snContext, userSnapshot) {
                      //       if (userSnapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return customShimmer();
                      //       }

                      //       if (userSnapshot.hasError) {
                      //         return Center(
                      //             child: Text('Error : ${userSnapshot.error}'));
                      //       }

                      //       List<dynamic> friendsRefs =
                      //           userSnapshot.data!['friends'] ?? [];

                      //       if (friendsRefs.isEmpty) {
                      //         return SizedBox(
                      //           height: scrH(context),
                      //           child: Center(
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Icon(
                      //                   Icons.query_stats_outlined,
                      //                   size: 50,
                      //                 ),
                      //                 SizedBox(
                      //                   height: 15,
                      //                 ),
                      //                 Text(
                      //                   "No Added Friends !",
                      //                   textAlign: TextAlign.center,
                      //                   style: TextStyle(
                      //                       fontSize: 20,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       }

                      //       return

                      Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: TextFormField(
                                  controller: searchctrl,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {});
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
                                              const EdgeInsets.only(left: 10),
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
                          ),
                          //
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: StreamBuilder<List<Friend>>(
                            stream: _getFriendsInfoStream(),
                            builder: (snContext, friendsSnapshot) {
                              if (friendsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return customShimmer();
                              }

                              if (!friendsSnapshot.hasData ||
                                  friendsSnapshot.data!.isEmpty) {
                                return SizedBox(
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
                                          "No Added Friends !",
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

                              if (friendsSnapshot.hasError) {
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
                                          "Loading Error !",
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

                              final notifs = friendsSnapshot.data!;

                              return srchanim &&
                                      searchctrl.text.isNotEmpty &&
                                      notifs
                                          .where((e) => e.friend.profile.name
                                              .toLowerCase()
                                              .contains(searchctrl.text
                                                  .toLowerCase()))
                                          .isEmpty
                                  ? SizedBox(
                                      height: scrH(context) - 220,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                  : ListView.builder(
                                      itemCount: ((!srchanim ||
                                                  (srchanim &&
                                                      searchctrl.text.isEmpty))
                                              ? notifs
                                              : notifs.where((e) => e
                                                  .friend.profile.name
                                                  .toLowerCase()
                                                  .contains(searchctrl.text
                                                      .toLowerCase())))
                                          .length,
                                      itemBuilder: (strContext, index) {
                                        final e = ((!srchanim ||
                                                    (srchanim &&
                                                        searchctrl
                                                            .text.isEmpty))
                                                ? notifs
                                                : notifs.where((e) => e
                                                    .friend.profile.name
                                                    .toLowerCase()
                                                    .contains(searchctrl.text
                                                        .toLowerCase())))
                                            .toList()[index];
                                        // Utilisation d'un StreamBuilder pour récupérer le profil correspondant
                                        return mdYourFriendToChat(
                                          context,
                                          e,
                                          message: () async {
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
                                            fermer(context);

                                            ouvrirO(
                                                context,
                                                ChatContent(
                                                  chat: tmp,
                                                ));
                                          },
                                        );
                                      },
                                    );
                            }),
                      ),
                    ],
                  )

                  //   ;

                  // })

                  //

                  ),
            )));
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
}
