import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/model/discovery/category_model.dart';
import 'package:eyepetizer_flutter/state/base_list_state.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/navigator_util.dart';
import 'package:eyepetizer_flutter/viewmodel/discovery/category_detail_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({Key? key, required this.categoryModel})
      : super(key: key);

  final CategoryModel categoryModel;

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState
    extends BaseListState<Item, CategoryDetailViewModel, CategoryDetailPage> {
  @override
  Widget getContentChild(CategoryDetailViewModel model) {
    return CustomScrollView(
      slivers: [
        _sliverAppBar(),
        _sliverList(model),
      ],
    );
  }

  bool isExpend = true;

  @override
  void init() {
    //设置不能下拉刷新
    enablePullDown = false;
  }

  @override
  CategoryDetailViewModel get viewModel =>
      CategoryDetailViewModel(widget.categoryModel.id!);

  Widget _sliverAppBar() {
    return SliverAppBar(
      // 左侧控件，通常情况为”返回“图标
      leading: GestureDetector(
        onTap: () => back(),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      // 阴影
      elevation: 0,
      // 背景色
      backgroundColor: Colors.white,
      // 亮度
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      // 展开区域的高度
      expandedHeight: 200,
      // 设置为true时，当SliverAppBar内容滑出屏幕时，将始终渲染一个固定在顶部的收起状态
      pinned: true,
      // 展开和折叠区域
      flexibleSpace: _flexibleSpace(),
    );
  }

  Widget _sliverList(CategoryDetailViewModel model) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
        return ListItemWidget(
          item: model.itemList![index],
          showCategory: false,
          showDivider: true, // true为隐藏
        );
      },
      childCount: model.itemList!.length,
    ));
  }



  Widget _flexibleSpace() {
    return LayoutBuilder(
      builder: (context, constraints) {
        changeExpendStatus((MediaQuery.of(context).padding.top).toInt() + 56,
            constraints.biggest.height.toInt());

        return FlexibleSpaceBar(
          title: Text(
            widget.categoryModel.name!,
            style: TextStyle(
              color: isExpend ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          background: cacheImage(widget.categoryModel.headerImage!),
        );
      },
    );
  }

  void changeExpendStatus(int statusBarHeight, int offset) {
    if (offset > statusBarHeight && offset < 250) {
      if (!isExpend) {
        isExpend = true;
      }
    } else {
      if (isExpend) {
        isExpend = false;
      }
    }
  }
}
