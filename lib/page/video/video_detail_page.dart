
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/utils/date_util.dart';
import 'package:eyepetizer_flutter/utils/navigator_util.dart';
import 'package:eyepetizer_flutter/viewmodel/video/video_detail_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';
import 'package:eyepetizer_flutter/widget/provider_widget.dart';
import 'package:eyepetizer_flutter/widget/video/video_item_widget.dart';
import 'package:eyepetizer_flutter/widget/video/video_play_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const VIDEO_SMALL_CARD_TYPE = "videoSmallCard";

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key, this.videoData}) : super(key: key);

  final Data? videoData;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> with WidgetsBindingObserver {

  Data? data;

  // 允许element在树周围移动(改变父节点)，而不会丢失状态
  final GlobalKey<VideoPlayWidgetState> videoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 获取路由跳转传过来的数据
    data = widget.videoData ?? arguments();
    // 监听页面是否可见
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      videoKey.currentState?.pause();
    } else if (state == AppLifecycleState.resumed) {
      videoKey.currentState?.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ViewDetailViewModel>(
        model: ViewDetailViewModel(),
        onModelInit: (model) => model.loadVideoData(data!.id!),
        builder: (context, model, child) {
          return _scaffold(model);
        },
    );
  }

  Widget _scaffold(ViewDetailViewModel model) {
    return Scaffold(
      body: Column(
        children: [
          // 改变状态栏内容的颜色
          AnnotatedRegion(child: _statusBar(), value: SystemUiOverlayStyle.light),
          // 视频播放-Hero动画
          Hero(tag: "${data!.id}${data!.time}", child: VideoPlayWidget(
            key: videoKey,
            url: data!.playUrl!,
          )),
          Expanded(
            flex: 1,
            child: LoadingStateWidget(
              viewState: model.viewState,
              retry: model.retry,
              child: Container(
                // 设置背景色
                decoration: _decoration(),
                // 自定义 组合滑动
                child: CustomScrollView(
                  slivers: [
                    // 基础控件
                    _sliverToBoxAdapter(),
                    _sliverList(model),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  /// 设置状态栏背景色为黑色
  _statusBar() {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: Colors.black,
    );
  }

  Decoration _decoration() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: cacheNetworkImageProvider("${data?.cover?.blurred}}/thumbnail/${MediaQuery.of(context).size.height}x${MediaQuery.of(context).size.width}"),
      )
    );
  }

  Widget _sliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _videoTitle(),
          _videoTime(),
          _videoDescription(),
          _videoState(),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              height: 0.5,
              color: Colors.white,
            ),
          ),
          _videoAuthor(),
          Divider(
            height: 0.5,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  /// 视频标题
  Widget _videoTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Text(
        data!.title!,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 视频分类及上架时间
  Widget _videoTime() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Text(
        "#${data!.category!} / ${formatDateMsByYMDHM(data!.author!.latestReleaseTime!)}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  /// 视频描述
  Widget _videoDescription() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Text(
        data!.description!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  /// 视频状态：点赞、转发、评论
  Widget _videoState() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Row(
        children: [
          _stateCommonChild("images/ic_like.png", "${data!.consumption!.collectionCount}"),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: _stateCommonChild("images/ic_share_white.png", "${data!.consumption!.shareCount}"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: _stateCommonChild("images/icon_comment.png", "${data!.consumption!.replyCount}"),
          ),
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
            child: cacheImage(data!.author!.icon!, height: 40, width: 40),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data!.author!.name!,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, right: 3),
                child: Text(
                  data!.author!.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5),
            child: Text(
              EyeString.add_follow,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _stateCommonChild(String imageName, String count) {
    return Row(
      children: [
        Image.asset(
          imageName,
          width: 22,
          height: 22,
        ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sliverList(ViewDetailViewModel model) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (model.itemList![index].type == VIDEO_SMALL_CARD_TYPE) {
          return VideoItemWidget(
            data: model.itemList![index].data!,
            callback: () {
              Navigator.of(context);
              toPage(VideoDetailPage(videoData: model.itemList![index].data,));
            },
          );
        }

        return Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            model.itemList![index].data!.text!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      childCount: model.itemList?.length),
    );
  }
}
