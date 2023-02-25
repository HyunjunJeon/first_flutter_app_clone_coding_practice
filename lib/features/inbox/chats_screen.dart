import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  List<int> _items = [];
  final Duration _duration = const Duration(milliseconds: 300);

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red.shade400,
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  void _onChatTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatDetailScreen(),
      ),
    );
  }

  ListTile _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: _onChatTap,
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            "https://avatars.githubusercontent.com/u/15343250?v=4"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "$index",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              fontSize: Sizes.size12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      subtitle: const Text(
        "Say hi to UserName",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder: (context, index, animation) {
          return SizeTransition(
            key: UniqueKey(),
            sizeFactor: animation,
            child: _makeTile(index),
          );
        },
      ),
    );
  }
}
