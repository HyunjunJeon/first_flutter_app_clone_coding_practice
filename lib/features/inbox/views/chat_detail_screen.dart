import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:flutter_tiktok_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  ChatDetailScreenState createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isWriting = false;

  void _onTapUnFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onSubmittedWriting(String value) async {
    await ref.read(messagesProvider.notifier).sendMessage(value);
    FocusScope.of(context).unfocus();
    setState(() {
      _textEditingController.clear();
      _isWriting = false;
    });
  }

  _onSendPress() {
    final text = _textEditingController.text;
    if (text == "") return;
    _onSubmittedWriting(text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final isLoading = ref.watch(messagesProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/15343250?v=4",
                ),
                child: Text("jhj"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size18,
                  height: Sizes.size18,
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    border: Border.all(
                      width: Sizes.size3,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "jhj (${widget.chatId})",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h24,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onTapUnFocus,
            /*
            family 생성자를 사용하여 chatRoomId에 따라 다른 Stream을 반환합니다.
            이 Provider를 사용하려면, 해당 Provider를 사용하는 Widget에서 아래와 같이 사용하시면 됩니다.
            final chatProvider = context.read(chatProvider("chatRoomId"));
            위 코드에서 "chatRoomId"는 실제로 사용하는 채팅방의 ID로 대체되어야 합니다.
            * */
            child: ref.watch(chatProvider("chatRoomId")).when(
                  data: (data) {
                    return ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.only(
                        left: Sizes.size20,
                        right: Sizes.size14,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                      ),
                      itemBuilder: (context, index) {
                        final message = data[index];
                        final isMine =
                            message.userId == ref.watch(authRepo).user!.uid;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                Sizes.size14,
                              ),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.blue
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(
                                    Sizes.size20,
                                  ),
                                  topRight: const Radius.circular(
                                    Sizes.size20,
                                  ),
                                  bottomLeft: Radius.circular(
                                    isMine ? Sizes.size20 : 0,
                                  ),
                                  bottomRight: Radius.circular(
                                    isMine ? 0 : Sizes.size20,
                                  ),
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemCount: data.length,
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size4,
                ),
                child: Row(
                  children: [
                    Gaps.h16,
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: Sizes.size16,
                        ),
                        controller: _textEditingController,
                        onTap: _onStartWriting,
                        onSubmitted: _onSubmittedWriting,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Sizes.size20),
                              topRight: Radius.circular(Sizes.size20),
                              bottomLeft: Radius.circular(Sizes.size20),
                              bottomRight: Radius.zero,
                            ),
                            borderSide: BorderSide.none, // 테두리 삭제
                          ),
                          hintText: "Send a message...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                          suffixIcon: const Align(
                            widthFactor: Sizes.size1,
                            heightFactor: Sizes.size1,
                            child: FaIcon(
                              FontAwesomeIcons.faceSmile,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.h20,
                    Padding(
                      padding: const EdgeInsets.only(
                        right: Sizes.size12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Sizes.size10,
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: isLoading ? null : _onSendPress,
                              icon: FaIcon(
                                isLoading
                                    ? FontAwesomeIcons.hourglass
                                    : FontAwesomeIcons.solidPaperPlane,
                                color: Colors.white,
                                size: Sizes.size20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
