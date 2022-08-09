import 'package:flutter/material.dart';
import 'package:sfm_module/common/font_styles.dart';

import 'quantiyt_picker_responsive_dialog.dart';

showQuantityPickerDialog({
  required BuildContext context,
  String? title,
  required final int minNumber,
  required final int maxNumber,
  final int? selectedNumber,
  final int step = 1,
  Color? headerColor,
  Color? headerTextColor,
  Color? backgroundColor,
  Color? buttonTextColor,
  String? confirmText,
  String? cancelText,
  double? maxLongSide,
  double? maxShortSide,
  ValueChanged<int>? onChanged,
  VoidCallback? onConfirmed,
  VoidCallback? onCancelled,
}) {
  List<String> items = [];

  for (int i = minNumber; i <= maxNumber; i += step) {
    items.add(i.toString());
  }

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return ScrollPickerDialog(
        items: items,
        title: title,
        initialItem: selectedNumber.toString(),
        headerColor: headerColor,
        headerTextColor: headerTextColor,
        backgroundColor: backgroundColor,
        buttonTextColor: buttonTextColor,
        confirmText: confirmText,
        cancelText: cancelText,
        maxLongSide: maxLongSide,
        maxShortSide: maxLongSide,
      );
    },
  ).then((selection) {
    if (onChanged != null && selection != null) onChanged(int.parse(selection));
    if (onCancelled != null && selection == null) onCancelled();
    if (onConfirmed != null && selection != null) onConfirmed();
  });
}

class ScrollPickerDialog extends StatefulWidget {
  ScrollPickerDialog({
    this.title,
    this.items,
    this.initialItem,
    this.headerColor,
    this.headerTextColor,
    this.backgroundColor,
    this.buttonTextColor,
    this.maxLongSide,
    this.maxShortSide,
    this.showDivider: true,
    this.confirmText,
    this.cancelText,
  });

  final List<String>? items;
  final String? initialItem;
  @override
  final String? title;
  @override
  final Color? headerColor;
  @override
  final Color? headerTextColor;
  @override
  final Color? backgroundColor;
  @override
  final Color? buttonTextColor;
  @override
  final double? maxLongSide;
  @override
  final double? maxShortSide;
  @override
  final String? confirmText;
  @override
  final String? cancelText;

  final bool showDivider;

  @override
  State<ScrollPickerDialog> createState() =>
      _ScrollPickerDialogState(initialItem);
}

class _ScrollPickerDialogState extends State<ScrollPickerDialog> {
  _ScrollPickerDialogState(this.selectedItem);

  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    assert(context != null);

    return ResponsiveDialog(
      context: context,
      title: widget.title,
      headerColor: widget.headerColor,
      headerTextColor: widget.headerTextColor,
      backgroundColor: widget.backgroundColor,
      buttonTextColor: widget.buttonTextColor,
      maxLongSide: widget.maxLongSide,
      maxShortSide: widget.maxLongSide,
      confirmText: widget.confirmText,
      cancelText: widget.cancelText,
      child: ScrollPickers(
        items: widget.items!,
        initialValue: selectedItem,
        showDivider: widget.showDivider,
        onChanged: (value) => setState(() => selectedItem = value),
      ),
      okPressed: () => Navigator.of(context).pop(selectedItem),
    );
  }
}

class ScrollPickers extends StatefulWidget {
  ScrollPickers({
    Key? key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
    this.showDivider: true,
  })  : assert(items != null),
        super(key: key);

  // Events
  final ValueChanged<String?> onChanged;

  final List<String?> items;
  final String? initialValue;
  final bool showDivider;

  @override
  _ScrollPickerState createState() => _ScrollPickerState(initialValue);
}

class _ScrollPickerState extends State<ScrollPickers> {
  _ScrollPickerState(this.selectedValue);

  // Constants
  static const double itemHeight = 50.0;

  late double widgetHeight;
  int? numberOfVisibleItems;
  int? numberOfPaddingRows;
  double? visibleItemsHeight;
  double? offset;

  String? selectedValue;

  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();

    int initialItem = widget.items.indexOf(selectedValue);
    scrollController = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle defaultStyle = FontStyle.defaultQuantity;
    TextStyle selectedStyle = FontStyle.recentItemStyle;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        widgetHeight = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            GestureDetector(
              onTapUp: _itemTapped,
              child: ListWheelScrollView.useDelegate(
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (BuildContext context, int index) {
                  if (index < 0 || index > widget.items.length - 1) {
                    return null;
                  }

                  var value = widget.items[index]!;

                  final TextStyle itemStyle =
                      (value == selectedValue) ? selectedStyle : defaultStyle;

                  return Center(
                    child: Container(
                      width: 70,
                      // height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: themeData.accentColor, width: 1.0),
                        ),
                      ),
                      child: Center(
                        child: Text(value, style: itemStyle),
                      ),
                    ),
                  );
                }),
                controller: scrollController,
                itemExtent: itemHeight,
                onSelectedItemChanged: _onSelectedItemChanged,
                physics: FixedExtentScrollPhysics(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _itemTapped(TapUpDetails details) {
    Offset position = details.localPosition;
    double center = widgetHeight / 2;
    double changeBy = position.dy - center;
    double newPosition = scrollController!.offset + changeBy;

    // animate to and center on the selected item
    scrollController!.animateTo(newPosition,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onSelectedItemChanged(int index) {
    String? newValue = widget.items[index];
    if (newValue != selectedValue) {
      selectedValue = newValue;
      widget.onChanged(newValue);
    }
  }
}
