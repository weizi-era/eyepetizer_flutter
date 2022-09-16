import 'package:flutter/material.dart';
import 'package:eyepetizer_flutter/config/color.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/model/discovery/topic_detail_model.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/date_util.dart';
import 'package:eyepetizer_flutter/utils/navigator_util.dart';
import 'package:eyepetizer_flutter/utils/share_util.dart';
import 'package:eyepetizer_flutter/widget/expand_more_text_widget.dart';

class TopicDetailItemWidget extends StatelessWidget {
  final TopicDetailItemData model;

  const TopicDetailItemWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO:跳转 '/detail' 界面
      onTap: () => toNamed('/detail', model.data!.content!.data!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // author 介绍
          _author(),
          // 作品描述
          _description(),
          // 标签
          _tag(),
          // 视频图片
          _videoImage(context),
          // 视频状态
          _videoState(),
          // 分割线
          _divider(),
        ],
      ),
    );
  }

  /// author 介绍
  Widget _author() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
          child: ClipOval(
            child: cacheImage(
              model.data!.header!.icon ?? '',
              width: 45,
              height: 45,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.data!.header!.issuerName ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                // 作品发布时间
                Row(
                  children: <Widget>[
                    Text(
                      '${formatDateMsByYMD(model.data!.header!.time!)}发布：',
                      style:
                      TextStyle(color: EyeColor.hitTextColor, fontSize: 12),
                    ),
                    Expanded(
                      child: Text(
                        model.data!.content!.data!.title!,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 作品描述
  Widget _description() {
    var textStyle = const TextStyle(
        fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      // 可展开文字
      child: ExpandMoreTextWidget(
        model.data!.content!.data!.description!,
        style: TextStyle(fontSize: 14, color: EyeColor.desTextColor),
        moreStyle: textStyle,
        lessStyle: textStyle,
      ),
    );
  }

  /// 标签
  Widget _tag() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: _getTagWidgetList(model),
      ),
    );
  }

  List<Widget> _getTagWidgetList(TopicDetailItemData itemData) {
    List<Widget> widgetList = itemData.data!.content!.data!.tags!.map((tag) {
      return Container(
        margin: EdgeInsets.only(right: 5),
        alignment: Alignment.center,
        height: 20,
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            color: EyeColor.tabBgColor, borderRadius: BorderRadius.circular(4)),
        child: Text(
          tag.name!,
          style: TextStyle(fontSize: 12, color: Colors.blue),
        ),
      );
    }).toList();
    // tags 超过三个则只显示三个
    return widgetList.length > 3 ? widgetList.sublist(0, 3) : widgetList;
  }

  /// 视频图片
  Widget _videoImage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: Stack(
        children: <Widget>[
          ClipRRect(
              child: Hero(
                tag:
                '${model.data!.content!.data!.id!}${model.data!.content!.data!.time!}',
                child: cacheImage(
                  model.data!.content!.data!.cover!.feed!,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              ), //充满容器，可能会被截断
              borderRadius: BorderRadius.circular(4)),
          Positioned(
            right: 8,
            bottom: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                decoration: BoxDecoration(color: Colors.black54),
                padding: EdgeInsets.all(5),
                child: Text(
                  formatDateMsByMS(model.data!.content!.data!.duration! * 1000),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 视频状态
  Widget _videoState() {
    return Row(
      // 在第一个和最后一个child之间均匀分布剩余的child
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // 点赞
        Row(
          children: <Widget>[
            Icon(Icons.favorite_border, size: 20, color: EyeColor.hitTextColor),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                  '${model.data!.content!.data!.consumption!.collectionCount}',
                  style: TextStyle(fontSize: 12, color: EyeColor.hitTextColor)),
            )
          ],
        ),
        // 评论
        Row(
          children: <Widget>[
            Icon(Icons.message, size: 20, color: EyeColor.hitTextColor),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('${model!.data!.content!.data!.consumption!.replyCount}',
                  style: TextStyle(fontSize: 12, color: EyeColor.hitTextColor)),
            ),
          ],
        ),
        // 收藏
        Row(
          children: <Widget>[
            Icon(Icons.star_border, size: 20, color: EyeColor.hitTextColor),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(EyeString.collect_text,
                  style: TextStyle(fontSize: 12, color: EyeColor.hitTextColor)),
            ),
          ],
        ),
        // 分享
        IconButton(
          icon: Icon(Icons.share, color: EyeColor.hitTextColor),
          onPressed: () => share(model.data!.content!.data!.title!,
              model.data!.content!.data!.webUrl!.forWeibo!),
        ),
      ],
    );
  }

  /// 分割线
  Widget _divider() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Divider(
        height: 0.5,
      ),
    );
  }

}
