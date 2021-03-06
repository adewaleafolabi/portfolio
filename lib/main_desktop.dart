import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/app.dart';

void main() {
  Intl.defaultLocale = 'en_CA';
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}
