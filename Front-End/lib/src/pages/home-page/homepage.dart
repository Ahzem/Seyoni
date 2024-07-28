import 'package:flutter/material.dart';
import '../../constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: CustomAppBar(),
      ),
    );
  }
}
