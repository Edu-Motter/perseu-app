import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlashNotification extends StatelessWidget {
  final WidgetBuilder builder;

  // ignore: use_key_in_widget_constructors
  const FlashNotification(this.builder);

  FlashNotification.column(List<Widget> children): this((context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  });

  FlashNotification.simple(IconData icon, String message):
        this.column(<Widget>[
        Icon(icon, color: Colors.white, size: 50),
        Text(message, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ]);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.bodyText1!,
      child: builder(context),
    );
  }
}

class _SelfRemovableOverlayEntry extends StatefulWidget {
  final OverlayEntry? entry;
  final FlashNotification notification;
  final Duration duration;

  const _SelfRemovableOverlayEntry(this.entry, this.notification, this.duration);

  @override
  _SelfRemovableOverlayEntryState createState() {
    return _SelfRemovableOverlayEntryState();
  }
}

class _AnimationState {
  final double opacity;

  _AnimationState(this.opacity);

  static final _AnimationState initializing = _AnimationState(0.0);
  static final _AnimationState fadingIn = _AnimationState(1.0);
  static final _AnimationState fadingOut = _AnimationState(0.0);
}

class _SelfRemovableOverlayEntryState extends State<_SelfRemovableOverlayEntry> {
  _AnimationState _animationState = _AnimationState.initializing;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
      _animationState = _AnimationState.fadingIn;
    }));
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _animationState.opacity,
      duration: const Duration(milliseconds: 250),
      onEnd: () {
        if (_animationState == _AnimationState.fadingIn) {
          _timer = Timer(widget.duration, () => setState(() {
            _animationState = _AnimationState.fadingOut;
          }));
        } else if (_animationState == _AnimationState.fadingOut) {
          widget.entry?.remove();
        }
      },
      child: widget.notification,
    );
  }
}

void showFlashNotification(BuildContext context, FlashNotification notification,
    {Duration duration = const Duration(seconds: 2)}) {
  OverlayEntry? entry;
  entry = OverlayEntry(
      builder: (context) {
        return _SelfRemovableOverlayEntry(entry, notification, duration);
      }
  );
  Overlay.of(context)?.insert(entry);
}