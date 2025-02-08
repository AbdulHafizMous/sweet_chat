import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/notification_service.dart';
import 'package:sweet_chat/utils/shimer.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/pages/chatcontent.dart';
import 'package:sweet_chat/pages/profilanyuser.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/widgets.dart';

class YourFriends extends StatefulWidget {
  const YourFriends({super.key});

  @override
  State<YourFriends> createState() => _YourFriendsState();
}

class _YourFriendsState extends State<YourFriends> {
  bool loading = false;
  FirebaseFirestore fins = FirebaseFirestore.instance;

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
      child: Scaffold(
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(connectedUser.profile.id)
                  .snapshots(),
              builder: (snContext, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return customShimmer();
                }

                if (userSnapshot.hasError) {
                  return Center(child: Text('Error : ${userSnapshot.error}'));
                }

                List<dynamic> friendsRefs = userSnapshot.data!['friends'] ?? [];

                if (friendsRefs.isEmpty) {
                  return SizedBox(
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
                            "No Added Friends !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return StreamBuilder<List<Friend>>(
                    stream: _getFriendsInfoStream(friendsRefs),
                    builder: (snContext, friendsSnapshot) {
                      if (friendsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return customShimmerUk();
                      }

                      if (!friendsSnapshot.hasData ||
                          friendsSnapshot.data!.isEmpty) {
                        return SizedBox(
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
                      

                      return 
                      
                      ListView.builder(
                        itemCount: friendsSnapshot.data!.length,
                        itemBuilder: (strContext, index) {
                          final e = friendsSnapshot.data![index];

                          // Utilisation d'un StreamBuilder pour récupérer le profil correspondant
                          return mdYourFriend(
                            context,
                            e,
                            message: () async{
                               
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
                                      chatsRef = doc.data()!['chats'] ?? [];
                                    });

                                    // Loop
                                    for (var ref in chatsRef) {
                                      await fins
                                          .doc(ref.path)
                                          .get()
                                          .then((doc) async {
                                        // Vérif
                                        if (doc.data()!['type'] == '0') {
                                          for (var usRef
                                              in doc.data()!['users'] ?? []) {
                                            DocumentSnapshot<
                                                    Map<String, dynamic>>
                                                usDoc = await usRef.get()
                                                    as DocumentSnapshot<
                                                        Map<String, dynamic>>;

                                            if (usDoc.id ==
                                                e.friend.profile.id) {
                                              // true
                                              DocumentReference lastMsgref =
                                                  doc.data()!['lastMsg']
                                                      as DocumentReference;
                                              // Récupérer les informations du document User référencé par friendRef
                                              final lastMsgDoc = await fins
                                                  .doc(lastMsgref.path)
                                                  .get();

                                              Message lastMsg =
                                                  Message.fromJson(
                                                      lastMsgDoc.data()!);

                                              tmp = Chat(
                                                  id: doc.data()!['id'],
                                                  type: doc.data()!['type'],
                                                  name: doc.data()!['name'],
                                                  unread: doc.data()!['unread'],
                                                  lastMsg: lastMsg,
                                                  img: doc.data()!['img'],
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
                            retrieve: () async {
                              setState(() {
                                fermer(context);
                                // friends.remove(e);
                              });
                              await deleteFriend(e, connectedUser.profile.id);
                              // 
                                            // Send Notif
                                            print("Sending Notif");
                                            String token = await getUserToken(e.friend.profile.id);
                                            envoiNotifnew(token, "Unfriend", "${connectedUser.profile.name} just unfriend with you ! Check out why");
                                            // 
                                            // 
                            },
                            profile: () {
                              setState(() {
                                fermer(context);
                                ouvrirO(
                                    context,
                                    AnyUserProfil(
                                      user: e.friend,
                                    ));
                              });
                            },
                            profile2: () {
                              setState(() {
                                ouvrirO(
                                    context,
                                    AnyUserProfil(
                                      user: e.friend,
                                    ));
                              });
                            },
                          );
                        },
                      );
                    });
              })

          //

          ),
    );
  }

  Future<void> deleteFriend(Friend lui, String moiId) async {
    try {
      // print('lui :: ${lui.friend.profile.id} , Moi :: $moiId');
// Supprimer aussi chez Moi
      //

      //
      // Supprimer dans la liste de friend du user connecté
      DocumentReference profile2 = fins.collection('friend').doc(lui.id);
      // print("Lui id : ${lui.id} :: Lui Usr ! ${profile2}");
      await fins.collection('user').doc(moiId).update({
        'friends': FieldValue.arrayRemove([profile2]),
      });
      //
      // Supprimer le friend
      await fins.collection('friend').doc(lui.id).delete();
      print("deleted chez moi");
      //
      // Supprimer aussi chez l'autre
      //

      //
      //
      // Référence au document utilisateur
      DocumentReference userRef =
          fins.collection('user').doc(lui.friend.profile.id);

      // Récupérer le document utilisateur
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Obtenir la liste des références dans le champ 'friends'
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        List<dynamic> friendsList = userData?['friends'] ?? [];

        print(friendsList.length);

        // Vérifier chaque référence pour voir si l'attribut 'id' correspond
        for (var friendRef in friendsList) {
          DocumentSnapshot friendSnapshot = await friendRef.get();

          if (friendSnapshot.exists) {
            Map<String, dynamic>? userData =
                friendSnapshot.data() as Map<String, dynamic>?;

            DocumentReference<Map<String, dynamic>> user = userData?['friend'];
            DocumentSnapshot userSn = await user.get();

            // print("id du friend : ${friendSnapshot.id}");
            // print("id du friendUser : ${userSn.id}");
            // print('6--------6');

            if (userSn.id == moiId) {
              //
              // Supprimer dans la liste de friend du user connecté
              // DocumentReference profile2 =
              //     fins.collection('friend').doc(friendSnapshot.id);
// print(profile2);
              await fins.collection('user').doc(lui.friend.profile.id).update({
                'friends': FieldValue.arrayRemove([friendRef]),
              });
              //
              // Supprimer le friend
              await fins.collection('friend').doc(friendSnapshot.id).delete();
              print("deleted chez lui");
              //
              break;
            }
          }
        }
      }
    } catch (e) {
      print("Error checking if friend exists: $e");
    }

    setState(() {
      // requested.remove(friendId);
    });
    return; // L'ami n'existe pas
  }

  Stream<List<Friend>> _getFriendsInfoStream(List<dynamic> friendsRefs) async* {
    List<Future<Friend?>> futures = [];

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
