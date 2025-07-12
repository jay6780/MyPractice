import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:mypractice_flutter/AI.dart';
import 'package:mypractice_flutter/HexColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chatmsg.dart';
import 'DioApi.dart';

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  @override
  Chathome createState() => Chathome();
}

class Chathome extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadChatMessages();
  }

  var logger = Logger();
  List<Chatmsg> chatmessagelist = [];
  String query = "";
  String response = "";
  String botMessage = "";
  bool isdev = true;
  String content = "";
  Ai? aiResponse;
  Dioapi dioapi = Dioapi();
  final TextEditingController _queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    logger.d("Home chat!");
    return MaterialApp(
        home: Scaffold(
      backgroundColor: HexColor("#ffffff"),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor("#78B9B5"),
        title: const Text('ChatAi',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: chatmessagelist.length,
                    itemBuilder: (context, index) {
                      final message = chatmessagelist[index];
                      return GestureDetector(
                        child: Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            color: message.isUser
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: message.message.isEmpty
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.black,
                                      size: 20,
                                    )
                                  : Text(
                                      message.message,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _queryController,
                      onChanged: (value) {
                        query = value;
                      },
                      decoration: const InputDecoration(
                          labelText: "Enter Prompt",
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                  InkWell(
                    onTap: () => _askBot(),
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send, color: Colors.black),
                            SizedBox(width: 8),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _askBot() async {
    if (query.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter prompt",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: HexColor('#000000'),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      chatmessagelist.insert(0, Chatmsg(true, query));
      chatmessagelist.insert(0, Chatmsg(false, ""));
      _queryController.clear();
    });
    saveChatMessages();
    aiResponse = await dioapi.askAi(query);

    setState(() {
      chatmessagelist.removeAt(0);
      if (aiResponse != null) {
        chatmessagelist.insert(0, Chatmsg(false, aiResponse!.content));
      } else {
        chatmessagelist.insert(
            0, Chatmsg(false, "Failed to get response from server."));
      }
    });
    saveChatMessages();
  }

  Future<void> saveChatMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded =
        chatmessagelist.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList('chat_messages', encoded);
  }

  Future<void> loadChatMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList('chat_messages');
    if (encoded != null) {
      setState(() {
        chatmessagelist =
            encoded.map((msg) => Chatmsg.fromJson(jsonDecode(msg))).toList();
      });
    }
  }
}
