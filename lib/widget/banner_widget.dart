import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/navigator_util.dart';
import 'package:eyepetizer_flutter/viewmodel/home/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key, this.model}) : super(key: key);

  final HomePageViewModel? model;

  @override
  Widget build(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: cacheNetworkImageProvider(
                        model!.bannerList![index].data!.cover!.feed!),
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width - 30,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                decoration: BoxDecoration(color: Colors.black12),
                child: Text(
                  model!.bannerList![index].data!.title!,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        );
      },
      onTap: (index) {
        debugPrint("点击了banner图：${index}");
        toNamed("/detail", model?.bannerList![index].data);
      },
      itemCount: model?.bannerList?.length ?? 0,
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          builder: DotSwiperPaginationBuilder(
            size: 8,
            activeSize: 8,
            activeColor: Colors.white,
            color: Colors.white24,
          )),
    );
  }
}
