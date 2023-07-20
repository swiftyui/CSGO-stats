import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class StatsLoading extends StatefulWidget {
  const StatsLoading({super.key});

  @override
  State<StatsLoading> createState() => _StatsLoadingState();
}

class _StatsLoadingState extends State<StatsLoading> {
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
          itemCount: 6,
          itemBuilder: (BuildContext ctx, _) {
            return _buildLoadingCard(context);
          }),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
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
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                height: 80,
                width: 80,
              ),
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15,
                width: MediaQuery.of(context).size.width,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
