import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  int _maxCharactersPerLine = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ("<-- HTTP -->");
    ("--> ${options.headers}");
    ("--> ${options.data.toString()}");
    ("--> ${options.method}");
    ("--> ${options.path}");
    ("--> ${options.contentType}");
    ("<-- END HTTP -->");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    (
        "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
          (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        (
            responseAsString.substring(i * _maxCharactersPerLine, endingIndex));
      }
    } else {
      (response.data);
    }

    ("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    ("<-- Error -->");
    (err.error);
    print(err.message);
    super.onError(err, handler);
  }
}
