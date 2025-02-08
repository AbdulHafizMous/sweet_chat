import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sweet_chat/notification_service.dart';
import 'package:sweet_chat/pages/profilanyuser.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/loading/src2/four_rotating_dots/four_rotating_dots.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:chatview/chatview.dart';
import 'package:sweet_chat/utils/classlist.dart' as myclass;
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChatContent extends StatefulWidget {
  const ChatContent({super.key, required this.chat});
  final myclass.Chat chat;

  @override
  // ignore: library_private_types_in_public_api
  _ChatContentState createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  bool loading = false;
  FirebaseFirestore fins = FirebaseFirestore.instance;

  late myclass.Chat chatVar;

  List<String> existingMessageIds = [];
  bool typing = false;

  List<StreamSubscription?> _fsubLst = [];

  late ChatController _chatController;

  void _showHideTypingIndicator(bool val) {
    _chatController.setTypingIndicator = val;
    typing = val;
  }

  // void receiveMessage() async {
  //   _showHideTypingIndicator();
  //   await Future.delayed(const Duration(milliseconds: 1900));
  //   _showHideTypingIndicator();
  //   // _chatController.addMessage(
  //   //   Message(
  //   //     id: DateTime.now().toString(),
  //   //     message: 'I will schedule the meeting.',
  //   //     createdAt: DateTime.now(),
  //   //     sentBy: 'gjC4zNYI5YVlo3bZ5coJYqgipnR2',
  //   //   ),
  //   // );
  //   // await Future.delayed(const Duration(milliseconds: 500));
  //   // _chatController.addReplySuggestions([
  //   //   const SuggestionItemData(text: 'Thanks.'),
  //   //   const SuggestionItemData(text: 'Thank you very much.'),
  //   //   const SuggestionItemData(text: 'Great.')
  //   // ]);
  //   // setState(() {});
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      existingMessageIds.clear;
      chatVar = widget.chat;
    });

    print("Id Pro du chat : ${chatVar.id}");

    init();

    if (chatVar.id.isNotEmpty) {
      // _loadMessages(chatVar.id);
      _listenForMessages(chatVar.id);
      _listenForTyping(chatVar.id);
    }
  }

  test() async {
    _chatController.addMessage(Message(
      id: "01",
      message: "path_pro",
      createdAt: DateTime.now(),
      sentBy: connectedUser.profile.id,
      messageType: MessageType.text,
      status: MessageStatus.read,
    ));

    print("Adding");

    String path_pro = await _downloadAudio(
        "https://outilsco.com/api_outilsco/public/upload/tmp_docs/07-02-25-06-57-525643009955123516917.m4a");

    print("path_pro !: *$path_pro");
    _chatController.addMessage(Message(
      id: "1",
      message: path_pro,
      createdAt: DateTime.now(),
      sentBy: connectedUser.profile.id,
      messageType: path_pro.isEmpty ? MessageType.text : MessageType.voice,
      status: MessageStatus.read,
    ));
    // setState((){});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var _fsub in _fsubLst) {
      _fsub?.cancel();
    }

    end();
  }

  end() async {
    if (chatVar.id.isNotEmpty) {
      await fins.collection('chat').doc(chatVar.id).update({'unread': "0"});
    }
  }

  /*  Future<void> _loadMessages(String chatId) async {
    final chatDoc = await fins.collection('chat').doc(chatId).get();
    final messageRefs = List<DocumentReference>.from(chatDoc.get('messages'));

    for (final ref in messageRefs) {
      if (!existingMessageIds.contains(ref.id)) {
        final messageDoc = await ref.get();
        _addMessageToChatView(messageDoc);
        existingMessageIds.add(ref.id);
      }
    }
  }
 */

  void _listenForMessages(String chatId) {
    final sub = fins
        .collection('chat')
        .doc(chatId)
        .snapshots()
        .listen((snapshot) async {
      final updatedChatDoc = snapshot.data() as Map<String, dynamic>;

      // Récupérer les nouveaux messages (ceux qui n'étaient pas dans le cache)
      final newMessageRefs =
          List<DocumentReference>.from(updatedChatDoc['messages']);
      // final existingMessageIds =
      //     _chatController.initialMessageList.map((m) => m.id).toList();

      for (final ref in newMessageRefs) {
        if (!existingMessageIds.contains(ref.id)) {
          existingMessageIds.add(ref.id);
          print(existingMessageIds.toString());
          final messageDoc = await ref.get();
          await _addMessageToChatView(messageDoc);
        }
      }
    });
    _fsubLst.add(sub);
  }

  void _listenForTyping(String chatId) {
    final sub =
        fins.collection('chat').doc(chatId).snapshots().listen((snapshot) {
      final chatData = snapshot.data() as Map<String, dynamic>;
      _showHideTypingIndicator(chatData['isTyping']);
      // setState(() {

      // });
    });

    _fsubLst.add(sub);
  }

  _addMessageToChatView(DocumentSnapshot messageDoc) async {
    final messageData = messageDoc.data() as Map<String, dynamic>;
    myclass.Message e = myclass.Message.fromJson(messageData);

    String path_pro = e.content;

    if (e.type == "2") {
      path_pro = await _downloadAudio(path_pro);
    }

    final message = Message(
      id: e.id,
      message: path_pro,
      createdAt: DateTime.parse(e.date),
      sentBy: e.userId,
      messageType: e.type == "2"
          ? MessageType.voice
          : e.type == "1"
              ? MessageType.image
              : MessageType.text,
      status: e.readState == "1"
          ? MessageStatus.pending
          : e.readState == "2"
              ? MessageStatus.delivered
              : e.readState == "3"
                  ? MessageStatus.read
                  : MessageStatus.undelivered,
    );
    // = Message(
    //     message: messageData['content'],
    //     createdAt: DateTime.parse(messageData['date']),
    //     sentBy: messageData['userId']);
    _chatController.addMessage(message);
  }

  Future<String> _downloadAudio(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        print(
            'Erreur lors du téléchargement de l\'audio : ${response.statusCode}');
        return "";
      }
    } catch (e) {
      print('Erreur lors du téléchargement de l\'audio : $e');
      return "";
    }
  }

  init() async {
    setState(() {
      _chatController = ChatController(
        initialMessageList: [],
        // chatVar.messages
        //     .map(
        //       (e) => Message(
        //           message: e.content,
        //           createdAt: DateTime.parse(e.date),
        //           sentBy: e.userId),
        //     )
        //     .toList(),
        scrollController: ScrollController(),
        currentUser: ChatUser(
          id: connectedUser.profile.id,
          name: connectedUser.profile.name,
          profilePhoto: connectedUser.profile.img.isEmpty
              ? "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg"
              : connectedUser.profile.img,
        ),
        otherUsers: chatVar.users
            .map(
              (e) => ChatUser(
                id: e.profile.id,
                name: e.profile.name,
                profilePhoto: e.profile.img.isEmpty
                    ? "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg"
                    : e.profile.img,
              ),
            )
            .toList(),
      );
    });

    //  test();

    if (chatVar.id.isNotEmpty) {
      final chatLst = await fins.collection('chat').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> ch in chatLst.docs) {
        // ch.
        String toChk = chatVar.id;
        if (toChk.split("_").length != 1) {
          toChk = toChk.split("_")[0];
        }
        print("Un chat id : ${ch.id}  ----- actual : ${toChk}");

        if (ch.id.contains(toChk)) {
          await fins
              .collection('chat')
              .doc(ch.id)
              .update({'unread': "0", 'isTyping': false});
        }
      }

      final chat = await fins.collection('chat').doc(chatVar.id).get();

      final lstMsg = await fins.doc(chat.data()!["lastMsg"].path).get();

      if (lstMsg.data()!["userId"] != connectedUser.profile.id) {
        await lstMsg.reference.update({"readState": "3"});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      child: Scaffold(
          body:

              //  StreamBuilder<myclass.Chat?>(
              //     stream:
              //         // FirebaseFirestore.instance.collection('user').snapshots(),
              //         _getInfos(),
              //     builder: (context, notifSnapshot) {
              //       //
              //       ChatViewState chatVState = ChatViewState.noData;

              //       //
              //       if (notifSnapshot.connectionState == ConnectionState.waiting) {
              //         chatVState = ChatViewState.loading;
              //       }

              //       if (notifSnapshot.hasError) {
              //         chatVState = ChatViewState.error;
              //         print("Loading Error ! ${notifSnapshot.error}");
              //       }

              //       if (notifSnapshot.data != null) {
              //         final chat = notifSnapshot.data!;

              //         // Vérifier le type et letat du message

              //         chatVState = ChatViewState.hasMessages;

              //         print("Avant : ${_chatController.initialMessageList.length}");

              //         _chatController.initialMessageList.clear();
              //         for (myclass.Message e in chat.messages) {
              //           Message tmp = Message(
              //             id: e.id,
              //             message: e.content,
              //             createdAt: DateTime.parse(e.date),
              //             sentBy: e.userId,
              //             messageType: e.type == "2"
              //                 ? MessageType.voice
              //                 : e.type == "1"
              //                     ? MessageType.image
              //                     : MessageType.text,
              //             status: e.readState == "1"
              //                 ? MessageStatus.pending
              //                 : e.readState == "2"
              //                     ? MessageStatus.delivered
              //                     : e.readState == "3"
              //                         ? MessageStatus.read
              //                         : MessageStatus.undelivered,
              //           );
              //           _chatController.addMessage(tmp);
              //         }

              //         print("Apres : ${_chatController.initialMessageList.length}");
              //       }

              //       print("State : $chatVState");

              //       return

              ChatView(
        // loadMoreData: () async {
        //   return;
        // },
        chatController: _chatController,
        loadingWidget: Center(child: Text('Just a minute ! ')),
        // sendMessageBuilder: (replyMessage) {
        //   return Container();
        // },
        onSendTap: _onSendTap,
        featureActiveConfig: const FeatureActiveConfig(
            enableReplySnackBar: false,
            enableDoubleTapToLike: false,
            enablePagination: true,
            enableReactionPopup: false,
            enableSwipeToReply: false,
            lastSeenAgoBuilderVisibility: true,
            receiptsBuilderVisibility: true,
            enableScrollToBottomButton: true,
            enableOtherUserName: false,
            enableOtherUserProfileAvatar: false),
        scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
          backgroundColor: theme.textFieldBackgroundColor,
          border: Border.all(
            color: isDarkTheme ? Colors.transparent : Colors.grey,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.themeIconColor,
            weight: 10,
            size: 30,
          ),
        ),
        chatViewState:
            // chatVState,
            chatVar.id.isEmpty
                ? ChatViewState.noData
                : ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FourRotatingDots(
                    color: theme.outgoingChatBubbleColor!, size: 80),
                SizedBox(
                  height: 15,
                ),
                Text(
                  ".. Loading ..",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          noMessageWidgetConfig: ChatViewStateWidgetConfiguration(
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.query_stats_outlined,
                  size: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Nothing to Show !",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          indicatorSize: 7,
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatViewAppBar(
          elevation: theme.elevation,
          backGroundColor: theme.appBarColor,
          profilePicture: chatVar.img,
          backArrowColor: theme.backArrowColor,
          chatTitle: chatVar.name,
          chatTitleTextStyle: TextStyle(
            color: theme.appBarTitleTextStyle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.25,
          ),
          userStatus: _chatController.showTypingIndicator
              ? chatVar.isTypingTxt
              : chatVar.users[0].online
                  ? "online"
                  : "offline",
          userStatusTextStyle: const TextStyle(color: Colors.grey),
          actions: [
            // IconButton(
            //   onPressed: _onThemeIconTap,
            //   icon: Icon(
            //     isDarkTheme
            //         ? Icons.brightness_4_outlined
            //         : Icons.dark_mode_outlined,
            //     color: theme.themeIconColor,
            //   ),
            // ),
            // IconButton(
            //   tooltip: 'Toggle TypingIndicator',
            //   onPressed: _showHideTypingIndicator,
            //   icon: Icon(
            //     Icons.keyboard,
            //     color: theme.themeIconColor,
            //   ),
            // ),
            // IconButton(
            //   tooltip: 'Simulate Message receive',
            //   onPressed: receiveMessage,
            //   icon: Icon(
            //     Icons.supervised_user_circle,
            //     color: theme.themeIconColor,
            //   ),
            // ),
            IconButton(
              tooltip: 'View Profil',
              onPressed: () {
                ouvrirO(
                    context,
                    AnyUserProfil(
                      user: chatVar.users[0],
                    ));
              }, // receiveMessage,
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: theme.themeIconColor,
              ),
            ),
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          // record disabled
          allowRecordingVoice: true,
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) async {
              /// Do with status
              ///
              if (chatVar.id.isNotEmpty) {
                final chatLst = await fins.collection('chat').get();

                for (QueryDocumentSnapshot<Map<String, dynamic>> ch
                    in chatLst.docs) {
                  // ch.
                  String toChk = chatVar.id;
                  if (toChk.split("_").length != 1) {
                    toChk = toChk.split("_")[0];
                  }
                  print("Un chat id : ${ch.id}  ----- actual : ${toChk}");

                  if (ch.id.contains(toChk) && ch.id != chatVar.id) {
                    await fins.collection('chat').doc(ch.id).update({
                      'isTyping': status == TypeWriterStatus.typing,
                    });
                  }
                }
              }
              print("Status : $status");
              debugPrint(status.toString());
            },
            compositionThresholdTime: const Duration(seconds: 2),
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          micIconColor: theme.replyMicIconColor,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: theme.waveformBackgroundColor,
            recorderIconColor: theme.recordIconColor,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: theme.waveColor ?? Colors.white,
              extendWaveform: true,
              // showDurationLabel: true,
              // showHourInDuration: true
            ),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              debugPrint('Message Read');
            },
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: theme.replyPopupColor,
          buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
        ),
        messageConfig: MessageConfiguration(
          // voiceMessageConfig: VoiceMessageConfiguration(

          // ),
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.messageReactionBackGroundColor,
            borderColor: theme.messageReactionBackGroundColor,
            reactedUserCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: theme.backgroundColor,
              reactedUserTextStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: theme.inComingChatBubbleColor,
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(
                defaultIconBackgroundColor: theme.shareIconBackgroundColor,
                defaultIconColor: theme.shareIconColor,
                icon: Container()),
          ),
        ),
        // profileCircleConfig: ProfileCircleConfiguration(
        //   profileImageUrl: _chatController.currentUser.profilePhoto,
        // ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.repliedMessageColor,
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
        replySuggestionsConfig: ReplySuggestionsConfig(
          itemConfig: SuggestionItemConfig(
            decoration: BoxDecoration(
              color: theme.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.outgoingChatBubbleColor ?? Colors.white,
              ),
            ),
            textStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          onTap: (item) =>
              _onSendTap(item.text, const ReplyMessage(), MessageType.text),
        ),
      )

          //   ;
          // }),

          //
          //

          //
          //
          ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    if (messageType == MessageType.image) {
      await _saveImg(message, replyMessage, messageType);
      //
    } else if (messageType == MessageType.voice) {
      await _saveAudio(message, replyMessage, messageType);
      //
    } else {
      await _saveText(message, replyMessage, messageType);
      //
    }
  }

  _saveText(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    if (chatVar.id.isEmpty) {
      String uid = DateTime.now().microsecondsSinceEpoch.toString();
      //
      String vDate = DateTime.now().toString();
      await fins.collection('message').doc(uid).set({
        "id": uid,
        "date": vDate,
        "readState": chatVar.users[0].online ? "2" : "1",
        "userId": _chatController.currentUser.id,
        "type": "0",
        "name": "message_name",
        "content": message,
        "size": "",
        "length": "",
      });
      // Creéer le msg
      DocumentReference lastMsg = fins.collection('message').doc(uid);

      // Chez Moi

      DocumentReference user =
          fins.collection('user').doc(chatVar.users[0].profile.id);

      await fins.collection('chat').doc(uid).set({
        'id': uid,
        'type': "0",
        'name': chatVar.users[0].profile.name,
        'unread': "0",
        'lastMsg': lastMsg,
        'img': chatVar.users[0].profile.img,
        'messages': [lastMsg],
        'users': [user],
        'isTyping': false,
        'isTypingTxt': "is typing",
        'checked': false,
        'archived': false
      });
      //
      DocumentReference chat2 = fins.collection('chat').doc(uid);
      await fins.collection('user').doc(_chatController.currentUser.id).update({
        'chats': FieldValue.arrayUnion([chat2]),
      });

      // Chez L'autre

      DocumentReference userMe =
          fins.collection('user').doc(_chatController.currentUser.id);

      final docOther =
          await fins.collection("user").doc(chatVar.users[0].profile.id).get();

      final chatsOther = docOther.data()!['chats'] ?? [];

      bool found = false;

      for (var chO in chatsOther) {
        DocumentSnapshot chatO = await chO.get();
        Map<String, dynamic>? chatOData = chatO.data() as Map<String, dynamic>?;
        List usrsO = chatOData!['users'] ?? [];
        print("chatOData : $chatOData");
        if ((chatOData['type'] == "0") && (usrsO.contains(userMe))) {
          print("found");
          await fins.collection('chat').doc(chatO.id).update({
            'lastMsg': lastMsg,
            'messages': FieldValue.arrayUnion([lastMsg]),
          });
          found = true;
        }
      }

      print("final found : $found");

      if (!found) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      }

      /*  final docsCh = await fins
          .collection("chat")
          .where("type", isEqualTo: "0")
          .where("users", arrayContainsAny: [userMe]).get();

          print("Autres Chats ou type est 0 et users = [moi] : ${docsCh.docs.length}");

      if (docsCh.docs.isEmpty) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      } else {
        final doc = docsCh.docs[0];

        await fins.collection('chat').doc(doc.id).update({
          'lastMsg': lastMsg,
          'messages': FieldValue.arrayUnion([lastMsg]),
        });
        //
      } */

      setState(() {
        chatVar.id = uid;
        // _loadMessages(chatVar.id);
        _listenForMessages(chatVar.id);
        _listenForTyping(chatVar.id);
      });
    } else {
      String uid = DateTime.now().microsecondsSinceEpoch.toString();
      //
      String vDate = DateTime.now().toString();
      await fins.collection('message').doc(uid).set({
        "id": uid,
        "date": vDate,
        "readState": chatVar.users[0].online ? "2" : "1",
        "userId": _chatController.currentUser.id,
        "type": "0",
        "name": "message_name",
        "content": message,
        "size": "",
        "length": "",
      });
      // Creéer le msg
      DocumentReference lastMsg = fins.collection('message').doc(uid);

      // Chez Moi

      await fins.collection('chat').doc(chatVar.id).update({
        'lastMsg': lastMsg,
        'messages': FieldValue.arrayUnion([lastMsg]),
      });
      //

      // Chez L'autre

      DocumentReference userMe =
          fins.collection('user').doc(_chatController.currentUser.id);

      final docOther =
          await fins.collection("user").doc(chatVar.users[0].profile.id).get();

      final chatsOther = docOther.data()!['chats'] ?? [];

      bool found = false;

      for (var chO in chatsOther) {
        DocumentSnapshot chatO = await chO.get();
        Map<String, dynamic>? chatOData = chatO.data() as Map<String, dynamic>?;
        List usrsO = chatOData!['users'] ?? [];
        print("chatOData : $chatOData");
        if ((chatOData['type'] == "0") && (usrsO.contains(userMe))) {
          print("found");
          await fins.collection('chat').doc(chatO.id).update({
            'lastMsg': lastMsg,
            'messages': FieldValue.arrayUnion([lastMsg]),
          });
          found = true;
        }
      }

      print("final found : $found");

      if (!found) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      }
    }

