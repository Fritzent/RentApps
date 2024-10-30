import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rent_apps/models/chat.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../sources/chat_source.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key, required this.uid, required this.userName});
  final String uid;
  final String userName;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final edtInputChat = TextEditingController();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> streamChats;

  String formatTimeStamp(Timestamp timestamp) {
    return DateFormat('HH:mm a d MMM yyyy').format(timestamp.toDate());
  }
  String formatTimeStampCs(Timestamp timestamp) {
    return DateFormat('d MMM yyyy HH:mm a').format(timestamp.toDate());
  }

  backPage() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    streamChats = FirebaseFirestore.instance.collection('Cs').doc(widget.uid).collection('Chats').orderBy('timestamp', descending: true).snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          children: [
            Gap(30 + MediaQuery.of(context).padding.top),
            buildHeader(),
            Expanded(
              child: buildChats(),
            ),
            buildInputChat(),
          ],
        ),
      ),
    );
  }
  Widget buildSnippetBike(Map bike){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ExtendedImage.network(
            bike['image'],
            height: 70,
            width: 90,
            fit: BoxFit.contain,
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bike['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff070623),
                  ),
                ),
                const Gap(4),
                  Text(
                    bike['category'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff838384),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/detail', arguments: bike['id']);
            },
            child: const Text(
              'Details',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decorationThickness: 1,
                decoration: TextDecoration.underline,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff4a1dff),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget chatUsers(Chat chat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end ,
      children: [
        if (chat.bikeDetail != null) Column(
          children: [
            const Gap(16),
            buildSnippetBike(chat.bikeDetail!),
            const Gap(16),
            const  DottedLine(
              dashColor: Color(0xffceced5),
              lineThickness: 1,
              dashLength: 6,
              dashGapLength: 6,
            ),
            const Gap(16),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff070623),
                ),
              ),
              const Gap(4),
              Text(
                chat.timestamp == null ? '' :  formatTimeStamp(chat.timestamp!),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff070623),
                ),
              ), 
            ],
          ),
        ), 
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff070623),
              ),
            ),
            const Gap(8),
            Image.asset(
               'assets/chat_profile.png',
               width: 40,
               height: 40,
            ),
          ],
        ),
        const Gap(8),
      ],
    );
  }
  Widget chatCs(Chat chat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start ,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xff070623),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Gap(4),
              Text(
                chat.timestamp == null ? '' :  formatTimeStampCs(chat.timestamp!),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ), 
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
               'assets/chat_cs.png',
               width: 40,
               height: 40,
            ),
            const Gap(8),
            const Text(
              'Admin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff070623),
              ),
            ),
          ],
        ),
        const Gap(8),
      ],
    );
  }
  Widget buildChats() {
    return StreamBuilder(
      stream: streamChats , 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Chats'));
        }
        
        final list = snapshot.data!.docs;
        return ListView.builder(
          reverse:  true,
          padding: const EdgeInsets.only(top: 16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            Chat chat = Chat.fromJson(list[index].data());
            if (chat.senderId == 'cs') {
              return chatCs(chat);
            }
            return chatUsers(chat);
          },
         );
      },
    );
  }
  Widget buildInputChat() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 24),
      padding: const EdgeInsets.only(left: 16),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48)
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: edtInputChat,
              style: const TextStyle(
                color: Color(0xff070623),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                border: InputBorder.none,
                hintText: 'Message....',
                hintStyle: TextStyle(
                  color: Color(0xff070623),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
              ),
            ),
          ),
          IconButton(
            onPressed: (){
              Chat chat = Chat(
                roomId: widget.uid, 
                message: edtInputChat.text, 
                receiverId: 'cs', 
                senderId: widget.uid,
                bikeDetail: null,
              );
              String uid = widget.uid;
              ChatSource.sendChat(chat, uid).then((responseSendChat) {edtInputChat.clear(); });
            }, 
            icon: Image.asset(
              'assets/ic_send.png',
              height: 24,
              width: 24,
            )
          ),
        ],
      ),
    );
  }
  Widget buildHeader(){
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            backPage();
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: UnconstrainedBox(
              child: Image.asset(
                'assets/ic_arrow_back.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Customer Service',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:  Color(0xff070623),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            backPage();
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: UnconstrainedBox(
              child: Image.asset(
                'assets/ic_more.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}