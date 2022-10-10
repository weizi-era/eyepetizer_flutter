
import 'package:flutter/material.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({Key? key, this.version, this.feature, required this.onClickWhenDownload, required this.onClickWhenNotDownload}) : super(key: key);

  final version;
  final feature;
  final Function onClickWhenDownload;
  final Function onClickWhenNotDownload;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {

  var _downloadProgress = 0.0;

  @override
  Widget build(BuildContext context) {

    var _textStyle = new TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color);
    return AlertDialog(
      title: Text("有新的更新", style: _textStyle,),
      content: _downloadProgress == 0.0
          ? Text(
        "版本:${widget.version}\n更新:${widget.feature}",
        style: _textStyle,
      )
          : LinearProgressIndicator(
        value: _downloadProgress,
      ),
      actions: <Widget>[
       TextButton(onPressed: () {
          if (_downloadProgress != 0.0) {
            widget.onClickWhenDownload("正在更新中...");
            return;
          }
          widget.onClickWhenNotDownload();
       }, child: Text("更新", style: _textStyle,)),
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("取消"))
      ],
    );
  }

  set progress(progress) {
    setState(() {
      _downloadProgress = progress;
      if (_downloadProgress == 1) {
        Navigator.of(context).pop();
        _downloadProgress = 0.0;
      }
    });
  }
}