//
    // Send Notif
    print("Sending Notif");
    String token = await getUserToken(chatVar.users[0].profile.id);
    envoiNotifnew(
        token, "${connectedUser.profile.name} ", "New Message : $message");
    //
    //
  }

  _saveImg(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    if (chatVar.id.isEmpty) {
      String uid = DateTime.now().microsecondsSinceEpoch.toString();
      //
      String url = await uploadFile(message, uid);

      if (url.isEmpty) {
        showsnack(context, "Upload Failled ! Please Retry");
        return;
      }
      //
      String vDate = DateTime.now().toString();
      await fins.collection('message').doc(uid).set({
        "id": uid,
        "date": vDate,
        "readState": chatVar.users[0].online ? "2" : "1",
        "userId": _chatController.currentUser.id,
        "type": "1",
        "name": "message_name",
        "content": url,
        "size": "",
        "length": "",
      });
      // Creéer le msg
      DocumentReference lastMsg = fins.collection('message').doc(uid);

      // Chez Moi

      // Chez Moi

      DocumentReference user =
          fins.collection('user').doc(chatVar.users[0].profile.id);

      await fins.collection('chat').doc(uid).set({
        'id': uid,
        'type': "0",
        'name': chatVar.users[0].profile.name,
        'unread': "0",
        'lastMsg': lastMsg,
        'img': chatVar.users[0].profile.img,
        'messages': [lastMsg],
        'users': [user],
        'isTyping': false,
        'isTypingTxt': "is typing",
        'checked': false,
        'archived': false
      });
      //
      DocumentReference chat2 = fins.collection('chat').doc(uid);
      await fins.collection('user').doc(_chatController.currentUser.id).update({
        'chats': FieldValue.arrayUnion([chat2]),
      });

      // Chez L'autre

      DocumentReference userMe =
          fins.collection('user').doc(_chatController.currentUser.id);

      final docOther =
          await fins.collection("user").doc(chatVar.users[0].profile.id).get();

      final chatsOther = docOther.data()!['chats'] ?? [];

      bool found = false;

      for (var chO in chatsOther) {
        DocumentSnapshot chatO = await chO.get();
        Map<String, dynamic>? chatOData = chatO.data() as Map<String, dynamic>?;
        List usrsO = chatOData!['users'] ?? [];
        print("chatOData : $chatOData");
        if ((chatOData['type'] == "0") && (usrsO.contains(userMe))) {
          print("found");
          await fins.collection('chat').doc(chatO.id).update({
            'lastMsg': lastMsg,
            'messages': FieldValue.arrayUnion([lastMsg]),
          });
          found = true;
        }
      }

      print("final found : $found");

      if (!found) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      }

      setState(() {
        chatVar.id = uid;
        // _loadMessages(chatVar.id);
        _listenForMessages(chatVar.id);
        _listenForTyping(chatVar.id);
      });
    } else {
      String uid = DateTime.now().microsecondsSinceEpoch.toString();
      //
      String url = await uploadFile(message, uid);

      if (url.isEmpty) {
        showsnack(context, "Upload Failled ! Please Retry");
        return;
      }
      //
      String vDate = DateTime.now().toString();
      await fins.collection('message').doc(uid).set({
        "id": uid,
        "date": vDate,
        "readState": chatVar.users[0].online ? "2" : "1",
        "userId": _chatController.currentUser.id,
        "type": "1",
        "name": "message_name",
        "content": url,
        "size": "",
        "length": "",
      });
      // Creéer le msg
      DocumentReference lastMsg = fins.collection('message').doc(uid);

      // Chez Moi

      await fins.collection('chat').doc(chatVar.id).update({
        'lastMsg': lastMsg,
        'messages': FieldValue.arrayUnion([lastMsg]),
      });
      //
      // Chez L'autre

      DocumentReference userMe =
          fins.collection('user').doc(_chatController.currentUser.id);

      final docOther =
          await fins.collection("user").doc(chatVar.users[0].profile.id).get();

      final chatsOther = docOther.data()!['chats'] ?? [];

      bool found = false;

      for (var chO in chatsOther) {
        DocumentSnapshot chatO = await chO.get();
        Map<String, dynamic>? chatOData = chatO.data() as Map<String, dynamic>?;
        List usrsO = chatOData!['users'] ?? [];
        print("chatOData : $chatOData");
        if ((chatOData['type'] == "0") && (usrsO.contains(userMe))) {
          print("found");
          await fins.collection('chat').doc(chatO.id).update({
            'lastMsg': lastMsg,
            'messages': FieldValue.arrayUnion([lastMsg]),
          });
          found = true;
        }
      }

      print("final found : $found");

      if (!found) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      }
    }

    //
    // Send Notif
    print("Sending Notif");
    String token = await getUserToken(chatVar.users[0].profile.id);
    envoiNotifnew(token, "${connectedUser.profile.name} ", "📷 Photo (1)");
    //
    //
  }

  _saveAudio(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    Duration? temp = await getAudioDuration(File(message));

    if (chatVar.id.isEmpty) {
      String uid = DateTime.now().microsecondsSinceEpoch.toString();
      //
      // String url = await uploadFile(message, uid);
      print("uploading audio : $message");

      String url = await uploadAudio(File(message));
      print("uploaded audio : $url");

      if (url.isEmpty) {
        showsnack(context, "Upload Failled ! Please Retry");
        return;
      }
      //
      String vDate = DateTime.now().toString();
      await fins.collection('message').doc(uid).set({
        "id": uid,
        "date": vDate,
        "readState": chatVar.users[0].online ? "2" : "1",
        "userId": _chatController.currentUser.id,
        "type": "2",
        "name": "message_name",
        "content": url,
        "size": "",
        "length": formatAudioDuaration(temp),
      });
      // Creéer le msg
      DocumentReference lastMsg = fins.collection('message').doc(uid);

      // Chez Moi

      DocumentReference user =
          fins.collection('user').doc(chatVar.users[0].profile.id);

      await fins.collection('chat').doc(uid).set({
        'id': uid,
        'type': "0",
        'name': chatVar.users[0].profile.name,
        'unread': "0",
        'lastMsg': lastMsg,
        'img': chatVar.users[0].profile.img,
        'messages': [lastMsg],
        'users': [user],
        'isTyping': false,
        'isTypingTxt': "is typing",
        'checked': false,
        'archived': false
      });
      //
      DocumentReference chat2 = fins.collection('chat').doc(uid);
      await fins.collection('user').doc(_chatController.currentUser.id).update({
        'chats': FieldValue.arrayUnion([chat2]),
      });

      // Chez L'autre

      DocumentReference userMe =
          fins.collection('user').doc(_chatController.currentUser.id);

      final docOther =
          await fins.collection("user").doc(chatVar.users[0].profile.id).get();

      final chatsOther = docOther.data()!['chats'] ?? [];

      bool found = false;

      for (var chO in chatsOther) {
        DocumentSnapshot chatO = await chO.get();
        Map<String, dynamic>? chatOData = chatO.data() as Map<String, dynamic>?;
        List usrsO = chatOData!['users'] ?? [];
        print("chatOData : $chatOData");
        if ((chatOData['type'] == "0") && (usrsO.contains(userMe))) {
          print("found");
          await fins.collection('chat').doc(chatO.id).update({
            'lastMsg': lastMsg,
            'messages': FieldValue.arrayUnion([lastMsg]),
          });
          found = true;
        }
      }

      print("final found : $found");

      if (!found) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      }

      setState(() {
        chatVar.id = uid;
        // _loadMessages(chatVar.id);
        _listenForMessages(chatVar.id);
        _listenForTyping(chatVar.id);
      });
    } else {
      String uid = DateTime.now().microsecondsSinceEpoch.toString();
      //
      print("uploading audio : $message");

      String url = await uploadAudio(File(message));

      print(temp);
      print("uploaded audio : $url");

      if (url.isEmpty) {
        showsnack(context, "Upload Failled ! Please Retry");
        return;
      }
      //
      String vDate = DateTime.now().toString();
      await fins.collection('message').doc(uid).set({
        "id": uid,
        "date": vDate,
        "readState": chatVar.users[0].online ? "2" : "1",
        "userId": _chatController.currentUser.id,
        "type": "2",
        "name": "message_name",
        "content": url,
        "size": "",
        "length": formatAudioDuaration(temp),
      });
      // Creéer le msg
      DocumentReference lastMsg = fins.collection('message').doc(uid);

      // Chez Moi

      await fins.collection('chat').doc(chatVar.id).update({
        'lastMsg': lastMsg,
        'messages': FieldValue.arrayUnion([lastMsg]),
      });
      //

      // Chez L'autre

      DocumentReference userMe =
          fins.collection('user').doc(_chatController.currentUser.id);

      final docOther =
          await fins.collection("user").doc(chatVar.users[0].profile.id).get();

      final chatsOther = docOther.data()!['chats'] ?? [];

      bool found = false;

      for (var chO in chatsOther) {
        DocumentSnapshot chatO = await chO.get();
        Map<String, dynamic>? chatOData = chatO.data() as Map<String, dynamic>?;
        List usrsO = chatOData!['users'] ?? [];
        print("chatOData : $chatOData");
        if ((chatOData['type'] == "0") && (usrsO.contains(userMe))) {
          print("found");
          await fins.collection('chat').doc(chatO.id).update({
            'lastMsg': lastMsg,
            'messages': FieldValue.arrayUnion([lastMsg]),
          });
          found = true;
        }
      }

      print("final found : $found");

      if (!found) {
        String uid2 =
            "${uid}_${DateTime.now().microsecondsSinceEpoch.toString()}";

        await fins.collection('chat').doc(uid2).set({
          'id': uid2,
          'type': "0",
          'name': _chatController.currentUser.name,
          'unread': "1",
          'lastMsg': lastMsg,
          'img': _chatController.currentUser.profilePhoto,
          'messages': [lastMsg],
          'users': [userMe],
          'isTyping': false,
          'isTypingTxt': "is typing",
          'checked': false,
          'archived': false
        });
        //
        DocumentReference chat3 = fins.collection('chat').doc(uid2);
        await fins.collection('user').doc(chatVar.users[0].profile.id).update({
          'chats': FieldValue.arrayUnion([chat3]),
        });
      }
    }

    //
    // Send Notif
    print("Sending Notif");
    String token = await getUserToken(chatVar.users[0].profile.id);
    envoiNotifnew(token, "${connectedUser.profile.name} ",
        "🎤 Voice Message (${formatAudioDuaration(temp)}) ");
    //
    //
  }

  String formatAudioDuaration(Duration temp) {
    var microseconds = temp.inMicroseconds;
    var sign = "";
    var negative = microseconds < 0;

    var hours = temp.inHours == 0 ? 0 : microseconds ~/ temp.inHours;
    microseconds = temp.inHours == 0 ? microseconds : microseconds.remainder(temp.inHours);

    // Correcting for being negative after first division, instead of before,
    // to avoid negating min-int, -(2^31-1), of a native int64.
    if (negative) {
      hours = 0 - hours; // Not using `-hours` to avoid creating -0.0 on web.
      microseconds = 0 - microseconds;
      sign = "-";
    }

    var minutes = temp.inMinutes == 0 ? 0 : microseconds ~/ temp.inMinutes;
    microseconds = temp.inMinutes == 0 ? microseconds : microseconds.remainder(temp.inMinutes);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = temp.inMicroseconds == 0 ? 0 : microseconds ~/ temp.inMicroseconds;
    microseconds = temp.inMicroseconds == 0 ? microseconds : microseconds.remainder(temp.inMicroseconds);

    var secondsPadding = seconds < 10 ? "0" : "";

    // // Padding up to six digits for microseconds.
    // var microsecondsText = microseconds.toString().padLeft(6, "0");

    return "$sign$hours:"
        "$minutesPadding$minutes:"
        "$secondsPadding$seconds";
  }

  Future<Duration> getAudioDuration(File file) async {
    // Implémentation pour extraire la durée du fichier audio
    // (en utilisant un package comme just_audio ou flutter_sound)
    // Exemple avec just_audio :
    final player = AudioPlayer();
    await player.setFilePath(file.path);
    print(
        " --- --------------- ---------- +++++++++++++++++  Audio Duration Pro");
    print(player.duration!.toString());
    return player.duration!;
    // throw UnimplementedError();
  }

