import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/ui/utils/assets_path.dart';

class BackgroundScreen extends StatelessWidget {
  const BackgroundScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  // final double? width;
  // final double? height;
  // final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: SvgPicture.asset(
            AssetsPath.background,
            semanticsLabel: "Background",
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
