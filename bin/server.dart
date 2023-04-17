import 'dart:io';

import 'package:gamedb_webapp/games.dart';
import 'package:gamedb_webapp/genres.dart';
import 'package:gamedb_webapp/platforms.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/games', getGames)
  ..get('/games/<id>', getGame)
  ..post('/games', postGame)
  ..get('/genres', getGenres)
  ..get('/genres/<id>', getGenre)
  ..get('/platforms', getPlatforms)
  ..get('/platforms/<id>', getPlatform)
  ..put('/games/<id>', putGame)
  ..delete('/games/<id>', deleteGame);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
