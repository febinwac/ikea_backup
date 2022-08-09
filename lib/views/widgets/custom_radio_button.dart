// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/colors.dart';

class CustomRadioButton extends StatefulWidget {
  final bool isSelected;
  final String? title;
  final VoidCallback onTap;
  final Function? validator;

  const CustomRadioButton(
      {Key? key,
      required this.onTap,
      this.title,
      this.isSelected = false,
      this.validator})
      : super(key: key);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return RadioForm(
      validator:
          widget.validator == null ? (val) {} : (val) => widget.validator!(val),
      onTap: widget.onTap,
      title: widget.title ?? '',
      isSelected: widget.isSelected,
      context: context,
    );
  }
}

class RadioForm<T> extends FormField<bool> {
  final BuildContext context;
  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  RadioForm({
    Key? key,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    String initialValue = '',
    required this.context,
    required this.isSelected,
    required this.title,
    required this.onTap,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<bool> state) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      onTap();
                      state.setValue(true);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.h),
                      child: Row(
                        children: [
                          Container(
                            height: 21,
                            width: 21,
                            margin: EdgeInsets.only(top: 1.h),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? HexColor(primaryColor)
                                    : HexColor(viewGrey),
                                shape: BoxShape.circle),
                            child: isSelected
                                ? Container(
                                    margin: EdgeInsets.all(4.h),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  )
                                : const SizedBox(),
                          ),
                          SizedBox(width: 8.h),
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black))
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
}
