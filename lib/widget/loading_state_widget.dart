
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:flutter/material.dart';

enum ViewState {
  loading, done, error
}


class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({Key? key, this.viewState, this.retry, this.child}) : super(key: key);

  final ViewState? viewState;
  final VoidCallback? retry;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (viewState == ViewState.loading) {
        return _loadView;
    } else if (viewState == ViewState.error){
      return _errorView;
    } else {
      return child!;
    }
  }

  Widget get _loadView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get _errorView {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/ic_error.png", width: 80, height: 80,),
          Padding(padding: EdgeInsets.only(top: 8.0),
            child: Text(
            EyeString.net_request_fail,
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),),
          Padding(padding: EdgeInsets.only(top: 8.0),
          child: OutlinedButton(onPressed: retry, child: Text(
            EyeString.reload_again,
            style: TextStyle(color: Colors.black87),
          ), style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(Colors.black12),
          ),),)
        ],
      ),
    );
  }
}
