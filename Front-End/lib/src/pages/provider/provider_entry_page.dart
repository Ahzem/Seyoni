import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';
import '../../config/route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_font.dart';
import 'components/register_button.dart';

class ProviderEntryPage extends StatelessWidget {
  const ProviderEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    height: height * 0.08,
                  ),
                  SizedBox(height: height * 0.01), // Adjusted spacing
                  Center(
                    child: SvgPicture.asset(
                      'assets/svg/technicians-1.svg',
                      height: height * 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kContainerColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: kBoarderColor,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Become a Service Provider',
                      style: kTitleTextStyle,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Join our platform as a service provider and start earning money by providing services to customers.',
                      style: kBodyTextStyle,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryOutlinedButton(
                          text: 'Sign In',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoutes.providerSignIn);
                          },
                        ),
                        Container(width: 15),
                        PrimaryFilledButton(
                          text: 'Sign Up',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoutes.providerSignUp);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Register as a service seeker',
                          style: kBodyTextStyle,
                        ),
                        RegisterFlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signUp);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
