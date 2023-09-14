import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/app_colors.dart';
import 'package:flutter_demo_app/widget/drop_down_menu.dart';
import 'package:flutter_demo_app/widget/sticky_header_delegate.dart';

class DropDownMenuPage extends StatefulWidget {
  const DropDownMenuPage({super.key});

  @override
  State<DropDownMenuPage> createState() => _DropDownMenuPageState();
}

class _DropDownMenuPageState extends State<DropDownMenuPage> {
  final ScrollController _scrollController = ScrollController();
  double _navOpacity = 0.0;
  double _pixels = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollControllerListener);
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  scrollControllerListener() {
    _pixels = _scrollController.position.pixels;
    if (_pixels >= 0) {
      setState(() {
        _navOpacity = double.parse(min(1, _pixels / 100).toStringAsFixed(2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/image/home-top-bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 250 - kToolbarHeight - 12,
                backgroundColor: AppColors.backgroundColor.withOpacity(_navOpacity),
                elevation: 0,
                title: _searchInput(),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  minHeight: 44,
                  maxHeight: 44,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor.withOpacity(_navOpacity),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: const DropDownMenu(),
                      ),
                    ],
                  ),
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 2));
                },
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 100,
                  (context, index) {
                    return Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                      ),
                      child: Text('$index'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchInput() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 32,
        padding: const EdgeInsets.only(left: 10),
        decoration: const BoxDecoration(color: Colors.white),
        alignment: Alignment.centerLeft,
        child: const Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.primaryColor,
              size: 18,
            ),
            SizedBox(width: 5),
            Text(
              '搜索感兴趣的',
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
