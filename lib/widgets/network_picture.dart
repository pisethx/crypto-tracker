import 'package:crypto_tracker/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkPicture extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String url;

  const NetworkPicture({
    this.width,
    this.height,
    this.radius = 0,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = url.endsWith('.svg');
    double _width = width ?? radius * 2;
    double _height = height ?? radius * 2;

    return Container(
      child: url != null && url != ''
          ? isSvg
              ? SvgPicture.network(
                  url,
                  width: _width,
                  height: _height,
                  fit: BoxFit.contain,
                  placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
                )
              : CachedNetworkImage(
                  width: _width,
                  height: _height,
                  imageUrl: url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
          : CircleAvatar(
              radius: radius,
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.error_outline, color: Colors.white),
            ),
    );
  }
}
