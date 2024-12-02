import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/ui/utils/assets_path.dart';
import '../widgets/background_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String name = '/';

  const SplashScreen({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
        child: Center(
          child: SvgPicture.asset(
            AssetsPath.logo,
          ),
        ),
      ),
    );
  }
}
