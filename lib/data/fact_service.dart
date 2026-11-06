import 'package:dio/dio.dart';

import 'fact.dart';

class FactService {
  FactService(this._dio);

  final Dio _dio;

  static const _customFacts = <Fact>[
    Fact(text: 'Давид гей'),
    Fact(text: 'Карпуха кобель'),
    Fact(text: 'Аким дырявый'),
    Fact(text: 'Владос легенда'),
  ];

  Future<List<Fact>> fetchFacts() async {
    final response = await _dio.get<List<dynamic>>('facts');
    final data = response.data ?? const <dynamic>[];
    final apiFacts = data
        .whereType<Map<String, dynamic>>()
        .map(Fact.fromJson)
        .toList();
    return [..._customFacts, ...apiFacts];
  }
}
