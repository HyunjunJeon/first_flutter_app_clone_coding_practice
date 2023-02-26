import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/features/users/widgets/user_profile_information.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constant/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("JHJ"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  size: Sizes.size20,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: Sizes.size52,
                  foregroundColor: Colors.teal,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/15343250?v=4"),
                  child: Text("HyunjunJeon"),
                ),
                Gaps.v20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "@jhj",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.h5,
                    FaIcon(
                      FontAwesomeIcons.solidCircleCheck,
                      size: Sizes.size16,
                      color: Colors.blue.shade400,
                    ),
                  ],
                ),
                Gaps.v24,
                SizedBox(
                  height: Sizes.size44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const UserProfileInformation(
                        data: 37,
                        information: "Following",
                      ),
                      VerticalDivider(
                        // 구분선을 보이게 하기 위해서는 Parent Widget 의 Size 가 필요한데 Row 는 그게 없으니, SizedBox 로 감사줌
                        width: Sizes.size32,
                        thickness: 1,
                        color: Colors.grey.shade300,
                        indent: Sizes.size14,
                        endIndent: Sizes.size14,
                      ),
                      const UserProfileInformation(
                        data: 105,
                        information: "Following",
                      ),
                      VerticalDivider(
                        width: Sizes.size32,
                        thickness: 1,
                        color: Colors.grey.shade300,
                        indent: Sizes.size14,
                        endIndent: Sizes.size14,
                      ),
                      const UserProfileInformation(
                        data: 1493,
                        information: "Likes",
                      ),
                    ],
                  ),
                ),
                Gaps.v14,
                FractionallySizedBox(
                  widthFactor:
                      0.75, // Parent Widget 의 Width 의 30% 만큼의 크기를 가지게 됌
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: Sizes.size1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              Sizes.size2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size14,
                          horizontal: Sizes.size60,
                        ),
                        child: const Text(
                          "Follow",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gaps.h4,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: Sizes.size1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              Sizes.size4,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size16,
                          horizontal: Sizes.size12,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.youtube,
                          color: Colors.black,
                          size: Sizes.size18,
                        ),
                      ),
                      Gaps.h4,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              Sizes.size4,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: Sizes.size1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size14,
                          horizontal: Sizes.size12,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.arrowDown,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.v14,
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.size32,
                  ),
                  child: Text(
                    "All highlights and where to watch live matches on FIFA+ I wonder how i would look",
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v14,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.link,
                      size: Sizes.size12,
                    ),
                    Gaps.h4,
                    Text(
                      "https://www.fifa.com/fifaplus/en/home",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Gaps.v20,
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.6,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(
                      vertical: Sizes.size8,
                    ),
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size14,
                        ),
                        child: Icon(Icons.grid_4x4_rounded),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size14,
                        ),
                        child: FaIcon(FontAwesomeIcons.heart),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // TabBarView 는 height 사이즈를 정확히 지정해주지 않으면 생성이 불가능
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      Center(
                        child: GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.all(
                            Sizes.size6,
                          ),
                          itemCount: 20,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: Sizes.size10,
                            mainAxisSpacing: Sizes.size10,
                            childAspectRatio: 9 / 20,
                          ),
                          itemBuilder: (context, index) => Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Sizes.size6),
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
                              const Text(
                                "This is a very long caption for my tiktok that i'm upload just now currently.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gaps.v4,
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
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "page two",
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
