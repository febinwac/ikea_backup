// ignore_for_file: invalid_use_of_protected_member, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/colors.dart';
import 'package:sfm_module/common/font_styles.dart';

class CheckBox extends StatefulWidget {
  final Function? validator;
  final bool needLeftPadding;
  final bool status;
  final String? title;
  final bool isBoldText;
  final VoidCallback? onTap;

  const CheckBox(
      {this.validator,
      this.needLeftPadding = false,
      this.status = false,
      this.title,
      this.onTap,
      this.isBoldText = false});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return CheckBoxForm(
      validator:
          widget.validator == null ? (val) {} : (val) => widget.validator!(val),
      title: widget.title ?? '',
      onTap: widget.onTap!,
      isBoldText: widget.isBoldText,
      needLeftPadding: widget.needLeftPadding,
      status: widget.status,
    );
  }
}

class CheckBoxForm<T> extends FormField<bool> {
  final bool needLeftPadding;
  final bool status;
  final VoidCallback? onTap;
  final String? title;
  final bool isBoldText;

  CheckBoxForm({Key? key,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    String initialValue = '',
    this.status = false,
    this.isBoldText = false,
    this.title,
    this.needLeftPadding = false,
    this.onTap,
  }) : super(key: key,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<bool> state) {
              return InkWell(
                onTap: () {
                  onTap!();
                  state.setValue(true);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: needLeftPadding ? 2 : 0),
                  child: Row(
                    children: [
                      CustomCheckBox(
                        value: status,
                        shouldShowBorder: false,
                        borderColor: Colors.grey,
                        checkedFillColor: HexColor(primaryColor),
                        borderRadius: 5,
                        padding: 0,
                        borderWidth: 1,
                        checkBoxSize: 20,
                        onChanged: (val) {
                          onTap!();
                          state.setValue(true);
                        },
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        title ?? '',
                        style: isBoldText
                            ? FontStyle.priceBold
                            : FontStyle.selectQty,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              );
            });
}

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color checkedIconColor;
  final Color checkedFillColor;
  final IconData checkedIcon;
  final double? buttonSize;
  final EdgeInsets? buttonPadding;
  final Color uncheckedIconColor;
  final Color uncheckedFillColor;
  final IconData uncheckedIcon;
  final double? padding;
  final double? borderWidth;
  final double? checkBoxSize;
  final bool shouldShowBorder;
  final Color? borderColor;
  final double? borderRadius;
  final double? splashRadius;
  final Color? splashColor;
  final String? tooltip;
  final MouseCursor? mouseCursors;

  const CustomCheckBox({
    Key? key,
    this.value = false,
    required this.onChanged,
    this.checkedIconColor = Colors.white,
    this.checkedFillColor = Colors.teal,
    this.checkedIcon = Icons.check,
    this.uncheckedIconColor = Colors.white,
    this.uncheckedFillColor = Colors.white,
    this.uncheckedIcon = Icons.close,
    this.borderWidth,
    this.buttonSize,
    this.buttonPadding,
    this.checkBoxSize,
    this.shouldShowBorder = false,
    this.padding,
    this.borderColor,
    this.borderRadius,
    this.splashRadius,
    this.splashColor,
    this.tooltip,
    this.mouseCursors,
  }) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _checked = false;
  CheckStatus? _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    Color? fillColor;
    Color? iconColor;
    IconData? iconData;

    switch (_status) {
      case CheckStatus.checked:
        fillColor = widget.checkedFillColor;
        iconColor = widget.checkedIconColor;
        iconData = widget.checkedIcon;
        break;
      case CheckStatus.unchecked:
        fillColor = widget.uncheckedFillColor;
        iconColor = widget.uncheckedIconColor;
        iconData = widget.uncheckedIcon;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius:
            BorderRadius.all(Radius.circular(widget.borderRadius ?? 6)),
        border: Border.all(
          color: widget.shouldShowBorder
              ? (widget.borderColor ?? Colors.teal.withOpacity(0.6))
              : (!widget.value
                  ? (widget.borderColor ?? Colors.teal.withOpacity(0.6))
                  : Colors.transparent),
          width: widget.shouldShowBorder ? widget.borderWidth ?? 2.w : 1.w,
        ),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: widget.checkBoxSize ?? 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonSize,
      child: IconButton(
        icon: _buildIcon(),
        constraints: const BoxConstraints(),
        onPressed: () => widget.onChanged(!_checked),
        splashRadius: widget.splashRadius,
        splashColor: widget.splashColor,
        tooltip: widget.tooltip,
        padding: EdgeInsets.zero,
        mouseCursor: widget.mouseCursors ?? SystemMouseCursors.click,
      ),
    );
  }
}

enum CheckStatus {
  checked,
  unchecked,
}
