import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Trigger extends StatefulWidget {
  final void Function() onCreate;
  final Widget child;

  const Trigger({Key? key, required this.onCreate, required this.child}): super(key: key);

  @override
  State<Trigger> createState() {
    return _TriggerState();
  }
}

class _TriggerState extends State<Trigger> {
  bool _triggered = false;

  @override
  Widget build(BuildContext context) {
    if (!_triggered) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _triggered = true;
        widget.onCreate();
      });
    }
    return widget.child;
  }
}