import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/date_util.dart';
import 'package:eyepetizer_flutter/utils/navigator_util.dart';
import 'package:eyepetizer_flutter/utils/share_util.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
      {Key? key,
      required this.item,
      this.showCategory = true,
      this.showDivider = true})
      : super(key: key);

  final Item item;
  final bool showCategory;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 视频封面图片
        GestureDetector(
          onTap: () {
            toNamed("/detail", item.data);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Stack(
              children: [
                _clipRRectImage(context),
                _categoryText(),
                _videoTime(),
              ],
            ),
          ),
        ),
        // 视频内容简介
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Row(
            children: [
              _authorHeaderImage(item),
              _videoDescription(),
              _shareButton(),
            ],
          ),
        ),
        // 分割线
        Offstage(
          offstage: showDivider,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              height: 0.5,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget _clipRRectImage(context) {
    return ClipRRect(
      child: Hero(
          // tag相同的两个widget，跳转时自动关联动画
          tag: "${item.data?.id}${item.data?.time}",
          child: cacheImage(
            item.data!.cover!.feed!,
            width: MediaQuery.of(context).size.width,
            height: 200,
          )),
      borderRadius: BorderRadius.circular(4),
    );
  }

  Widget _categoryText() {
    return Positioned(
      left: 15,
      top: 10,
      // 设置透明度
      child: Opacity(
        opacity: showCategory? 1.0 : 0.0, // 处理控件显示或隐藏 1：不透明
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          height: 44,
          width: 44,
          alignment: AlignmentDirectional.center,
          child: Text(
            item.data!.category!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoTime() {
    return Positioned(
      right: 15,
      bottom: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(color: Colors.black54),
          padding: EdgeInsets.all(5),
          child: Text(
            formatDateMsByMS(item.data!.duration! * 1000),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _authorHeaderImage(Item item) {
    return ClipOval(
      clipBehavior: Clip.antiAlias, // 抗锯齿
      child: cacheImage(
        item.data?.author == null
            ? item.data!.provider!.icon!
            : item.data!.author!.icon!,
        width: 40,
        height: 40,
      ),
    );
  }

  Widget _videoDescription() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.data!.title!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                item.data?.author == null
                    ? item.data!.description!
                    : item.data!.author!.name!,
                style: TextStyle(
                  color: Color(0xff9a9a9a),
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareButton() {
    return IconButton(
        onPressed: () => share(item.data!.title!, item.data!.playUrl!),
        icon: Icon(
          Icons.share,
          color: Colors.black38,
        ));
  }
}
