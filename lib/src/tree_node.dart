import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../flutter_tree.dart';

class TreeNode extends StatefulWidget {
  final TreeNodeData data;
  final TreeNodeData parent;
  final State? parentState;

  final bool lazy;
  final Widget icon;
  final bool showCheckBox;
  final bool showActions;
  final bool contentTappable;
  final double offsetLeft;
  final int? maxLines;

  final Function(TreeNodeData node) onTap;
  final void Function(bool checked, TreeNodeData node) onCheck;

  final void Function(TreeNodeData node) onExpand;
  final void Function(TreeNodeData node) onCollapse;

  final Future Function(TreeNodeData node) load;
  final void Function(TreeNodeData node) onLoad;

  final void Function(TreeNodeData node) remove;
  final void Function(TreeNodeData node, TreeNodeData parent) onRemove;

  final void Function(TreeNodeData node) append;
  final void Function(TreeNodeData node, TreeNodeData parent) onAppend;

  const TreeNode({
    Key? key,
    required this.data,
    required this.parent,
    this.parentState,
    required this.offsetLeft,
    this.maxLines,
    required this.showCheckBox,
    required this.showActions,
    required this.contentTappable,
    required this.icon,
    required this.lazy,
    required this.load,
    required this.append,
    required this.remove,
    required this.onTap,
    required this.onCheck,
    required this.onLoad,
    required this.onExpand,
    required this.onAppend,
    required this.onRemove,
    required this.onCollapse,
  }) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isChecked = false;
  bool _showLoading = false;
  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);

  List<TreeNode> _geneTreeNodes(List list) {
    return List.generate(list.length, (int index) {
      return TreeNode(
        data: list[index],
        parent: widget.data,
        parentState: widget.parentState != null ? this : null,
        remove: widget.remove,
        append: widget.append,
        icon: widget.icon,
        lazy: widget.lazy,
        load: widget.load,
        offsetLeft: widget.offsetLeft,
        maxLines: widget.maxLines,
        showCheckBox: widget.showCheckBox,
        showActions: widget.showActions,
        contentTappable: widget.contentTappable,
        onTap: widget.onTap,
        onCheck: widget.onCheck,
        onExpand: widget.onExpand,
        onLoad: widget.onLoad,
        onCollapse: widget.onCollapse,
        onRemove: widget.onRemove,
        onAppend: widget.onAppend,
      );
    });
  }

  @override
  initState() {
    super.initState();
    _isExpanded = widget.data.expanded;
    _isChecked = widget.data.checked;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onExpand(widget.data);
        } else if (status == AnimationStatus.reverse) {
          widget.onCollapse(widget.data);
        }
      });
    if (_isExpanded) {
      _rotationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parentState != null) _isChecked = widget.data.checked;

    bool hasData = widget.data.children.isNotEmpty || (widget.lazy && !_isExpanded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          splashColor: widget.contentTappable ? null : Colors.transparent,
          highlightColor: widget.contentTappable ? null : Colors.transparent,
          mouseCursor: widget.contentTappable ? SystemMouseCursors.click : MouseCursor.defer,
          onTap: widget.contentTappable
              ? () {
                  if (hasData) {
                    widget.onTap(widget.data);
                    toggleExpansion();
                  } else {
                    _isChecked = !_isChecked;
                    widget.onCheck(_isChecked, widget.data);
                    setState(() {});
                  }
                }
              : () {},
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.5),
                        child: CustomPaint(
                          painter: _DashedLineVerticalPainter(),
                          child: const SizedBox(width: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ClipOval(
                                  child: Material(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_right_alt_rounded,
                            size: 18,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // RotationTransition(
                          //   child: IconButton(
                          //     iconSize: 16,
                          //     icon: hasData ? widget.icon : const SizedBox.shrink(),
                          //     onPressed: hasData
                          //         ? () {
                          //             widget.onTap(widget.data);
                          //             toggleExpansion();
                          //           }
                          //         : null,
                          //   ),
                          //   turns: _turnsTween.animate(_rotationController),
                          // ),
                          // if (widget.showCheckBox)
                          //   Checkbox(
                          //     value: _isChecked,
                          //     checkColor: widget.data.checkBoxCheckColor,
                          //     fillColor: widget.data.checkBoxFillColor,
                          //     onChanged: (bool? value) {
                          //       _isChecked = value!;
                          //       if (widget.parentState != null) _checkUncheckParent();
                          //       widget.onCheck(_isChecked, widget.data);
                          //       setState(() {});
                          //     },
                          //   ),
                          // if (widget.lazy && _showLoading)
                          //   const SizedBox(
                          //     width: 12.0,
                          //     height: 12.0,
                          //     child: CircularProgressIndicator(strokeWidth: 1.0),
                          //   ),
                          Expanded(
                            child: Container(
                              key: ValueKey(widget.data.backgroundColor?.call()),
                              color: widget.data.backgroundColor?.call(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: QuaTrinhDetailItem(
                                  title: widget.data.title,
                                  content: widget.data.content,
                                  timeData: widget.data.timeData,
                                ),
                              ),
                            ),
                          ),
                          RotationTransition(
                            child: IconButton(
                              iconSize: 20,
                              icon: hasData ? widget.icon : const SizedBox.shrink(),
                              onPressed: hasData
                                  ? () {
                                      widget.onTap(widget.data);
                                      toggleExpansion();
                                    }
                                  : null,
                            ),
                            turns: _turnsTween.animate(_rotationController),
                          ),
                          // if (widget.showActions)
                          //   TextButton(
                          //     onPressed: () {
                          //       widget.append(widget.data);
                          //       widget.onAppend(widget.data, widget.parent);
                          //     },
                          //     child: const Text('Add', style: TextStyle(fontSize: 12.0)),
                          //   ),
                          // if (widget.showActions)
                          //   TextButton(
                          //     onPressed: () {
                          //       widget.remove(widget.data);
                          //       widget.onRemove(widget.data, widget.parent);
                          //     },
                          //     child: const Text('Remove', style: TextStyle(fontSize: 12.0)),
                          //   ),
                          // if (widget.data.customActions?.isNotEmpty == true) ...widget.data.customActions!,
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _rotationController,
          child: Padding(
            padding: EdgeInsets.only(left: widget.offsetLeft),
            child: Column(children: _geneTreeNodes(widget.data.children)),
          ),
        )
      ],
    );
  }

  void toggleExpansion() {
    if (widget.lazy && widget.data.children.isEmpty) {
      setState(() {
        _showLoading = true;
      });
      widget.load(widget.data).then((value) {
        if (value) {
          _isExpanded = true;
          _rotationController.forward();
          widget.onLoad(widget.data);
        }
        _showLoading = false;
        setState(() {});
      });
    } else {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
      setState(() {});
    }
  }

  void _checkUncheckParent() {
    // Check/uncheck all children based on parent state
    widget.data.checked = _isChecked;
    for (var child in widget.data.children) {
      child.checked = _isChecked;
    }
    widget.parentState!.setState(() {});

    // Check/uncheck parent based on children state
    widget.parent.checked = widget.parent.children.every((e) => e.checked);
    widget.parentState!.setState(() {});
  }
}

