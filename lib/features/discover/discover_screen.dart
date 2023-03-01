import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/breakpoints.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "Initial text");

  void _onSearchChanged(String value) {}

  void _onSearchSubmitted(String value) {}

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery 는 현재 앱을 실행하고 있는 기기에 대한 정보를 주는 클래스
    // LayoutBuilder 는 해당 위젯의 하위에 builder 클래스에 속한 위젯의 크기 등을 알 수 있음
    final width = MediaQuery.of(context).size.width; // 화면을 조절할 때마다 계속 값이 바뀜
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // 키보드가 나오더라도 리사이징 되지 않도록
        appBar: AppBar(
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            // WEB 에서 SearchTextField 가 너무 커지기 때문에 ConstrainedBox(Container 를 사용한다면 굳이 이 위젯을 안써도 constraint field 가 있음)
            child: CupertinoSearchTextField(
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.black,
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.grey,
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              controller: _textEditingController,
            ),
          ),
          elevation: 1, // 회색 줄 보여주기
          bottom: TabBar(
            onTap: (value) => FocusManager.instance.primaryFocus?.unfocus(),
            unselectedLabelColor: Colors.grey.shade500,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            isScrollable: true,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            splashFactory: NoSplash.splashFactory, // Material splash 애니메이션 삭제
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(
                Sizes.size6,
              ),
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.md ? 5 : 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20,
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.size6),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: FadeInImage.assetNetwork(
                            placeholderFit: BoxFit.cover,
                            placeholder: "assets/images/IMG_2439.JPG",
                            fit: BoxFit.cover,
                            image:
                                "https://images.unsplash.com/photo-1676153838070-b62db9265c78?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1326&q=80",
                          ),
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        "${constraints.maxWidth}This is a very long caption for my tiktok that i'm upload just now currently.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v4,
                      if (!(constraints.maxWidth > 143 &&
                          constraints.maxWidth < 200))
                        DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://avatars.githubusercontent.com/u/15343250?v=4",
                                ),
                                radius: Sizes.size12,
                              ),
                              Gaps.h4,
                              const Expanded(
                                child: Text(
                                  "My avatar is going to be very long...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Gaps.h4,
                              FaIcon(
                                FontAwesomeIcons.heart,
                                size: Sizes.size16,
                                color: Colors.grey.shade600,
                              ),
                              Gaps.h2,
                              const Text("2.0M")
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            for (var tab in tabs.skip(1)) // 처음 한개는 빼고 tabs 를 돌게됌
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: Sizes.size28,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