/*   Stream<myclass.Chat?> _getInfos() async* {
    if (chatVar.id.isEmpty) {
      yield null;
    } else {
      myclass.Chat tmp = chatVar;

      //
      final usSnap = await fins.collection('chat').doc(chatVar.id).get();

      // Last Message
      DocumentReference lastMsgref =
          usSnap.data()!['lastMsg'] as DocumentReference;
      // Récupérer l
      final lastMsgDoc = await fins.doc(lastMsgref.path).get();

      myclass.Message lastMsg = myclass.Message.fromJson(lastMsgDoc.data()!);

      tmp = myclass.Chat(
          id: usSnap.data()!['id'],
          type: usSnap.data()!['type'],
          name: usSnap.data()!['name'],
          unread: usSnap.data()!['unread'],
          lastMsg: lastMsg,
          img: usSnap.data()!['img'],
          users: []);

      List<dynamic> msgRefs = usSnap.data()!['messages'] ?? [];

      print("Nb Message : ${msgRefs.length}");

      for (var ref in msgRefs) {
        final msgDoc = await fins.doc(ref.path).get();
        myclass.Message msgVar = myclass.Message.fromJson(msgDoc.data()!);
        tmp.messages.add(msgVar);
        print(msgVar.toJson().toString());
      }

      //

      List<dynamic> usrRefs = usSnap.data()!['users'] ?? [];

      for (var ref in usrRefs) {
        final usrDoc = await fins.doc(ref.path).get();
        DocumentReference profilRef =
            usrDoc.data()!['profile'] as DocumentReference;
        DocumentSnapshot<Map<String, dynamic>> profileDoc =
            await profilRef.get() as DocumentSnapshot<Map<String, dynamic>>;

        myclass.User user =
            myclass.User(profile: myclass.Profile.fromJson(profileDoc.data()!));
        user.online = usrDoc.data()!['online'];
        user.visible = usrDoc.data()!['visible'];
        tmp.users.add(user);
      }

      print("msg len : ");
      print(tmp.messages.length);

      // chatVar = tmp;

      // await updateController();

      yield tmp;
    }
  }
 */
