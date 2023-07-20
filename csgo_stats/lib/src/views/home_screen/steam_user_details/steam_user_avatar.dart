import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SteamUserAvatar extends StatefulWidget {
  final double width;
  final double height;
  final String? imageUrl;

  const SteamUserAvatar({
    super.key,
    required this.height,
    required this.width,
    this.imageUrl,
  });

  @override
  State<SteamUserAvatar> createState() => _SteamUserAvatar();
}

class _SteamUserAvatar extends State<SteamUserAvatar> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl ?? '',
      imageBuilder: (context, imageProvider) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: Image(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return _buildAvatarLoading(context);
      },
      errorWidget: (context, url, error) {
        return _buildNoAvatar(context);
      },
    );
  }

  Widget _buildNoAvatar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: SizedBox(
          child: Image.asset(
            'assets/images/default_user_image.png',
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarLoading(BuildContext context) {
    return SkeletonAvatar(
      style: SkeletonAvatarStyle(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        height: widget.height,
        width: widget.width,
      ),
    );
  }
}
