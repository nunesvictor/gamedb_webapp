import 'dart:convert';

import 'package:gamedb_webapp/database.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> getGames(Request request) async {
  await db.open();
  DbCollection collection = db.collection('game');
  Stream<Map<String, dynamic>> findStream = collection.find();

  if (request.url.queryParameters.isNotEmpty) {
    if (request.url.queryParameters.containsKey('year')) {
      findStream = collection.find(where.match(
          'release_date', '^${request.url.queryParameters['year']}'));
    }

    if (request.url.queryParameters.containsKey('genre')) {
      findStream = collection.find(where.eq('genres._id',
          ObjectId.fromHexString(request.url.queryParameters['genre']!)));
    }

    if (request.url.queryParameters.containsKey('platform')) {
      findStream = collection.find(where.eq('platforms._id',
          ObjectId.fromHexString(request.url.queryParameters['platform']!)));
    }
  }

  var games = await findStream.toList();
  await db.close();

  return Response.ok(jsonEncode(games), headers: {'Content-Type': 'text/json'});
}

Future<Response> getGame(Request request) async {
  await db.open();
  var game = await db
      .collection('game')
      .findOne(where.eq('_id', ObjectId.fromHexString(request.params['id']!)));
  await db.close();

  return Response.ok(jsonEncode(game), headers: {'Content-Type': 'text/json'});
}

Future<Response> postGame(Request request) async {
  await db.open();
  var game = await request.readAsString();
  await db.collection('game').insertOne(jsonDecode(game));
  await db.close();

  return Response.ok('Game added');
}

Future<Response> putGame(Request request) async {
  await db.open();
  var game = await request.readAsString();
  await db.collection('game').updateOne(
      {'_id': ObjectId.fromHexString(request.params['id']!)},
      {'\$set': jsonDecode(game)});
  await db.close();

  return Response.ok('Game updated');
}

Future<Response> deleteGame(Request request) async {
  await db.open();
  await db.collection('game').deleteOne(
      where.eq("_id", ObjectId.fromHexString(request.params['id']!)));
  await db.close();

  return Response.ok('Game deleted');
}
