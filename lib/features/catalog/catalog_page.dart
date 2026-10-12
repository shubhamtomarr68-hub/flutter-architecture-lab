import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/components.dart';
import 'catalog_providers.dart';

/// Riverpod is limited to this route's [ProviderScope].
/// The notes feature does not watch these providers.
class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(visibleTopicsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              key: const Key('topic-search'),
              decoration: const InputDecoration(
                hintText: 'Filter topics',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: ref.read(topicQueryProvider.notifier).setQuery,
            ),
          ),
          Expanded(
            child: topics.isEmpty
                ? const StatusView(message: 'No topics match this filter.')
                : ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return ListTile(
                        title: Text(topic.title),
                        subtitle: Text(topic.summary),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
