import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  const ProviderWidget(
      {Key? key,
      required this.model,
      this.child,
      this.onModelInit,
      required this.builder})
      : super(key: key);

  // 维护数据
  final T model;
  final Widget? child;

  // 请求网络数据
  final Function(T)? onModelInit;
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  @override
  State<ProviderWidget> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  T? model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    if (widget.onModelInit != null && model != null) {
      widget.onModelInit!(model!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => model,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
