import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MenuItemImage extends StatelessWidget {
  final String imageUrl;
  double iconSize = 48;

  MenuItemImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        height: iconSize,
        width: iconSize,
        placeholder: (context, url) =>
            Lottie.asset('packages/craft_dynamic/assets/lottie/loading.json'),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
}

class MenuItemTitle extends StatelessWidget {
  final String title;

  const MenuItemTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Flexible(
          child: Text(
        title,
        // overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
      ));
}
