import 'package:flutter/material.dart';
import 'package:sfm_module/common/font_styles.dart';

class ResponsiveDialog extends StatefulWidget {
  ResponsiveDialog({
    this.context,
    String? title,
    Widget? child,
    this.headerColor,
    this.headerTextColor,
    this.backgroundColor,
    this.buttonTextColor,
    this.forcePortrait = false,
    double? maxLongSide,
    double? maxShortSide,
    this.hideButtons = false,
    this.okPressed,
    this.cancelPressed,
    this.confirmText,
    this.cancelText,
  })  : title = title ?? "Select Quantity",
        child = child ?? const Text(""),
        maxLongSide = maxLongSide ?? 200,
        maxShortSide = maxShortSide ?? 400;

  // Variables
  final BuildContext? context;
  @override
  final String title;
  final Widget child;
  final bool forcePortrait;
  @override
  final Color? headerColor;
  @override
  final Color? headerTextColor;
  @override
  final Color? backgroundColor;
  @override
  final Color? buttonTextColor;
  @override
  final double maxLongSide;
  @override
  final double maxShortSide;
  final bool hideButtons;
  @override
  final String? confirmText;
  @override
  final String? cancelText;

  // Events
  final VoidCallback? cancelPressed;
  final VoidCallback? okPressed;

  @override
  _ResponsiveDialogState createState() => _ResponsiveDialogState();
}

class _ResponsiveDialogState extends State<ResponsiveDialog> {
  Widget actionBar(BuildContext context) {
    if (widget.hideButtons) return Container();
    return Container(
      height: kDialogActionBarHeight,
      child: Container(
        child: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: FontStyle.recentItemStyle,
              ),
              onPressed: () => (widget.cancelPressed == null)
                  ? Navigator.of(context).pop()
                  : widget.cancelPressed!(),
            ),
            FlatButton(
              child: Text(
                "Okay",
                style: FontStyle.recentItemStyle,
              ),
              onPressed: () => (widget.okPressed == null)
                  ? Navigator.of(context).pop()
                  : widget.okPressed!(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(context != null);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17),
              Text("Select Quantity",
                  textAlign: TextAlign.start, style: FontStyle.selectQty),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: widget.child,
                ),
              ),
              actionBar(context),
            ],
          ),
        ),
      ),
    );
  }
}

// Constants
const double kPickerHeaderPortraitHeight = 80.0;
const double kPickerHeaderLandscapeWidth = 168.0;
const double kDialogActionBarHeight = 52.0;
const double kDialogMargin = 30.0;
