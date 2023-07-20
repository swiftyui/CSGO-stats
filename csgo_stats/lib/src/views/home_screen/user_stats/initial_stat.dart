import 'package:csgo_stats/src/utils/image_list.dart';
import 'package:flutter/material.dart';

class InitialItem {
  final String name;
  final num value;
  final String imageUrl;

  const InitialItem({
    required this.name,
    required this.value,
    required this.imageUrl,
  });
}

class InitialStats extends StatelessWidget {
  InitialStats({super.key});
  final List<InitialItem> _items = [
    InitialItem(
      name: 'Total Kills',
      value: 23,
      imageUrl: ImageList.kills.value,
    ),
    InitialItem(
      name: 'Total Detaths',
      value: 12,
      imageUrl: ImageList.death.value,
    ),
    InitialItem(
      name: 'Total Time Played',
      value: 27,
      imageUrl: ImageList.time.value,
    ),
    InitialItem(
      name: 'Total Bombs Planted',
      value: 12,
      imageUrl: ImageList.bomb.value,
    ),
    InitialItem(
      name: 'Total Bombs Defused',
      value: 77,
      imageUrl: ImageList.defuse.value,
    ),
    InitialItem(
      name: 'Total Wins',
      value: 23,
      imageUrl: ImageList.win.value,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      thumbVisibility: false,
      radius: const Radius.circular(100),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _items.length,
          itemBuilder: (BuildContext ctx, index) {
            return _buildStatCard(context, _items[index]);
          }),
    );
  }

  Widget _buildStatCard(BuildContext context, InitialItem item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text('${item.value}',
                style: Theme.of(context).textTheme.bodyMedium),
            Image.asset(item.imageUrl)
          ],
        ),
      ),
    );
  }
}
