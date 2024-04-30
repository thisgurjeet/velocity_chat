import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:real_time_chat_app_riverpod/colors.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/message_enum.dart';
import 'package:real_time_chat_app_riverpod/utils/utils.dart';

import 'package:real_time_chat_app_riverpod/view_model/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.receiverUserId);

      setState(() {
        _messageController.text = '';
      });
    } else {
      // for audio
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void selectVideo() async {
    File? video = await pickImageFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGIFMessage(context, gif.ur, widget.receiverUserId);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          child: TextFormField(
            focusNode: focusNode,
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
                filled: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 100,
                    child: Row(children: [
                      IconButton(
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: AppColors().color1,
                        ),
                      ),
                      IconButton(
                        onPressed: selectGIF,
                        icon: Icon(
                          Icons.gif,
                          color: AppColors().color1,
                        ),
                      ),
                    ]),
                  ),
                ),
                suffixIcon: SizedBox(
                  width: 100,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.camera_alt,
                        color: AppColors().color1,
                      ),
                    ),
                    IconButton(
                      onPressed: selectVideo,
                      icon: Icon(
                        Icons.attach_file,
                        color: AppColors().color1,
                      ),
                    ),
                  ]),
                ),
                hintText: 'Type a message',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none)),
                contentPadding: const EdgeInsets.all(10)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 2, right: 2),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors().color1,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShowSendButton
                    ? Icons.send
                    : isRecording
                        ? Icons.close
                        : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
      isShowEmojiContainer
          ? SizedBox(
              height: 310,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _messageController.text =
                        _messageController.text + emoji.emoji;
                  });
                  if (!isShowSendButton) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  }
                },
              ),
            )
          : const SizedBox(),
    ]);
  }
}
