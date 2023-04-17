import 'dart:convert';

import 'package:gamedb_webapp/database.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> getPlatforms(Request request) async {
  await db.open();
  var platforms = await db.collection('platform').find().toList();
  await db.close();

  return Response.ok(jsonEncode(platforms),
      headers: {'Content-Type': 'text/json'});
}

Future<Response> getPlatform(Request request) async {
  await db.open();
  var platform = await db
      .collection('platform')
      .findOne(where.eq('_id', ObjectId.fromHexString(request.params['id']!)));
  await db.close();

  return Response.ok(jsonEncode(platform),
      headers: {'Content-Type': 'text/json'});
}
