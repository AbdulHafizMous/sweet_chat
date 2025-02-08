// import 'package:flutter/material.dart';

class Docs {
  Docs({
    required this.name,
    required this.filepath,
    required this.demopics,
    required this.stat,
  });
  String name;
  String filepath;
  List<String> demopics;
  String stat;
  
}


class Profile {
  Profile({
    required this.number,
    required this.mail,
    required this.adress,
    required this.name,
    required this.fgname,
    required this.sex,
    required this.born,
    required this.idactivity,
    required this.idcard1,
    required this.idcard2,
    required this.pic,
    required this.descr,
    required this.note,
    required this.level,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.linkedin,
    required this.location,
    required this.tokken,
  });
  String number;
  String mail;
  String adress;
  String name;
  String fgname;
  String sex;
  DateTime born;
  String idactivity;
  String idcard1;
  String idcard2;
  String pic;
  String descr;
  double note;
  double level;
  String facebook;
  String instagram;
  String twitter;
  String linkedin;
  String location;
  String tokken;
}

class Exp {
  Exp({
    required this.number,
    required this.subject,
    required this.pic1,
    required this.pic2,
    required this.mov,
  });
  String number;
  String subject;
  String pic1;
  String pic2;
  String mov;
}

class Hour {
  Hour({
    required this.number,
    required this.day,
    required this.start,
    required this.end,
  });
  String number;
  String day;
  DateTime start;
  DateTime end;
}

class Activity {
  Activity({
    required this.idsector,
    required this.libsector,
    required this.idactivity,
    required this.libactivity,
  });
  String idsector;
  String libsector;
  String idactivity;
  String libactivity;
}

class User {
  User({
    required this.profile,
    required this.exp,
    required this.hour,
  });
  Profile profile;
  Exp exp;
  Hour hour;
}

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
