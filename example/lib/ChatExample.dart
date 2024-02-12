import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chatui;
import 'package:uuid/uuid.dart';
import 'package:generate_ai_dart/generate_ai_dart.dart';

import 'data.dart';


extension on types.TextMessage{

  Content toContent() {
    return content(init: (builder){
         builder.text(text);
    });
  }
}
class ChatPage extends StatefulWidget {

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  final _model = const types.User(
      id :  "e52552f4-835d-4dbe-ba77-b076e659774d",
      firstName: "model"
      );
  final config = generationConfig((builder) {
    builder.temperature = 0.7;
  });


  late GenerativeModel model ;
  late Chat chat ;


  @override
  void initState() {
    super.initState();
    _loadMessages();
    model = GenerativeModel(Model.geminiPro, key, generationConfig: config);

    chat = model.startChat( history:   [] );
  }





  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }


  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

   final res =  await chat.sendMessageText(message.text);



    _addMessage(textMessage);
   _addMessage(types.TextMessage(
     author: _model,
     createdAt: DateTime.now().millisecondsSinceEpoch,
     id: const Uuid().v4(),
     text: res.text??"",
   ));


  }



  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>)).
        toList().reversed.toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: chatui.Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      showUserAvatars: true,
      showUserNames: true,
      user: _user,
      theme: const chatui.DefaultChatTheme(
        seenIcon: null,
        deliveredIcon: null,
      ),
    ),
  );
}


