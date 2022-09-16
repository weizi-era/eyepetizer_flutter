import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/date_util.dart';
import 'package:eyepetizer_flutter/utils/navigator_util.dart';
import 'package:flutter/material.dart';

class FollowItemWidget extends StatelessWidget {
  const FollowItemWidget({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _videoAuthor(),
          Container(
            height: 230,
            child: ListView.builder(
              itemCount: item.data!.itemList!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _inkWell(
                  item: item.data!.itemList![index],
                  last: index == item.data!.itemList!.length - 1,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// 视频作者
  Widget _videoAuthor() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: ClipOval(
            child: cacheImage(item.data!.header!.icon!
                , height: 40, width: 40),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.data!.header!.title!,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, right: 3),
                child: Text(
                  item.data!.header!.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black26,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5),
            child: Text(
              EyeString.add_follow,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _inkWell({required Item item, required bool last}) {
    return InkWell(
      onTap: () => toNamed("/detail", item.data),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: last ? 15 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _videoImage(item),
            _videoName(item),
            _videoTime(item),
          ],
        ),
      ),
    );
  }

  Widget _videoImage(Item item) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Hero(
            tag: "${item.data!.id}${item.data!.time}",
            child: cacheImage(item.data!.cover!.feed!, width: 300, height: 180),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white54,
              ),
              padding: EdgeInsets.all(6),
              alignment: AlignmentDirectional.center,
              child: Text(
                item.data!.category!,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _videoName(Item item) {
    return Container(
      width: 300,
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        item.data!.title!,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 视频分类及上架时间
  Widget _videoTime(Item item) {
    return Container(
      child: Text(
        formatDateMsByYMDHM(item.data!.author!.latestReleaseTime!),
        style: TextStyle(
          color: Colors.black26,
          fontSize: 12,
        ),
      ),
    );
  }
}
