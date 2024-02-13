import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {super.key, required this.otherUserEmail, required this.otherName});
  final String otherUserEmail;
  final String otherName;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  var chatRoomID;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isObsecure = false;
  final TextEditingController messageTextController = TextEditingController();
  var userPin;
  Color newBlue = const Color(0xFFC1FAFF);
  Color newPurple = const Color(0xFFC6C1FF);
  Color newOrange = const Color(0xFFFFE5C1);
  @override
  void initState() {
    super.initState();
    List emails = [_auth.currentUser!.email, widget.otherUserEmail];
    emails.sort();
    chatRoomID = '${emails[0]}-${emails[1]}';
    getUserData();
  }

  @override
void dispose() {
  super.dispose();
  _handleDispose();
}

void _handleDispose() async {
  messageTextController.dispose();
  var messages = await _firestore
      .collection('chatrooms')
      .doc(chatRoomID)
      .collection('chats')
      .get();
  for (var message in messages.docs) {
    if (message['obsecured'] == true) {
      await _firestore
          .collection('chatrooms')
          .doc(chatRoomID)
          .collection('chats')
          .doc(message.id)
          .update({'isObsecure': true});
    }
  }
}


  void getUserData() async {
    var data =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    userPin = data['pin'];
    print(userPin);
  }

  void sendMessage() async {
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomID)
        .collection('chats')
        .add({
      'text': messageTextController.text,
      'sender': _auth.currentUser!.displayName,
      'reciever': widget.otherName,
      'time': DateTime.now(),
      'isObsecure': isObsecure,
      'obsecured': isObsecure,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: newBlue,
        appBar: AppBar(
          title: Text(widget.otherName),
          backgroundColor: newPurple,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _firestore
                      .collection('chatrooms')
                      .doc(chatRoomID)
                      .collection('chats')
                      .orderBy('time')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        var alignment =
                            message['sender'] == _auth.currentUser!.displayName
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start;
                        var color =
                            message['sender'] == _auth.currentUser!.displayName
                                ? Colors.blue
                                : Colors.green;
                        var time = message['time'] as Timestamp;
                        var date = time.toDate();
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: alignment,
                              children: [
                                message['isObsecure']
                                    ? GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Enter your pin'),
                                                  content: TextField(
                                                    onChanged: (value) {
                                                      if (value == userPin) {
                                                        setState(() async {
                                                          await _firestore
                                                              .collection(
                                                                  'chatrooms')
                                                              .doc(chatRoomID)
                                                              .collection('chats')
                                                              .doc(message.id)
                                                              .update({
                                                            'isObsecure': false
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                );
                                              });
                                        },
                                        onLongPress: ()async{
                                          if(message['sender'] == _auth.currentUser!.displayName){
                                            showDialog(context: context, builder: (context){
                                              return AlertDialog(
                                                title: const Text('Do you want to delete this message?'),
                                                actions: [
                                                  TextButton(onPressed: ()async{
                                                    await _firestore.collection('chatrooms').doc(chatRoomID).collection('chats').doc(message.id).delete();
                                                    Navigator.pop(context);
                                                  }, child: const Text('Yes')),
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text('No')),
                                                ],
                                              );
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'This message is obsecure',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        message['text'].toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                Text(
                                  date.toString().substring(10, 16),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageTextController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: isObsecure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                    messageTextController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ));
  }
}
