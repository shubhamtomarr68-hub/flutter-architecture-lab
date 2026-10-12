import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../design/components.dart';
import 'counter_cubit.dart';

/// A cubit that exists only on this route.
/// It does not read the notes cubit and it is not registered in GetIt.
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This cubit is created when the route opens and disposed when it closes. The notes list does not change when this number changes.',
            ),
            const SizedBox(height: 24),
            Text(
              '$count',
              key: const Key('counter-value'),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                AppButton(
                  label: 'Minus',
                  onPressed: () => context.read<CounterCubit>().decrement(),
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: 'Plus',
                  onPressed: () => context.read<CounterCubit>().increment(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