class QuaTrinhDetailItem extends StatelessWidget {
  final String title;
  final String content;
  final DateTime? timeData;
  const QuaTrinhDetailItem({Key? key, required this.title, required this.content, this.timeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<String> listFile =
    //     quaTrinhChiTietModel.danhSachDinhKem.isNotNullEmpty() ? quaTrinhChiTietModel.danhSachDinhKem!.split('☺') : [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.blue),
        ),
        Builder(
          builder: (context) {
            String status;
            String sub;
            if (content == 'O') {
              status = 'Chưa xử lý';
              if (content == '1') {
                sub = 'Đã xem';
              } else {
                sub = 'Chưa Xem';
              }
            } else {
              status = 'Đã xử lý';
              sub = timeData != null ? DateFormat('dd/MM/yyyy').format(timeData!) : '';
            }
            return Text(
              '$status ($sub)',
              style: const TextStyle(color: Colors.red),
            );
          },
        ),
        // if (quaTrinhChiTietModel.noiDungXuLy.isNotNullEmpty())
        //   Text(
        //     '${quaTrinhChiTietModel.noiDungXuLy}'.removeHtmlTag(),
        //     style: context.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        //   ),
        // if (listFile.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 5.0),
        //     child: GestureDetector(
        //       onTap: () => _onViewAttachFile(listFile),
        //       child: Row(
        //         children: [
        //           const Icon(Icons.attach_file_rounded),
        //           const SizedBox(width: 5),
        //           Text(
        //             'Tệp đính kèm',
        //             style: context.textTheme.labelMedium?.copyWith(decoration: TextDecoration.underline),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  // void _onViewAttachFile(List<String> files) {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     builder: (context) => FileBottomSheet(files: files),
  //   );
  // }

}

class _DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
