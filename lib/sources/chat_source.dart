import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rent_apps/models/chat.dart';

class ChatSource {
  static Future<void> openChatRoom(String uid, String userName) async {
    final doc = await FirebaseFirestore.instance.collection('Cs').doc(uid).get();
    if (doc.exists) {
      await FirebaseFirestore.instance.collection('Cs').doc(uid).update({
        'newMessageFromCs' : false,
      });
      return;
    }

    /* If new In Chat */
    await  FirebaseFirestore.instance.collection('Cs').doc(uid).set({
      'roomId' : uid,
      'name' : userName,
      'lastMessage' : 'Welcome to Rentbike',
      'newMessageFromCs' : true,
      'newMessageFromUser' : false,
    });
    /* Generate Chats Collection */

    /* If its not using external data can use code below */
    // Chat initializeChat = Chat(
    //   roomId: uid, 
    //   message: 'Welcome to Rentbike', 
    //   receiverId: uid, 
    //   senderId: 'cs',
    //   bikeDetail: null,
    // );
    //await FirebaseFirestore.instance.collection('Cs').doc(uid).collection('Chats').add(initializeChat.toJson());

    await FirebaseFirestore.instance.collection('Cs').doc(uid).collection('Chats').add({
      'roomId': uid, 
      'message': 'Welcome to Rentbike', 
      'receiverId': uid, 
      'senderId': 'cs',
      'bikeDetail': null,
      'timestamp' : FieldValue.serverTimestamp(),
    });
  }

  static Future<void> sendChat(Chat chat, String uid) async {
    await FirebaseFirestore.instance.collection('Cs').doc(uid).update({
        'newMessageFromCs' : false,
        'newMessageFromUser' : true,
        'lastMessage' : chat.message,
      });
    await FirebaseFirestore.instance.collection('Cs').doc(uid).collection('Chats').add({
      'roomId': chat.roomId, 
      'message': chat.message, 
      'receiverId': chat.receiverId, 
      'senderId': chat.senderId,
      'bikeDetail': chat.bikeDetail,
      'timestamp' : FieldValue.serverTimestamp(),
    });
  } 
}