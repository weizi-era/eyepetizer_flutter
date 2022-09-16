import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/state/base_list_state.dart';
import 'package:eyepetizer_flutter/viewmodel/discovery/follow_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/follow_item_widget.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key}) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState
    extends BaseListState<Item, FollowViewModel, FollowPage> {
  @override
  Widget getContentChild(model) => ListView.separated(
      itemBuilder: (context, index) {
        return FollowItemWidget(item: model.itemList![index]);
      },
      separatorBuilder: (context, index) => Divider(height: 0.5,),
      itemCount: model.itemList!.length);

  @override
  get viewModel => FollowViewModel();
}
