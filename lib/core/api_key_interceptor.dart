import 'package:dio/dio.dart';

class ApiKeyInterceptor extends Interceptor {
  static const _apiKey = String.fromEnvironment('API_NINJAS_KEY');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_apiKey.isNotEmpty) {
      options.headers['X-Api-Key'] = _apiKey;
    }
    handler.next(options);
  }
}
