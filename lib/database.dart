import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

String host = Platform.environment['MONGO_HOST'] ?? 'localhost';
String port = Platform.environment['MONGO_PORT'] ?? '27017';

var db = Db("mongodb://mongo:mongo@$host:$port/videogamedb?authSource=admin");
