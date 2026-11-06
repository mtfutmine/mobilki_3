import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/di.dart';
import '../data/fact.dart';
import '../data/fact_service.dart';

class FactsPage extends StatefulWidget {
  const FactsPage({super.key});

  @override
  State<FactsPage> createState() => _FactsPageState();
}

class _FactsPageState extends State<FactsPage> {
  final _searchController = TextEditingController();
  List<Fact> _facts = const [];
  bool _loading = false;
  String? _error;

  List<Fact> get _visibleFacts {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _facts;
    return _facts.where((fact) => fact.text.toLowerCase().contains(query)).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _loadFacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFacts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final facts = await getIt<FactService>().fetchFacts();
      if (!mounted) return;
      setState(() => _facts = facts);
    } on DioException catch (error) {
      if (!mounted) return;
      final status = error.response?.statusCode;
      setState(() {
        _error = status == 401 || status == 403
            ? 'API-ключ не принят. Запустите приложение с --dart-define=API_NINJAS_KEY=...'
            : 'Не удалось получить данные. Проверьте интернет и повторите попытку.';
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'Произошла непредвиденная ошибка.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final facts = _visibleFacts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Интересные факты'),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            onPressed: _loading ? null : _loadFacts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск по загруженным фактам',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) _ErrorView(message: _error!, onRetry: _loadFacts),
            if (_error == null && !_loading && facts.isEmpty)
              const Expanded(child: Center(child: Text('Факты не найдены'))),
            if (_error == null && facts.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: facts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _FactCard(fact: facts[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.fact});

  final Fact fact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(fact.text, style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
