import 'package:flutter/material.dart';

class InitialItem {
  final String name;
  final num value;

  const InitialItem({
    required this.name,
    required this.value,
  });
}

class InitialStats extends StatelessWidget {
  InitialStats({super.key});
  final List<InitialItem> _items = [
    const InitialItem(name: 'Total Kills', value: 23),
    const InitialItem(name: 'Total Detaths', value: 23),
    const InitialItem(name: 'Total Time Played', value: 23),
    const InitialItem(name: 'Total Planted Bombs', value: 23),
    const InitialItem(name: 'Total Bombs Defused', value: 23),
    const InitialItem(name: 'Total Wins', value: 23),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: _items.length,
          itemBuilder: (BuildContext ctx, index) {
            return _buildStatCard(context, _items[index]);
          }),
    );
  }

  Widget _buildStatCard(BuildContext context, InitialItem item) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(item.name),
          Text('${item.value}'),
        ],
      ),
    );
  }
}
