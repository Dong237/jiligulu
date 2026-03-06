import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'elder_button.dart';
import 'elder_text.dart';

/// 4-digit PIN dialog to enter child mode.
class PasswordDialog extends StatefulWidget {
  const PasswordDialog({
    super.key,
    required this.onSuccess,
    this.correctPin = '1234',
  });

  final VoidCallback onSuccess;
  final String correctPin;

  /// Show the dialog as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSuccess,
    String correctPin = '1234',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      builder: (_) => PasswordDialog(
        onSuccess: onSuccess,
        correctPin: correctPin,
      ),
    );
  }

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredPin =>
      _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onConfirm() {
    final pin = _enteredPin;
    if (pin.length < 4) return;

    if (pin == widget.correctPin) {
      Navigator.of(context).pop();
      widget.onSuccess();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage = '这是家人管理的入口哦';
      });
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spacingL,
        right: AppSizes.spacingL,
        top: AppSizes.spacingL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ElderText('输入家人密码', style: ElderTextStyle.subtitle),
          const SizedBox(height: AppSizes.spacingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSubtitle,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusSmall),
                      borderSide:
                          const BorderSide(color: AppColors.warmGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusSmall),
                      borderSide: const BorderSide(
                        color: AppColors.parrotGreen,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (v) => _onDigitChanged(i, v),
                ),
              );
            }),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSizes.spacingM),
            ElderText(
              _errorMessage!,
              style: ElderTextStyle.body,
              color: AppColors.warmOrange,
            ),
          ],
          const SizedBox(height: AppSizes.spacingL),
          ElderButton(
            label: '确认',
            onPressed: _onConfirm,
          ),
          const SizedBox(height: AppSizes.spacingM),
        ],
      ),
    );
  }
}
