import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
class InputDecorations {
  static InputDecoration buildInputDecoration_1({hint_text = "", suffixIcon,}) {
    return InputDecoration(
        hintText: hint_text,
        filled: true,
        fillColor: MyTheme.white,
        hintStyle: const TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: MyTheme.textfield_grey,
              width: 0.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        suffixIcon: suffixIcon,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: MyTheme.accent_color,
              width: 0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: MyTheme.brick_red,
              width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: MyTheme.brick_red,
              width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0));
  }

  static InputDecoration buildInputDecoration_phone({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        hintStyle: const TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(6.0),
              bottomRight: Radius.circular(6.0)),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.accent_color, width: 0.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0));
  }
}