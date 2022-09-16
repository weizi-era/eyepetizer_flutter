import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/state/base_list_state.dart';
import 'package:eyepetizer_flutter/viewmodel/home/home_page_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/banner_widget.dart';
import 'package:eyepetizer_flutter/widget/list_item_widget.dart';
import 'package:flutter/material.dart';

const TEXT_HEADER_TYPE = "textHeader";

class HomeBodyPage extends StatefulWidget {
  const HomeBodyPage({Key? key}) : super(key: key);

  @override
  State<HomeBodyPage> createState() => _HomeBodyPageState();
}

class _HomeBodyPageState
    extends BaseListState<Item, HomePageViewModel, HomeBodyPage> {
  @override
  Widget getContentChild(HomePageViewModel model) {
    // 带分割线的ListView
    return ListView.separated(
      itemCount: model.itemList!.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _banner(model);
        } else {
          if (model.itemList![index].type == TEXT_HEADER_TYPE) {
            return _titleItem(model.itemList![index]);
          }
          return ListItemWidget(item: model.itemList![index]);
        }
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Divider(
            height:
                model.itemList![index].type == TEXT_HEADER_TYPE || index == 0
                    ? 0
                    : 0.5,
            color: model.itemList![index].type == TEXT_HEADER_TYPE || index == 0
                ? Colors.transparent
                : Color(0xffe6e6e6),
          ),
        );
      },
    );
  }

  @override
  HomePageViewModel get viewModel => HomePageViewModel();

  _banner(model) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 15, top: 15, right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: BannerWidget(model: model),
      ),
    );
  }

  Widget _titleItem(Item item) {
    return Container(
      decoration: BoxDecoration(color: Colors.white24),
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: Center(
        child: Text(
          item.data!.text!,
          style: TextStyle(
            fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
