library springbok_server;

import 'dart:io' hide File, HttpRequest, HttpResponse;
export 'dart:io' hide File, HttpRequest, HttpResponse;
import 'dart:io' as IoHttp show HttpRequest, HttpResponse;
import 'package:compiler/file.dart';
export 'package:compiler/file.dart';

import 'dart:async';
export 'dart:async';
import 'dart:convert';
export 'dart:convert';
import 'dart:collection';
export 'dart:collection';

import 'package:path/path.dart' as Path;

import 'package:springbok_router/router.dart';

import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';

import 'package:yaml/yaml.dart';
export 'package:yaml/yaml.dart';

import 'package:crypto/crypto.dart';
export 'package:crypto/crypto.dart';

part './server/action.dart';
part './server/http_request.dart';
part './server/http_response.dart';
part './server/cookies.dart';

String sha256(String data) {
  var sha = new SHA256();
  sha.add(data.codeUnits);
  var messageDigest = sha.close();
  return CryptoUtils.bytesToBase64(messageDigest);
}

final String BASE_PATH = (){
  String current = Directory.current.path;
  if(current.endsWith(Path.separator + 'bin')) current = current.substring(0, current.length-4);
  return current;
}();


final CONFIG_PATH = '$BASE_PATH/config';

final Map CONFIG = loadYaml(new File('$CONFIG_PATH/config.yaml').readAsStringSync());


start(Map<String, Map<String, Action>> controllers, final HOST, final PORT){
  assert(CONFIG.isNotEmpty);
  assert(CONFIG['allLangs'] is List && CONFIG['allLangs'].isNotEmpty);

  assert(controllers != null && controllers.isNotEmpty);
  
  // Init
  final RoutesTranslations routesTranslations = new RoutesTranslations(
      loadYaml(new File('$CONFIG_PATH/routesTranslations.yaml').readAsStringSync()));
  final Router router = new Router(routesTranslations,
      loadYaml(new File('$CONFIG_PATH/routes.yaml').readAsStringSync()),
      CONFIG['allLangs']);
  
  final urlPathBuilder = new Path.Builder(style: Path.Style.url);
  
  
  // Start
  HttpServer.bind(HOST, PORT).then((HttpServer server) {
    server.listen((IoHttp.HttpRequest _request) {
      final String path = urlPathBuilder.normalize(_request.uri.path);
      print("${_request.method} $path");
      
      if (path == "/favicon.ico") {
        assert(new File('${BASE_PATH}/web${path}').existsSync());
        new File('${BASE_PATH}${path}').openRead().pipe(_request.response).catchError((e){});
      } else if(path.startsWith('/web/')) {
        final File file = new File('${BASE_PATH}${path}');
        //print('=> ${basePath}${path}');
        file.exists().then((bool found){
          if (!found) {
            return _request.response
                ..statusCode = HttpStatus.NOT_FOUND
                ..headers.add(HttpHeaders.CONTENT_TYPE, 'text/plain')
                ..write('File not found: ${path}')
                ..close();
          }
          file.openRead().pipe(_request.response).catchError((e){});
        });
      } else {
        HttpRequest request = new HttpRequest.fromIoHttpRequest(_request);
        
        try {
          Route route = router.find(path);
          
          Map<String, Action> actions = controllers[route.controller];
          if (actions == null) {
            return request.response.sendSimpleResponse(message: 'Controller ${route.controller} not found');
          }
          
          Action action = actions[route.action];
          if (action == null) {
            return request.response.sendSimpleResponse(message: 'Action ${route.action} not found');
          }
          action.apply(request, request.response);
        } catch (e, stack) {
          print(e);
          print(stack);
          return request.response.sendSimpleResponse(status: HttpStatus.INTERNAL_SERVER_ERROR,
              message: 'Internal Server Error\n${e.toString()}\n${stack.toString()}');
        }
      }
    });
  });
}