import 'dart:convert';

import 'package:gamedb_webapp/database.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> getGenres(Request request) async {
  await db.open();
  var platforms = await db.collection('genre').find().toList();
  await db.close();

  return Response.ok(jsonEncode(platforms),
      headers: {'Content-Type': 'text/json'});
}

Future<Response> getGenre(Request request) async {
  await db.open();
  var genre = await db
      .collection('genre')
      .findOne(where.eq('_id', ObjectId.fromHexString(request.params['id']!)));
  await db.close();

  return Response.ok(jsonEncode(genre), headers: {'Content-Type': 'text/json'});
}
