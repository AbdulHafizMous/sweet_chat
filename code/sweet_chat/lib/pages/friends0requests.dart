import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/pages/friends.dart';
import 'package:sweet_chat/utils/shimer.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:sweet_chat/notification_service.dart';

import 'profilanyuser.dart';

class FriendsRequests extends StatefulWidget {
  const FriendsRequests({super.key});

  @override
  State<FriendsRequests> createState() => _FriendsRequestsState();
}

class _FriendsRequestsState extends State<FriendsRequests> {
  bool loading = false;
  FirebaseFirestore fins = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              builder: (context, userSnapshot) {
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
                            "No Requests !",
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
                    builder: (context, friendsSnapshot) {
                      if (friendsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return customShimmerUk();
                      }

                      if (!friendsSnapshot.hasData ||
                          friendsSnapshot.data!.isEmpty ||
                          friendsSnapshot.data == null) {
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
                                  "No Requests !",
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

                      List finalLst = ((!isSearching ||
                              (isSearching && searchctrl.text.isEmpty))
                          ? friendsSnapshot.data!
                          : friendsSnapshot.data!
                              .where((e) => e.friend.profile.name
                                  .toLowerCase()
                                  .contains(searchctrl.text.toLowerCase()))
                              .toList());

                      print("Liste Finale : ${finalLst.length}");

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: scrH(context),
                              child: ListView.builder(
                                itemCount: finalLst.length,
                                itemBuilder: (context, index) {
                                  final e = friendsSnapshot.data![index];

                                  // Utilisation d'un StreamBuilder pour récupérer le profil correspondant
                                  return mdFriendRequest(
                                    context,
                                    e,
                                    confirm: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      // setState(() {
                                      //   e.approved = true;
                                      // });
                                      await fins
                                          .collection('friend')
                                          .doc(e.id)
                                          .update({
                                        'requesting': false,
                                        'approved': true,
                                        'date': DateTime.now().toString(),
                                      });
                                      //
                                      String uid = DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString();
                                      //
                                      // Creéer le friend moi
                                      DocumentReference profile = fins
                                          .collection('user')
                                          .doc(connectedUser.profile.id);
                                      await fins
                                          .collection('friend')
                                          .doc(uid)
                                          .set({
                                        'approved': true,
                                        'id': uid,
                                        'date': DateTime.now().toString(),
                                        'requesting': false,
                                        'friend': profile
                                      });
                                      //
                                      // Creéer la Notif
                                      await fins
                                          .collection('notif')
                                          .doc(uid)
                                          .set({
                                        'userid': connectedUser.profile.id,
                                        'type': "1",
                                        'content':
                                            "${connectedUser.profile.name} accepted your friend request",
                                        'readState': "0",
                                        'img': connectedUser.profile.img,
                                        'id': uid,
                                        'date': DateTime.now().toString(),
                                      });
                                      //
                                      //
                                      // Send Notif
                                      print("Sending Notif");
                                      String token = await getUserToken(
                                          e.friend.profile.id);
                                      envoiNotifnew(
                                          token,
                                          "New Friend Confirmation",
                                          "${connectedUser.profile.name} accepted your friend request ! You can now chat ");
                                      //
                                      //
                                      // Ajouter dans la liste de friend du user connecté ?? c'est pour lautre
                                      DocumentReference profile2 =
                                          fins.collection('friend').doc(uid);

                                      DocumentReference notif =
                                          fins.collection('notif').doc(uid);

                                      await fins
                                          .collection('user')
                                          .doc(e.friend.profile.id)
                                          .update({
                                        'friends':
                                            FieldValue.arrayUnion([profile2]),
                                        'notifs':
                                            FieldValue.arrayUnion([notif]),
                                      });

                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    delete: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      //
                                      String uid = DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString();
                                      // Creéer la Notif
                                      await fins
                                          .collection('notif')
                                          .doc(uid)
                                          .set({
                                        'userid': connectedUser.profile.id,
                                        'type': "1",
                                        'content':
                                            "${connectedUser.profile.name} rejected your friend request",
                                        'readState': "0",
                                        'img': connectedUser.profile.img,
                                        'id': uid,
                                        'date': DateTime.now().toString(),
                                      });
                                      //
                                      //
                                      // Send Notif
                                      print("Sending Notif");
                                      String token = await getUserToken(
                                          e.friend.profile.id);
                                      envoiNotifnew(
                                          token,
                                          "Rejected Friend Request",
                                          "${connectedUser.profile.name} just rejected your friend request ! Check out why");
                                      //
                                      //
                                      // Supprimer dans la liste de friend du user connecté
                                      DocumentReference notif =
                                          fins.collection('notif').doc(uid);

                                      DocumentReference profile2 =
                                          fins.collection('friend').doc(e.id);
                                      await fins
                                          .collection('user')
                                          .doc(connectedUser.profile.id)
                                          .update({
                                        'friends':
                                            FieldValue.arrayRemove([profile2]),
                                      });
                                      await fins
                                          .collection('user')
                                          .doc(e.friend.profile.id)
                                          .update({
                                        'notifs':
                                            FieldValue.arrayUnion([notif]),
                                      });
                                      //
                                      // Supprimer le friend
                                      await fins
                                          .collection('friend')
                                          .doc(e.id)
                                          .delete();
                                      //
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    profile: () {
                                      setState(() {
                                        // fermer(context);
                                        ouvrirO(
                                            context,
                                            AnyUserProfil(
                                              user: e.friend,
                                            ));
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            isSearching &&
                                    searchctrl.text.isNotEmpty &&
                                    friendsSnapshot.data!
                                        .where((e) => e.friend.profile.name
                                            .toLowerCase()
                                            .contains(
                                                searchctrl.text.toLowerCase()))
                                        .isEmpty
                                ? SizedBox(
                                    height: scrH(context),
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
                                : SizedBox()
                          ],
                        ),
                      );
                    });
              })),
    );
  }

  Stream<List<Friend>> _getFriendsInfoStream(List<dynamic> friendsRefs) async* {
    List<Future<Friend?>> futures = [];

    print("nb friends : ${friendsRefs.length}");

    for (var ref in friendsRefs) {
      futures
          .add(FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
        // Vérifier si 'requesting' est vrai avant de récupérer les infos du User
        if (doc.data()!['requesting']) {
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
