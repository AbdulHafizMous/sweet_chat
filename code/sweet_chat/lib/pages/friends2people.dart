import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/notification_service.dart';
import 'package:sweet_chat/utils/shimer.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/pages/profilanyuser.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/widgets.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  bool loading = false;
  FirebaseFirestore fins = FirebaseFirestore.instance;
  List requested = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      requested.clear();
      print('Id Pro de luser :');
      print(connectedUser.profile.id);
      // print(fauth.FirebaseAuth.instance.currentUser!.uid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
        isLoading: loading,
        progressIndicator: loadingAnimation(),
        child: Scaffold(
            body: StreamBuilder<List<QueryDocumentSnapshot>>(
                stream:
                    // FirebaseFirestore.instance.collection('user').snapshots(),
                    _getUsers(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return customShimmer();
                  }

                  if (userSnapshot.hasError) {
                    return Center(
                        child: Text('Error : ${userSnapshot.error}'));
                  }

                  final users = userSnapshot.data!
                      // .where(
                      //   (d) => d.id != connectedUser.profile.id,
                      // )
                      // .toList()
                      ;

                  return users.isEmpty
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
                                  "No More Users !",
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
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final userDoc = users[index];

                            // Utilisation d'un StreamBuilder pour récupérer le profil correspondant
                            return SizedBox(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    StreamBuilder<User>(
                                      stream: _getUserProfile(userDoc),
                                      builder: (context, profileSnapshot) {
                                        if (profileSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return customShimmerUk();
                                        }

                                        if (profileSnapshot.hasError) {
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }

                                        final e = profileSnapshot.data!;

                                        return mdFriendAddable(
                                          context,
                                          e,
                                          e.tmpRequesting,
                                          add: () async {
                                            setState(() {
                                              loading = true;
                                            });
                                            // FireStore

                                            String uid = DateTime.now()
                                                .microsecondsSinceEpoch
                                                .toString();
                                            //
                                            // Creéer le friend
                                            DocumentReference profile = fins
                                                .collection('user')
                                                .doc(connectedUser.profile.id);
                                            await fins
                                                .collection('friend')
                                                .doc(uid)
                                                .set({
                                              'approved': false,
                                              'id': uid,
                                              'date': DateTime.now().toString(),
                                              'requesting': true,
                                              'friend': profile
                                            });
                                            //
                                            // Creéer la Notif
                                            await fins
                                                .collection('notif')
                                                .doc(uid)
                                                .set({
                                              'userid': connectedUser.profile.id,
                                              'type': "0",
                                              'content': "${connectedUser.profile.name} sent you a friend request",
                                              'readState': "0",
                                              'img': connectedUser.profile.img,
                                              'id': uid,
                                              'date': DateTime.now().toString(),
                                            });
                                            // 
                                            // Send Notif
                                            print("Sending Notif");
                                            String token = await getUserToken(e.profile.id);
                                            envoiNotifnew(token, "New Friend Request", "${connectedUser.profile.name} sent you a friend request ! Check it");
                                            // 
                                            // 
                                            //
                                            // Ajouter dans la liste de friend du user connecté ?? c'est pour lautre
                                            DocumentReference profile2 = fins
                                                .collection('friend')
                                                .doc(uid);
                                                DocumentReference notif = fins
                                                .collection('notif')
                                                .doc(uid);
                                            await fins
                                                .collection('user')
                                                .doc(e.profile.id)
                                                .update({
                                              'friends': FieldValue.arrayUnion([profile2]),
                                              'notifs': FieldValue.arrayUnion([notif]),
                                            });
                                            //

                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                          cancel: () async {
                                            setState(() {
                                              loading = true;
                                            });
                                            await deleteRequest(e.profile.id,
                                                connectedUser.profile.id);

                                                // 
                                            // Send Notif
                                            print("Sending Notif");
                                            String token = await getUserToken(e.profile.id);
                                            envoiNotifnew(token, "Canceled Friend Request", "${connectedUser.profile.name} just canceled the friend request ! Check out why");
                                            // 
                                            // 
                                            // setState(() {
                                            //   connectedUser.friends.removeWhere(
                                            //     (f) =>
                                            //         f.requesting == true &&
                                            //         f.friend.profile.id ==
                                            //             e.profile.id,
                                            //   );
                                            // });
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                          profile: () {
                                            setState(() {
                                              fermer(context);
                                              ouvrirO(
                                                  context,
                                                  AnyUserProfil(
                                                    user: e,
                                                  ));
                                            });
                                          },
                                          profile2: () {
                                            setState(() {
                                              ouvrirO(
                                                  context,
                                                  AnyUserProfil(
                                                    user: e,
                                                  ));
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                }))
                
                );
  }

  Future<bool> isRequesting(String userId, String friendId) async {
    try {
      // Référence au document utilisateur
      DocumentReference userRef = fins.collection('user').doc(userId);

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

            // print("id du friend : ${user.id}");
            // print("id de nap : $friendId");
            // print(user.id == friendId);
            // print('6--------6');

            if (user.id == friendId && userData?['requesting'] == true) {
              // setState(() {
              // requested.add(friendId);
              // });
              return true; // L'ami existe
            }
          }
        }
      }
    } catch (e) {
      print("Error checking if friend exists: $e");
    }

    // setState(() {
    // requested.remove(friendId);
    // });
    return false; // L'ami n'existe pas
  }

  Future<void> deleteRequest(String userId, String friendId) async {
    try {
      // Référence au document utilisateur
      DocumentReference userRef = fins.collection('user').doc(userId);

      // Récupérer le document utilisateur
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Obtenir la liste des références dans le champ 'friends'
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        List<dynamic> friendsList = userData?['friends'] ?? [];

        // print(friendsList.length);

        // Vérifier chaque référence pour voir si l'attribut 'id' correspond
        for (var friendRef in friendsList) {
          DocumentSnapshot friendSnapshot = await friendRef.get();

          if (friendSnapshot.exists) {
            Map<String, dynamic>? userData =
                friendSnapshot.data() as Map<String, dynamic>?;

            DocumentReference<Map<String, dynamic>> user = userData?['friend'];

            // print("id du friend : ${user.id}");
            // print("id de nap : $friendId");
            // print(user.id == friendId);
            // print('6--------6');

            if (user.id == friendId && userData?['requesting'] == true) {
              //
              // Supprimer dans la liste de friend du user connecté
              DocumentReference profile2 =
                  fins.collection('friend').doc(friendSnapshot.id);
              await fins
                  .collection('user')
                  .doc(userId)
                  .update({
                'friends': FieldValue.arrayRemove([profile2]),
              });
              //
              // Supprimer le friend
              await fins.collection('friend').doc(friendSnapshot.id).delete();
              //
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

  Stream<List<QueryDocumentSnapshot>> _getUsers() async* {
    List<QueryDocumentSnapshot> users = [];

    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(connectedUser.profile.id)
        .get();

    List<dynamic> friendsRefs = userSnapshot.data()!['friends'] ?? [];

    QuerySnapshot<Map<String, dynamic>> userLst =
        await FirebaseFirestore.instance.collection('user').get();

    print("Tous les firends : ${friendsRefs.length}");
    print("Tous les Users : ${userLst.docs.length}");

    for (QueryDocumentSnapshot<Map<String, dynamic>> us in userLst.docs) {
      bool good = true;
      for (var fref in friendsRefs) {
        DocumentSnapshot<Map<String, dynamic>> fDoc =
            await fref.get() as DocumentSnapshot<Map<String, dynamic>>;

        DocumentReference uref = fDoc.data()!['friend'] as DocumentReference;
        // Récupérer les informations du document User référencé par friendRef
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await uref.get() as DocumentSnapshot<Map<String, dynamic>>;
        //

        print("MeId : ${connectedUser.profile.id}, --- UserID : ${us.id} ---- FriendId : ${userDoc.id }");

        if (userDoc.id == us.id 
        // &&  fDoc.data()!['requesting'] &&
        //     !fDoc.data()!['approved']
            ) {
          good = false;
          break;
        } else {
          good = true;
        }
      }
      if (us.id == connectedUser.profile.id) {
        good = false;
      }
      if (good) {
        print('added');
        users.add(us);
      }
    }

    yield users;
  }

  Stream<User> _getUserProfile(dynamic userDoc) async* {
    final ref = userDoc['profile'] as DocumentReference;

    var results =
        await FirebaseFirestore.instance.doc(ref.path).get().then((doc) async {
      //

      DocumentSnapshot<Map<String, dynamic>> profileDoc =
          await ref.get() as DocumentSnapshot<Map<String, dynamic>>;

      User e = User(profile: Profile.fromJson(profileDoc.data()!));

      e.online = userDoc['online'];
      e.visible = userDoc['visible'];

      bool rq = await isRequesting(e.profile.id, connectedUser.profile.id);

      e.tmpRequesting = rq;

      return e;
    });

    yield results;
  }
}
