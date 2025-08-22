import 'package:flutter/material.dart';

/// This extension is created so that I don't have to write "MediaQuery.of(this).size" again and again.
/// Just write context.mqSize
extension MQSize on BuildContext {
  /// This extension is created so that I don't have to write "MediaQuery.of(this).size" again and again.
  /// Just write context.mqSize
  Size get mqSize => MediaQuery.of(this).size;
}
