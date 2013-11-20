part of springbok_server;

typedef void ActionCallback(HttpRequest request, HttpResponse response);

class Action {
  final ActionCallback callback;
  
  Action(this.callback);
  
  void apply(request, response){
    Function.apply(this.callback, [request, response]);
  }
}