import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Pour vérifier la plateforme
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sweet_chat/utils/classlist.dart' as customClass;
import 'package:sweet_chat/utils/custom.dart';

chargementUser() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  
 
  await firestore
      .collection('user')
      .doc(connectedUser.profile.id)
      .update({'online': true});


  // User
  final userDoc =
      await firestore.collection('user').doc(connectedUser.profile.id).get();

  // Profile
  final profileDoc =
      await firestore.collection('profile').doc(connectedUser.profile.id).get();

  // setState(() {
  connectedUser.online = userDoc.data()!['online'];
  connectedUser.visible = userDoc.data()!['visible'];
  connectedUser.profile = customClass.Profile.fromJson(profileDoc.data()!);
  print("profil data");
  print(profileDoc.data()!);
  // });

  print(connectedUser.profile.toJson());
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Inscription avec Email, Mot de Passe et Pseudo**
  Future<User?> signUp() async {
    try {
      // Crée l'utilisateur avec Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: connectedUser.profile.email,
        password: connectedUser.profile.password,
      );

      connectedUser.profile.id = userCredential.user!.uid;
      connectedUser.profile.countcode = '229';

      // Enregistre les données profile dans Firestore
      await _firestore
          .collection('profile')
          .doc(userCredential.user!.uid)
          .set(connectedUser.profile.toJson());

      DocumentReference profile =
          _firestore.collection('profile').doc(userCredential.user!.uid);

      // Enregistre les données utilisateur dans Firestore
      await _firestore.collection('user').doc(userCredential.user!.uid).set({
        'online': true,
        'profile': profile,
        'visible': true,
        'friends': [],
        'notifs': [],
        'chats': [],
        'stories': []
      });

      return userCredential.user;
    } catch (e) {
      print("Sign Up Error : $e");
      return null;
    }
  }

  /// **Connexion avec Email et Mot de Passe**
  Future<User?> login(String email, String password) async {
    try {
      // Connecte l'utilisateur via Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error : $e");
      return null;
    }
  }

  /// **Connexion ou Inscription avec Google**
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // **Connexion sur le Web**
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        // **Connexion sur Android/iOS**
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          print("Login Cancelled.");
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;

      // Vérifie si l'utilisateur existe déjà dans Firestore
      final userDoc = await _firestore.collection('user').doc(user!.uid).get();

      if (!userDoc.exists) {
        // Crée un document utilisateur pour un nouvel utilisateur Google

        print("Nexiste pas");

        connectedUser.profile = customClass.Profile(
            id: user.uid,
            numero: user.phoneNumber ?? "",
            email: user.email!,
            adress: "",
            name: user.displayName ?? "",
            pseudo: "",
            sexe: "",
            date: "",
            dateins: DateTime.now().toString(),
            status: "",
            img: user.photoURL ?? "",
            facebook: "",
            instagram: "",
            linkedin: "",
            bio: "");

        connectedUser.profile.countcode = '229';

        // Enregistre les données profile dans Firestore
        await _firestore
            .collection('profile')
            .doc(user.uid)
            .set(connectedUser.profile.toJson());

        DocumentReference profile =
            _firestore.collection('profile').doc(user.uid);

        // Enregistre les données utilisateur dans Firestore
        await _firestore.collection('user').doc(user.uid).set({
          'online': true,
          'profile': profile,
          'visible': true,
          'friends': [],
          'notifs': [],
          'chats': [],
          'stories': []
        });
      } else {
        //
        //      await login(
        //   user.email!,
        //   user.,
        // );
      }

      return user;
    } catch (e) {
      print("Google Log In error : $e");
      return null;
    }
  }

  // **Déconnexion**
  Future<void> logout(BuildContext context) async {
    await _firestore
        .collection('user')
        .doc(connectedUser.profile.id)
        .update({'online': false});
    try {
      await _auth.signOut();
      //  ouvrirR(context, Sign());
      connectedUser = customClass.User(
          profile: customClass.Profile(
              id: '',
              numero: '',
              email: '',
              adress: "",
              name: "New User",
              pseudo: "",
              sexe: "",
              date: "",
              dateins: "",
              status: "",
              img: "",
              facebook: "",
              instagram: "",
              linkedin: "",
              bio: ""));
      // fermer(context);
    } catch (e) {
      print("Log Out Error : $e");
    }
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crée une nouvelle discussion entre deux utilisateurs
  Future<String?> createDiscussion(String uid1, String uid2) async {
    try {
      // Vérifie si une discussion existe déjà
      final querySnapshot = await _firestore
          .collection('Discussions')
          .where('participants', arrayContains: uid1)
          .get();

      for (var doc in querySnapshot.docs) {
        final participants = doc['participants'] as List;
        if (participants.contains(uid2)) {
          // Retourne l'ID de la discussion existante
          return doc.id;
        }
      }

      // Crée une nouvelle discussion si aucune n'existe
      final discussionId = _firestore.collection('Discussions').doc().id;

      await _firestore.collection('Discussions').doc(discussionId).set({
        "id": discussionId,
        "participants": [uid1, uid2],
        "messages": [],
        "lastMessage": "",
        "timestamp": FieldValue.serverTimestamp(),
      });

      return discussionId;
    } catch (e) {
      print("Erreur lors de la création de la discussion : $e");
      return null;
    }
  }
}
