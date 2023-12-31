import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Use this field everywhere except password fields

class InputField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool? readOnly;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;

  const InputField({
    super.key,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.maxLines,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onChanged,
    this.readOnly,
    this.textAlign,
    this.contentPadding,
    this.textCapitalization,
  });

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        textAlign: widget.textAlign ?? TextAlign.start,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          hintText: widget.hintText ?? '',
          labelText: widget.labelText,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        readOnly: widget.readOnly ?? false,
      ),
    );
  }
}

class DropDownField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const DropDownField({
    super.key,
    this.hintText,
    this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged!,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          hintText: hintText ?? '',
          labelText: labelText,
          contentPadding:
              contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }
}
