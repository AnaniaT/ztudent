// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName =>
      kReleaseMode ? "./config/prod.env" : "./config/dev.env";

  static String get baseURL =>
      dotenv.env['BASE_URL'] ?? 'http://10.17.250.251:8080';
}
