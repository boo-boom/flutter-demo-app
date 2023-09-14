import 'package:flutter/material.dart';
import 'package:flutter_demo_app/model/category_model.dart';
import 'package:flutter_demo_app/common/app_colors.dart';

enum FilterTypes { category, slots, areas }

class DropDownMenuModel {
  LayerLink layerLink;
  String name;
  FilterTypes type;
  List<CategoryModel> list;

  DropDownMenuModel({
    required this.name,
    required this.layerLink,
    required this.type,
    required this.list,
  });
}

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({super.key});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> with SingleTickerProviderStateMixin {
  int _curFilterIndex = 0;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonRowKey = GlobalKey();
  final List<DropDownMenuModel> _filterList = [
    DropDownMenuModel(name: '类别', type: FilterTypes.category, list: [], layerLink: LayerLink()),
    DropDownMenuModel(name: '排序', type: FilterTypes.slots, list: [], layerLink: LayerLink()),
    DropDownMenuModel(name: '区域', type: FilterTypes.areas, list: [], layerLink: LayerLink()),
  ];
  late AnimationController _animationController;
  late Animation<double> _animation;
  Color _maskColor = Colors.black26;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    init();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // 设置动画持续时间
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController); // 定义动画的值范围
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  init() async {
    // 模拟接口获取数据
    getCateList();
    getSlotList();
  }

  void getCateList() {
    setState(() {
      _filterList[0].list = [
        CategoryModel(id: 0, name: '全部', check: false),
        CategoryModel(id: 1, name: '火锅', check: false),
        CategoryModel(id: 2, name: '自助餐', check: false),
        CategoryModel(id: 3, name: '西餐', check: false),
        CategoryModel(id: 4, name: '烤肉', check: false),
        CategoryModel(id: 5, name: '甜品', check: false),
        CategoryModel(id: 6, name: '饮品', check: false),
        CategoryModel(id: 7, name: '蛋糕', check: false),
      ];
    });
  }

  void getSlotList() {
    setState(() {
      _filterList[1].list = [
        CategoryModel(id: 1, name: '离我最近', check: false),
        CategoryModel(id: 2, name: '综合排序', check: false),
        CategoryModel(id: 3, name: '价格排序', check: false),
      ];
    });
  }

  void changeOverlay({required int index, bool reset = false}) {
    // TAG: 更新OverlayEntry数据需要清空之后重新构建
    if (reset && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    RenderBox? renderBox;
    if (_buttonRowKey.currentContext != null) {
      renderBox = _buttonRowKey.currentContext?.findRenderObject() as RenderBox;
    }

    double left = -(renderBox!.size.width / _filterList.length) * index;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _filterList[index].layerLink,
          offset: Offset(left, renderBox!.size.height),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animation,
                    child: Container(color: _maskColor),
                  );
                },
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return SizeTransition(
                          sizeFactor: _animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -1), // 从顶部开始
                              end: Offset.zero,
                            ).animate(_animation),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                children: _filterList[index].list.asMap().entries.map((e) {
                                  int itemIndex = e.key;
                                  CategoryModel item = e.value;
                                  return _menuItem(cate: item, index: itemIndex, rootIndex: index);
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _menuItem({required int index, required int rootIndex, required CategoryModel cate}) {
    return GestureDetector(
      onTap: () {
        for (CategoryModel item in _filterList[rootIndex].list) {
          item.check = false;
        }
        _filterList[rootIndex].list[index].check = true;
        changeOverlay(index: rootIndex, reset: true);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        height: 40,
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cate.name}',
              style: TextStyle(
                fontSize: 14,
                color: _filterList[rootIndex].list[index].check == true ? AppColors.primaryColor : AppColors.black85,
              ),
            ),
            Offstage(
              offstage: !(_filterList[rootIndex].list[index].check == true),
              child: const Icon(
                Icons.check,
                size: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: _buttonRowKey,
      children: List.generate(_filterList.length, (index) {
        return Expanded(
          child: Stack(
            children: [
              CompositedTransformTarget(
                link: _filterList[index].layerLink,
                child: GestureDetector(
                  onTap: () {
                    if (_curFilterIndex == index || _overlayEntry == null) {
                      _isExpanded = !_isExpanded;
                      if (_isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                        _overlayEntry!.remove();
                        _overlayEntry = null;
                      }
                    } else {
                      _overlayEntry!.remove();
                      _overlayEntry = null;
                    }

                    _curFilterIndex = index;

                    changeOverlay(index: index, reset: true);

                    if (_isExpanded) {
                      _maskColor = Colors.black26;
                    }

                    Future.delayed(const Duration(milliseconds: 300)).then((_) {
                      if (!_isExpanded && _overlayEntry != null) {
                        _overlayEntry!.remove();
                        _overlayEntry = null;
                        _maskColor = Colors.transparent;
                      }
                    });
                  },
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _filterList[index].name,
                          style: const TextStyle(fontSize: 14, color: AppColors.black85),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
