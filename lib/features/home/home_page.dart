import 'package:flutter/material.dart';
import 'widgets/hub_header.dart';
import 'widgets/category_filter.dart';
import 'widgets/ai_card_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        HubHeader(),
        CategoryFilter(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Discover AI Hubs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        AICardGrid(),
      ],
    );
  }
}
