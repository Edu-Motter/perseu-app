import 'package:flutter/material.dart';

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class MessageItem implements ListItem {
  final String exercise;
  final String description;

  MessageItem(this.exercise, this.description);

  @override
  Widget buildTitle(BuildContext context) => Text(exercise);

  @override
  Widget buildSubtitle(BuildContext context) => Text(description);
}
