import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chat_app/domain/entity/message.dart';

class ChatService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    final String currentUserID = _auth.currentUser!.uid;

    return _firestore.collection("chat_rooms").snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> usersWithChat = [];

      for (var chatRoomDoc in snapshot.docs) {
        // Получаем идентификаторы участников чата
        var members = List<String>.from(chatRoomDoc['members'] ?? []);
        if(members.contains(currentUserID)){
          members.remove(currentUserID); // Убираем текущего пользователя
        }else{
          members.clear();
          members.add(currentUserID);
        }
        // Получаем информацию о других участниках из коллекции "Users"
        for (var otherUserID in members) {
          var userDoc = await _firestore.collection("Users").doc(otherUserID).get();
          if (userDoc.exists) {
            usersWithChat.add(userDoc.data()!);
          }
        }
      }

      return usersWithChat;
    });
  }



  String getChatRoomID(String userID1, String userID2) {
    List<String> ids = [userID1, userID2];
    ids.sort();
    return ids.join('_');
  }

  Stream<List<Map<String,dynamic>>> getAllUsers(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }


  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Use a transaction to ensure atomicity
    await _firestore.runTransaction((transaction) async {
      // Check if the members collection already exists
      var chatRoomRef = _firestore.collection("chat_rooms").doc(chatRoomID);
      var membersDoc = await transaction.get(chatRoomRef);

      if (!membersDoc.exists) {
        // If members collection doesn't exist, create it
        transaction.set(chatRoomRef, {
          'members': [currentUserID, receiverID],
        });
      } else {
        // If members collection exists, check and add new IDs
        var currentMembers = membersDoc['members'].cast<String>();
        if (!currentMembers.contains(currentUserID)) {
          currentMembers.add(currentUserID);
        }
        if (!currentMembers.contains(receiverID)) {
          currentMembers.add(receiverID);
        }

        // Update the members collection with the modified user IDs
        transaction.update(chatRoomRef, {
          'members': currentMembers,
        });
      }

      // Add the new message to the messages collection
      transaction.set(chatRoomRef.collection("messages").doc(), newMessage.toMap());
    });
  }


  Stream<QuerySnapshot> getMessages(String userId, otherUserID){
    List<String> ids = [userId,otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();
  }

  Future<void> deleteMessage(String userId, otherUserID, String messageID) async {
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID)
        .delete();
  }

}