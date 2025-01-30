import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  // ThemeData get _theme => Theme.of(this);
  // TextTheme get textTheme => _theme.textTheme;
  // ColorScheme get colorScheme => _theme.colorScheme;
  // Size get deviceSize => MediaQuery.sizeOf(this);
  double height(BuildContext context) => MediaQuery.of(context).size.height;
  double width(BuildContext context) => MediaQuery.of(context).size.width;
}

extension BuildContextExtension on BuildContext {
  Future<void> push(BuildContext context, {required Widget target}) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => target,
    ));
  }

  Future<void> pop(BuildContext context) async {
    Navigator.of(context).pop();
  }
}
