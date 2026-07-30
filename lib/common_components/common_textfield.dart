import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/common_icon_button.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/core/utils/constants.dart';

import '../core/theme/app_theme.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.isPassword = false,
    this.isSearch = false,
    this.isEnabled = true,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
    this.cph,
    this.cpv,
    this.fontSize,
    this.hintFontSize,
    this.hasError = false,
    this.focusNode,
    this.nextNode,
  });

  final bool isPassword, isSearch, isEnabled, hasError;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Widget? prefix, suffix;
  final double? cph, cpv, fontSize, hintFontSize;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode, nextNode;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late FocusNode _internalFocusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _internalFocusNode = widget.focusNode ?? FocusNode();

    _internalFocusNode.addListener(() {
      setState(() {
        _isFocused = _internalFocusNode.hasFocus;
      });
    });

    widget.controller?.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    widget.controller?.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    final isNowNotEmpty = widget.controller?.text.isNotEmpty ?? false;
    if (_hasText != isNowNotEmpty) {
      setState(() {
        _hasText = isNowNotEmpty;
      });
    }
  }

  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.isSearch ? 0 : 10.r),
        boxShadow: !widget.hasError && _isFocused
            ? [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : [],
      ),
      clipBehavior: Clip.none,
      child: ValueListenableBuilder(
        valueListenable: _isObscure,
        builder: (context, bool isObscure, _) {
          if (!widget.isPassword) {
            isObscure = false;
          }

          return TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _isObscure.value : false,
            keyboardType: widget.keyboardType,
            cursorColor: AppTheme.primary,
            textCapitalization: widget.textCapitalization,
            style: TextStyle(
              color: AppTheme.contentNeutralSecondary,
              fontSize: widget.fontSize ?? 18.sp,
              fontFamily: FontFamily.inter,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            onTapOutside: (event) => AppUtils.hideKeyboardInApp(context),
            validator: widget.validator,
            enabled: widget.isEnabled,
            focusNode: _internalFocusNode,
            decoration: InputDecoration(
              fillColor: AppTheme.background,
              filled: true,
              prefixIcon: widget.prefix,
              suffixIcon: widget.isPassword
                  ? IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Center(
                          child: CommonCompactIconButton(
                            onTap: () => _isObscure.value = !isObscure,
                            icon: isObscure
                                ? IconAsset.eyeClose
                                : IconAsset.eyeOpen,
                            size: 24.h,
                          ),
                        ),
                      ),
                    )
                  : widget.suffix,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: widget.hintFontSize ?? 18.sp,
                color: AppTheme.contentNeutralLight,
                height: 1.2,
              ),
              errorMaxLines: 2,
              errorStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppTheme.contentBrandPrimary,
              ),
              border: widget.isSearch
                  ? UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primaryButtonDisabled))
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.isSearch ? 0 : 8.r),
                      borderSide:
                          BorderSide(color: AppTheme.primaryButtonDisabled),
                    ),
              enabledBorder: widget.isSearch
                  ? UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primaryButtonDisabled))
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.isSearch ? 0 : 8.r),
                      borderSide:
                          BorderSide(color: AppTheme.primaryButtonDisabled),
                    ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.isSearch ? 0 : 8.r),
                borderSide:
                    BorderSide(color: AppTheme.contentBrandPrimaryOrange),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.isSearch ? 0 : 8.r),
                borderSide: BorderSide(color: AppTheme.contentBrandPrimary),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.isSearch ? 0 : 8.r),
                borderSide: BorderSide(color: AppTheme.contentBrandPrimary),
              ),
              disabledBorder: widget.isSearch
                  ? UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primaryButtonDisabled))
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.isSearch ? 0 : 8.r),
                      borderSide:
                          BorderSide(color: AppTheme.primaryButtonDisabled),
                    ),
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.cpv ?? 16.h,
                horizontal: widget.cph ?? 16.w,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      hintText: AppString.search,
      cpv: 12.h,
      fontSize: 16.sp,
      hintFontSize: 16.sp,
      isSearch: true,
      onChanged: onChanged,
      prefix: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 12.w),
          child: SvgPicture.asset(
            IconAsset.search,
            height: 24.h,
            width: 24.h,
            colorFilter: ColorFilter.mode(
              AppTheme.contentNeutralLight,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

// class SearchField extends StatelessWidget {
//   const SearchField({super.key, required this.controller});
//
//   final TextEditingController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return CommonTextField(
//       controller: controller,
//       hintText: AppString.search,
//       cpv: 12.h,
//       fontSize: 16.sp,
//       hintFontSize: 16.sp,
//       isSearch: true,
//       prefix: IntrinsicWidth(
//         child: Container(
//           padding: EdgeInsets.only(left: 16.w, right: 12.w),
//           child: SvgPicture.asset(
//             IconAsset.search,
//             height: 24.h,
//             width: 24.h,
//             colorFilter: ColorFilter.mode(AppTheme.contentNeutralLight, BlendMode.srcIn),
//           ),
//         ),
//       ),
//     );
//   }
// }
