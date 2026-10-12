import 'package:flutter_riverpod/flutter_riverpod.dart';

class Topic {
  const Topic({required this.title, required this.summary});

  final String title;
  final String summary;
}

const labTopics = <Topic>[
  Topic(
    title: 'Repository',
    summary: 'The notes feature saves through NoteRepository.',
  ),
  Topic(
    title: 'Cubit',
    summary: 'Notes and the counter each own a cubit. They do not share state.',
  ),
  Topic(
    title: 'Riverpod',
    summary: 'This filter is a Notifier. It is created only on this route.',
  ),
  Topic(
    title: 'Result',
    summary: 'Load and save return Success or Failure instead of throwing.',
  ),
];

class TopicQuery extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

final topicQueryProvider = NotifierProvider<TopicQuery, String>(TopicQuery.new);

final visibleTopicsProvider = Provider<List<Topic>>((ref) {
  final query = ref.watch(topicQueryProvider).trim().toLowerCase();
  if (query.isEmpty) {
    return labTopics;
  }
  return labTopics.where((topic) {
    return topic.title.toLowerCase().contains(query) ||
        topic.summary.toLowerCase().contains(query);
  }).toList();
});
