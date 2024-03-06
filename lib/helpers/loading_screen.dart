import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/helpers/loading_screen_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingScreen {
  // THIS CREATES A SINGLETON INSTANCE OF THE CLASS WE ARE CREATING DO THAT THERE IS ONLY ONE OF THIS IN THE APPLICATION
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  // FUNCTION TO SHOW THE OVERLAY
  void show({
    required BuildContext context,
    String text = 'loading',
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  // FUNCTION TO HIDE OVERLAY
  void hide() {
    _controller?.close();
    _controller = null;
  }

  // SHOW OVERLAY FUNCTION: IT CREATES AN OVERLAY.OF(CONTEXT) AND AN OVERLAY ENTRY
  // I AM STILL GOING TO CHANGE THAT TEXT AND LOADING TO AN ANIMATION
  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.of(context);
    final textController = StreamController<String>();
    textController.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.h),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h),
                      const CircularProgressIndicator.adaptive(),
                      SizedBox(height: 10.h),
                      StreamBuilder<String>(
                        stream: textController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.requireData,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
