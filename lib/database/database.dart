
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistic/models/login.dart';
import 'package:twistic/models/twistic.dart';
import 'package:twistic/services/services.dart';

final CollectionReference _tweetsCollectionReference = FirebaseFirestore.instance.collection('Tweets');
final CollectionReference _usersCollectionReference = FirebaseFirestore.instance.collection('Users');

addTweet(Twistic twistic){
  twistic.writtenDate = Timestamp.now().toDate();
  return _tweetsCollectionReference.add({
    'pseudo': twistic.pseudo,
    'contenu': twistic.contenu,
    'urlPhoto': twistic.urlPhoto,
    'writtenDate': twistic.writtenDate,
  });
}

Stream<QuerySnapshot> getTweetsStream(){
  return _tweetsCollectionReference.orderBy("writtenDate", descending: true).snapshots();
}