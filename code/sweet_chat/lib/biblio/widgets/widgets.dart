

import 'package:flutter/material.dart';

import '../../utils/myclass.dart';



Widget menu(BuildContext context, Profile user){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
    borderRadius: BorderRadius.circular(10),
      onTap: () {
      
    }, child: Container(
      padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color.fromARGB(255, 238, 246, 245) /* gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.transparent, Colors.amberAccent]) */),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      const Expanded( flex: 0,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CircleAvatar(radius: 15, child: Icon(Icons.person_3_outlined),),
           SizedBox(height: 5,),
          Text('Picture', textAlign: TextAlign.center,)
        ],),
      ),
      // 
      // 
      Expanded( flex: 1,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom:5.0),
            child: Text('${user.fgname} ${user.name}'),
          ),
          Text(user.instagram),
        ],),
      )
    ],),),),
  );
}
