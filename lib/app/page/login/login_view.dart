import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/page/login/login_controller.dart';
import 'package:tdv2_showcase_mobile/app/util/assets.dart';
import 'package:tdv2_showcase_mobile/app/widget/main_text_field.dart';
import 'package:tdv2_showcase_mobile/app/widget/primary_elevated_button.dart';
import 'package:tdv2_showcase_mobile/data/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/device/repo/fazpass_repository.dart';

class LoginView extends View {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends ViewState<LoginView, LoginController> {
  LoginViewState() : super(LoginController(DataLoginRepository(), DeviceFazpassRepository()));

  final _phoneController = TextEditingController();

  @override
  Widget get view => Scaffold(
    key: globalKey,
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        Positioned.fromRelativeRect(
          rect: const RelativeRect.fromLTRB(-80, -80, -80, -80),
          child: Image.asset(AppAssets.backgroundImage),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(top: 24),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Center(
                  child: Text(
                    'Marketplacebo',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  'Start browsing our market and get the best deal you could ever think of!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              ControlledWidgetBuilder<LoginController>(
                builder: (context, controller) => Card(
                  color: const Color.fromRGBO(255, 255, 255, .9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Join Us!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: MainTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        PrimaryElevatedButton(
                          onClick: controller.isLoading
                              ? null
                              : () => controller.login(_phoneController.text),
                          label: 'Sign me in!',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}