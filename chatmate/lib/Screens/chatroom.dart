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
  @override
  void initState() {
    super.initState();
    List emails = [_auth.currentUser!.email, widget.otherUserEmail];
    emails.sort();
    chatRoomID = '${emails[0]}-${emails[1]}';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.otherName),
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
                        return Card(
                          color: color,
                          child: Column(
                            crossAxisAlignment: alignment,
                            children: [
                              Text(
                                message['sender'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(),
                              message['isObsecure']?
                                GestureDetector(
                                  onDoubleTap: (){
                                    
                                  },
                                  child: const Text(
                                    'This message is obsecure',
                                    style:  TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ):
                              Text(
                                message['text'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                date.toString().substring(10,16),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
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
                        )
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed:(){
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: isObsecure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
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