//
//
//   void _onThemeIconTap() {
//     setState(() {
//       if (isDarkTheme) {
//         theme = LightTheme();
//         isDarkTheme = false;
//       } else {
//         theme = DarkTheme();
//         isDarkTheme = true;
//       }
//     });
//   }
//
//
}

class Data {
  static const profileImage =
      "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg";
  // "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final messageList = [
    Message(
      id: '1',
      message: "Hi!",
      createdAt: DateTime.now(),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.read,
    ),
    Message(
      id: '2',
      message: "Hi!",
      createdAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.read,
    ),
    Message(
      id: '3',
      message: "We can meet?I am free",
      createdAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '4',
      message: "Can you write the time and place of the meeting?",
      createdAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '5',
      message: "That's fine",
      createdAt: DateTime.now(),
      sentBy: '2',
      reaction: Reaction(reactions: ['\u{2764}'], reactedUserIds: ['1']),
      status: MessageStatus.read,
    ),
    Message(
      id: '6',
      message: "When to go ?",
      createdAt: DateTime.now(),
      sentBy: '3',
      status: MessageStatus.read,
    ),
    Message(
      id: '7',
      message: "I guess Simform will reply",
      createdAt: DateTime.now(),
      sentBy: '4',
      status: MessageStatus.read,
    ),
    Message(
      id: '8',
      message: "https://bit.ly/3JHS2Wl",
      createdAt: DateTime.now(),
      sentBy: '2',
      reaction: Reaction(
        reactions: ['\u{2764}', '\u{1F44D}', '\u{1F44D}'],
        reactedUserIds: ['2', '3', '4'],
      ),
      status: MessageStatus.read,
      replyMessage: const ReplyMessage(
        message: "Can you write the time and place of the meeting?",
        replyTo: '1',
        replyBy: '2',
        messageId: '4',
      ),
    ),
    Message(
      id: '9',
      message: "Done",
      createdAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
      reaction: Reaction(
        reactions: [
          '\u{2764}',
          '\u{2764}',
          '\u{2764}',
        ],
        reactedUserIds: ['2', '3', '4'],
      ),
    ),
    Message(
      id: '10',
      message: "Thank you!!",
      status: MessageStatus.read,
      createdAt: DateTime.now(),
      sentBy: '1',
      reaction: Reaction(
        reactions: ['\u{2764}', '\u{2764}', '\u{2764}', '\u{2764}'],
        reactedUserIds: ['2', '4', '3', '1'],
      ),
    ),
    Message(
      id: '11',
      message: "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg",
      createdAt: DateTime.now(),
      messageType: MessageType.image,
      sentBy: '1',
      reaction: Reaction(reactions: ['\u{2764}'], reactedUserIds: ['2']),
      status: MessageStatus.read,
    ),
    Message(
      id: '12',
      message: "🤩🤩",
      createdAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.read,
    ),
  ];
}
