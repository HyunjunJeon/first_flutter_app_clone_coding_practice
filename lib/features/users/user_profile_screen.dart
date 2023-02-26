import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          backgroundColor: Colors.red,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
            ],
            title: Text("Hello"),
            background: Image.asset(
              "assets/images/IMG_2429.HEIC",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(),
        SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              childCount: 50,
              (context, index) => Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Item $index"),
                ),
                color: Colors.teal[100 * (index % 9)],
              ),
            ),
            itemExtent: 100),
        SliverPersistentHeader(
          delegate: CustomDelegate(),
          pinned: true,
          floating: true,
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.blue[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: Sizes.size20,
            crossAxisSpacing: Sizes.size20,
            childAspectRatio: 1,
          ),
        )
      ],
    );
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      // 부모로부터 가장 많은 공간을 차지하게 되는 Sizedbox
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text(
            "Title~!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
