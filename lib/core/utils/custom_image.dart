import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String placeholder;
  final Color? color; // 👈 make nullable

  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = ImageAsset.noInternetImage,
    this.color, // 👈 optional now
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,

      // 👇 Only apply color if provided
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,

      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),

      placeholder: (context, url) => Image.asset(
        placeholder,
        height: height,
        width: width,
        fit: fit,
      ),

      errorWidget: (context, url, error) => Image.asset(
        placeholder,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
