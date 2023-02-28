import 'package:flutter/material.dart';

class TreeNodeData {
  String title;
  String content;
  DateTime? timeData;
  bool expanded;
  bool checked;
  dynamic extra;
  final Color? checkBoxCheckColor;
  final MaterialStateProperty<Color>? checkBoxFillColor;
  final ValueGetter<Color>? backgroundColor;
  final List<Widget>? customActions;
  List<TreeNodeData> children;

  TreeNodeData({
    required this.title,
    required this.content,
    required this.expanded,
    required this.checked,
    required this.children,
    this.extra,
    this.checkBoxCheckColor,
    this.checkBoxFillColor,
    this.backgroundColor,
    this.customActions,
    this.timeData,
  });

  TreeNodeData.from(TreeNodeData other)
      : this(
          title: other.title,
          expanded: other.expanded,
          checked: other.checked,
          extra: other.extra,
          children: other.children,
          content: other.content,
          timeData: other.timeData,
        );

  @override
  String toString() {
    return 'TreeNodeData{title: $title, expanded: $expanded, checked: $checked, extra: $extra, ${children.length} children}';
  }
}
