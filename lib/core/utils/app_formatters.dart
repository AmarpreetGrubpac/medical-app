import 'package:flutter/services.dart';

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\s+'), '');
    
    final selectionStart = newValue.selection.start;
    final selectionEnd = newValue.selection.end;
    
    int spacesBeforeStart = 0;
    if (selectionStart >= 0 && selectionStart <= newValue.text.length) {
      final textBeforeStart = newValue.text.substring(0, selectionStart);
      spacesBeforeStart = RegExp(r'\s').allMatches(textBeforeStart).length;
    }
    
    int spacesBeforeEnd = 0;
    if (selectionEnd >= 0 && selectionEnd <= newValue.text.length) {
      final textBeforeEnd = newValue.text.substring(0, selectionEnd);
      spacesBeforeEnd = RegExp(r'\s').allMatches(textBeforeEnd).length;
    }
    
    final newStart = (selectionStart - spacesBeforeStart).clamp(0, newText.length);
    final newEnd = (selectionEnd - spacesBeforeEnd).clamp(0, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: newStart,
        extentOffset: newEnd,
      ),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}
