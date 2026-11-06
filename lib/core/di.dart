import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../data/fact_service.dart';
import 'api_key_interceptor.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  if (getIt.isRegistered<FactService>()) return;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.api-ninjas.com/v1/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(ApiKeyInterceptor());
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ),
  );

  getIt.registerSingleton<Dio>(dio);
  getIt.registerLazySingleton<FactService>(() => FactService(getIt<Dio>()));
}
