// import 'package:flutter/material.dart';

class Profile {
  Profile({
    required this.id,
    required this.numero,
    required this.email,
    required this.adress,
    required this.name,
    required this.pseudo,
    required this.sexe,
    required this.date,
    required this.dateins,
    required this.status,
    required this.img,
    required this.facebook,
    required this.instagram,
    required this.linkedin,
    required this.bio,
  });
  String id;
  String numero;
  String email;
  String adress;
  String name;
  String pseudo;
  String sexe;
  String date;
  String dateins;
  String status;
  String img;

  String facebook;
  String instagram;
  String linkedin;
  String bio;
//
  String password = '';
  String confcode = '';
  String countcode = '229';
  String longitude = '';
  String latitude = '';
  String etat = '1';
  String token = "";

  factory Profile.fromJson(Map<String, dynamic> json) {
    Profile tmp = Profile(
      id: json["id"],
      numero: json["numero"],
      email: json["email"],
      adress: json["adress"],
      name: json["name"],
      pseudo: json["pseudo"],
      sexe: json["sexe"],
      date: json["date"],
      dateins: json["dateins"],
      status: json["status"],
      img: json["img"],
      facebook: json["facebook"],
      instagram: json["instagram"],
      linkedin: json["linkedin"],
      bio: json["bio"],
      
    );

    tmp.password = json["password"];
    tmp.confcode = json["confcode"];
    tmp.countcode = json["countcode"];
    tmp.longitude = json["longitude"];
    tmp.latitude = json["latitude"];
    tmp.etat = json["etat"];
    tmp.token = json["token"];

    return tmp;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "numero": numero,
        "email": email,
        "adress": adress,
        "name": name,
        "pseudo": pseudo,
        "sexe": sexe,
        "date": date,
        "dateins": dateins,
        "status": status,
        "img": img,
        "facebook": facebook,
        "instagram": instagram,
        "linkedin": linkedin,
        "bio": bio,
        "password": password,
        "confcode": confcode,
        "countcode": countcode,
        "longitude": longitude,
        "latitude": latitude,
        "etat": etat,
        "token" : token
      };
}

class Message {
  Message({
    required this.id,
    required this.date,
    required this.readState,
    // readState guide
    /* 
      0 - from me & not sent
      1 - from me & sent & receiver not online $$ pending
      2 - from me & sent & reveiver online & receiver not read $$ delivered
      3 - from me & sent & reveiver online & receiver read $$ read

      4 - from receiver & readed
      5 - from receiver & not readed

      6 - reaction from receiver 
      7 - reaction from you 
    */
    // required this.media,
    required this.userId,
    // Media
    required this.type,
// type
    /*
      0 - text
      1 - image
      2 - audio
      3 - video
      4 - file
      5 - contact
      6 - location
      7 - Quick Answer
      8 - Sondage 
    */
    required this.name,
    required this.content,
    required this.size,
    required this.length,
  });
  String id;
  String date;
  String readState;
  // Media media;
  String userId;
  // Media
  String type;
  String name;
  String content;
  String size;
  String length;

  factory Message.fromJson(Map<String, dynamic> json) {
    Message tmp = Message(
      id: json["id"],
      date: json["date"],
      readState: json["readState"],
      userId: json["userId"],
      type: json["type"],
      name: json["name"],
      content: json["content"],
      size: json["size"],
      length: json["length"],
    );

    return tmp;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "readState": readState,
        "userId": userId,
        "type": type,
        "name": name,
        "content": content,
        "size": size,
        "length": length,
      };
}

class Chat {
  Chat({
    required this.id,
    required this.type,
    // type
    /*
      O - Single chat
      1 - Group Chat 
    */
    required this.name,
    required this.unread,
    required this.lastMsg,
    required this.img,
    required this.users,
  });
  String id;
  String type;
  String name;
  String unread;
  Message lastMsg;
  String img;
  List<Message> messages = [];
  List<User> users;
  bool isTyping = false;
  String isTypingTxt = "is typing";

  bool checked = false;
  bool archived = false;
}

class Service {
  Service({
    required this.id,
    required this.nom,
    required this.numordre,
    required this.iddom,
  });
  String id;
  String nom;
  String numordre;
  String iddom;
}

class Notif {
  Notif({
    required this.id,
    required this.userid,
    required this.type,
    required this.content,
    required this.date,
    required this.readState,
    required this.img,
  });
  String id;
  String userid;
  String type;
  String content;
  String date;
  String readState;
  String img;
  // type 0 - friend request - 1  People accepted / rejected friend request - 2 - Friend added to Story - 3 - Fiend readted to a story - 4 -

  factory Notif.fromJson(Map<String, dynamic> json) {
    Notif tmp = Notif(
      id: json["id"],
      userid: json["userid"],
      type: json["type"],
      content: json["content"],
      date: json["date"],
      readState: json["readState"],
      img: json["img"],
    );

    return tmp;
  }
}

class Media0 {
  Media0({
    required this.id,
    required this.type,
// type
    /*
      0 - text
      1 - image
      2 - audio
      3 - video
      4 - file
      5 - contact
      6 - location
      7 - Quick Answer
      8 - Sondage 
    */
    required this.name,
    required this.content,
    required this.date,
    required this.size,
    required this.length,
  });
  String id;
  String type;
  String name;
  String content;
  String date;
  String size;
  String length;
}

class Story {
  Story({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.views,
  });
  String id;
  List<Media0> medias = [];
  String startDate;
  String endDate;
  String views;
}

class Friend {
  Friend({
    required this.friend,
    required this.id,
    required this.date,
  });
  User friend;
  String id;
  String date;
  bool approved = false;
  bool requesting = false;
}

class User {
  User({
    required this.profile,
  });
  Profile profile;
  List<Chat> chats = [];
  List<Notif> notifs = [];
  List<Friend> friends = [];
  List<Story> stories = [];
  //
  bool online = true;
  bool visible = true;
  //
  bool tmpRequesting = false;
}

//
class CState {
  CState({
    required this.id,
    required this.name,
    required this.stateCode,
    required this.phoneCode,
  });
  int id;
  String name;
  String stateCode;
  String phoneCode;
}

class CCity {
  CCity({
    required this.id,
    required this.name,
    required this.stateCode,
    required this.phoneCode,
  });
  int id;
  String name;
  String stateCode;
  String phoneCode;
}

class Exp {
  Exp({
    required this.description,
    required this.pic1,
    required this.pic2,
  });
  String description;
  String pic1;
  String pic2;
}
