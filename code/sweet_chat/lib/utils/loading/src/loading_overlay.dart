import 'package:sweet_chat/utils/loading/animations/bouncing_line.dart';
import 'package:flutter/material.dart';

class LoadingOverlayPro extends StatefulWidget {
  const LoadingOverlayPro({
    Key? key,
    required this.isLoading,
    required this.child,
    this.backgroundColor = Colors.black54,
    this.progressIndicator = const LoadingBouncingLine.circle(),
    this.overLoading,
    this.bottomLoading,
  }) : super(key: key);

  /// Show/hide loading
  final bool isLoading;

  /// Defaults to [Colors.black54].
  final Color backgroundColor;

  final Widget progressIndicator;

  final Widget child;

  final Widget? overLoading;

  final Widget? bottomLoading;

  @override
  _LoadingOverlayProState createState() => _LoadingOverlayProState();
}

class _LoadingOverlayProState extends State<LoadingOverlayPro> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Visibility(
            visible: widget.isLoading,
            child: Container(
                color: widget.backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.overLoading != null) widget.overLoading!,
                    SizedBox(height: 20),
                    Center(child: widget.progressIndicator),
                    SizedBox(height: 20),
                    if (widget.bottomLoading != null) widget.bottomLoading!,
                  ],
                ))),
      ],
    );
  }
}
