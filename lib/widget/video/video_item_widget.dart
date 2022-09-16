import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/date_util.dart';
import 'package:flutter/material.dart';

class VideoItemWidget extends StatelessWidget {
  const VideoItemWidget(
      {Key? key,
      required this.data,
      required this.callback,
      this.openHero = false,
      this.titleColor = Colors.white,
      this.categoryColor = Colors.white})
      : super(key: key);

  final Data data;

  final VoidCallback callback;

  final bool openHero;
  final Color titleColor;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Row(
          children: [
            _videoImage(),
            _videoText(),
          ],
        ),
      ),
    );
  }

  Widget _videoImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: _coverWidget(),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              padding: EdgeInsets.all(3),
              child: Text(
                formatDateMsByMS(data.duration! * 1000),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _coverWidget() {
    if (openHero) {
      return Hero(
        tag: "${data.id}${data.time}",
        child: _imageWidget(),
      );
    } else {
      return _imageWidget();
    }
  }

  Widget _imageWidget() {
    return cacheImage(
      data.cover!.detail!,
      width: 135,
      height: 80,
    );
  }

  Widget _videoText() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title!,
              style: TextStyle(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "${data.category} / ${data.author?.name}",
                style: TextStyle(
                  color: categoryColor,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
