import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghl_callrecoding/views/auth/login_page.dart';
import 'package:toast/toast.dart';
import '../../repositories/auth_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/toast_component.dart';
import 'components/btn_elements.dart';
import 'components/input_decorations.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';

class PasswordOtp extends StatefulWidget {
  PasswordOtp({Key? key, this.verify_by = "email", this.email_or_code})
      : super(key: key);
  final String verify_by;
  final String? email_or_code;

  @override
  _PasswordOtpState createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  //controllers
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool _resetPasswordSuccess = false;

  String headeText = "";

  FlipCardController cardController = FlipCardController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      headeText = "Enter the Code sent";
      setState(() {});
    });
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressConfirm() async {
    var code = _codeController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (code == "") {
      ToastComponent.showDialog("Enter the Code",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog("Enter Password",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog("Confirm Your Password",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog("Password must contain atleast 6 characters",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog("Password does not matched",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var passwordConfirmResponse =
        await AuthRepository().getPasswordConfirmResponse(code, password);

    if (passwordConfirmResponse.result == false) {
      ToastComponent.showDialog(passwordConfirmResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordConfirmResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);

      headeText = "Password Changed";
      cardController.toggleCard();
      setState(() {});
    }
  }

  onTapResend() async {
    var passwordResendCodeResponse = await AuthRepository()
        .getPasswordResendCodeResponse(widget.email_or_code, widget.verify_by);

    if (passwordResendCodeResponse.result == false) {
      ToastComponent.showDialog(passwordResendCodeResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordResendCodeResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  gotoLoginScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      //key: _scaffoldKey,
      //drawer: MainDrawer(),
      backgroundColor: Colors.white,
      //appBar: buildAppBar(context),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0XFF9BD1E5),
            // alignment: Alignment.topRight,
            child: Image.asset(
              "assets/image/login_background.png",
            ),
          ),
          CustomScrollView(
            //controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Image.asset('assets/image/app_logo.jpg'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                      child: Text(
                        'Password OTP',
                        style: const TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.transparent,
                        ),
                        child: buildBody(context, _verify_by),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
    // return AuthScreen.buildScreen(
    //     context,
    //     headeText,
    //     WillPopScope(
    //         onWillPop: (){
    //           gotoLoginScreen();
    //           return Future.delayed(Duration.zero);
    //         },
    //         child: buildBody(context, _screen_width, _verify_by)));
  }

  Widget buildBody(BuildContext context, String _verify_by) {
    return FlipCard(
      flipOnTouch: false,
      controller: cardController,
      //fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL,
      // default
      front: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * (3 / 4),
                  child: _verify_by == "email"
                      ? Text(
                          "Enter the verification code that sent to your email recently.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: MyTheme.dark_grey, fontSize: 14))
                      : Text(
                          "Enter the verification code that sent to your phone recently.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.dark_grey, fontSize: 14))),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (3 / 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Enter the code',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _codeController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "A X B 4 J H"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "• • • • • • • •"),
                          ),
                        ),
                        Text(
                          "Password Must Have atleast 6 characters",
                          style: TextStyle(
                              color: MyTheme.textfield_grey,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "Retype Password",
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 36,
                      child: TextField(
                        controller: _passwordConfirmController,
                        autofocus: false,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "• • • • • • • •"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: Btn.basic(
                        minWidth: MediaQuery.of(context).size.width,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressConfirm();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: InkWell(
                onTap: () {
                  onTapResend();
                },
                child: Text(
                  "Resend Code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      decoration: TextDecoration.underline,
                      fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
      back: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * (3 / 4),
                  child: Text("Congratulations",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * (3 / 4),
                child: Text(
                  "You have successfully changed your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset(
                'assets/changed_password.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    "Back to Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    gotoLoginScreen();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
