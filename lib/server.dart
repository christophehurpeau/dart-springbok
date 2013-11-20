library springbok_server;

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:springbok_router/router.dart';
import 'package:http_server/http_server.dart';
import 'package:yaml/yaml.dart';

part './server/action.dart';

// TODO : status, message, details, responses html/json/xml...
Future _sendStatus(HttpResponse response, { int status: HttpStatus.NOT_FOUND, String message: 'Not Found' }){
  response.statusCode = status;
  if (message != null) response.write(message);
  return response.close();
}

start(Map<String, Map<String, Action>> controllers, final HOST, final PORT){
  assert(controllers != null && controllers.isNotEmpty);
  
  String current = Directory.current.path;
  if(current.endsWith('/bin')) current = current.substring(0, current.length-4);
  final basePath = current;
  final configPath = '$current/config';
  
  final Map config = loadYaml(new File('$configPath/config.yaml').readAsStringSync());
  
  assert(config.isNotEmpty);
  assert(config['allLangs'] is List && config['allLangs'].isNotEmpty);
  
  // Init
  final RoutesTranslations routesTranslations = new RoutesTranslations(
      loadYaml(new File('$configPath/routesTranslations.yaml').readAsStringSync()));
  final Router router = new Router(routesTranslations,
      loadYaml(new File('$configPath/routes.yaml').readAsStringSync()),
      config['allLangs']);
  
  
  // Start
  HttpServer.bind(HOST, PORT).then((HttpServer server) {
    server.listen((HttpRequest request) {
      final String path = Path.normalize(request.uri.path);
      print("${request.method} $path");
      
      if (!Path.isAbsolute(path)){
        print('!absolute :-( $path');
        return _sendStatus(request.response);
      }
      if (path == "/favicon.ico") {
        assert(new File('${basePath}/web${path}').existsSync());
        new File('${basePath}${path}').openRead().pipe(request.response).catchError((e){});
      } else if(path.startsWith('/web/')) {
        final File file = new File('${basePath}${path}');
        print('=> ${basePath}${path}');
        file.exists().then((bool found){
          if (!found) {
            return _sendStatus(request.response, message: 'File not found: ${path}');
          }
          file.openRead().pipe(request.response).catchError((e){});
        });
      } else {
        try {
          Route route = router.find(path);
          
          Map<String, Action> actions = controllers[route.controller];
          if (actions == null) {
            return _sendStatus(request.response);
          }
          
          Action action = actions[route.action];
          if (action == null) {
            return _sendStatus(request.response);
          }
          action.apply(request, request.response);
        } catch(e,stack) {
          return _sendStatus(request.response, status: HttpStatus.INTERNAL_SERVER_ERROR,
              message: 'Internal Server Error\n${e.toString()}\n${stack.toString()}');
        }
      }
    });
  });
}