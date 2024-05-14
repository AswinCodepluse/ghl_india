import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghl_callrecoding/views/auth/password_otp.dart';
import 'package:toast/toast.dart';
import '../../repositories/auth_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/toast_component.dart';
import 'components/btn_elements.dart';
import 'components/input_decorations.dart';

class PasswordForget extends StatefulWidget {
  @override
  _PasswordForgetState createState() => _PasswordForgetState();
}

class _PasswordForgetState extends State<PasswordForget> {
  String _send_code_by = "email"; //phone or email
  String initialCountry = 'US';
  // PhoneNumber phoneCode = PhoneNumber(isoCode: 'US');
  String? _phone = "";
  var countries_code = <String?>[];
  //controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    // fetch_country();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressSendCode() async {
    var email = _emailController.text.toString();

    if (_send_code_by == 'email' && email == "") {
      ToastComponent.showDialog("Enter Email",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_send_code_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          "Enter Phone Number",
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var passwordForgetResponse = await AuthRepository()
        .getPasswordForgetResponse(
        _send_code_by == 'email' ? email : _phone, _send_code_by);

    if (passwordForgetResponse.result == false) {
      ToastComponent.showDialog(passwordForgetResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordForgetResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PasswordOtp(
          verify_by: _send_code_by,
        );
      }));
    }
  }

  // fetch_country() async {
  //   var data = await AddressRepository().getCountryList();
  //   data.countries.forEach((c) => countries_code.add(c.code));
  // }

  @override
  Widget build(BuildContext context) {
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
                        'Password Forgot',
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
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(.08),
                          //     blurRadius: 20,
                          //     spreadRadius: 0.0,
                          //     offset: Offset(
                          //         0.0, 10.0), // shadow direction: bottom right
                          //   )
                          // ],
                        ),
                        child: buildBody(context),
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
  }

  Column buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                   "Email",

                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              if (_send_code_by == "email")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 36,
                        child: TextField(
                          controller: _emailController,
                          autofocus: false,
                          decoration: InputDecorations.buildInputDecoration_1(
                              hint_text: "johndoe@example.com"),
                        ),
                      ),
                    ],
                  ),
                )
              // else
              //   Padding(
              //     padding: const EdgeInsets.only(bottom: 8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Container(
              //           height: 36,
              //           child: CustomInternationalPhoneNumberInput(
              //             countries: countries_code,
              //             onInputChanged: (PhoneNumber number) {
              //               //print(number.phoneNumber);
              //               setState(() {
              //                 _phone = number.phoneNumber;
              //               });
              //             },
              //             onInputValidated: (bool value) {
              //               //print(value);
              //             },
              //             selectorConfig: SelectorConfig(
              //               selectorType: PhoneInputSelectorType.DIALOG,
              //             ),
              //             ignoreBlank: false,
              //             autoValidateMode: AutovalidateMode.disabled,
              //             selectorTextStyle:
              //             TextStyle(color: MyTheme.font_grey),
              //             // initialValue: phoneCode,
              //             textFieldController: _phoneNumberController,
              //             formatInput: true,
              //             keyboardType: TextInputType.numberWithOptions(
              //                 signed: true, decimal: true),
              //             inputDecoration:
              //             InputDecorations.buildInputDecoration_phone(
              //                 hint_text: "01710 333 558"),
              //             onSaved: (PhoneNumber number) {
              //               //print('On Saved: $number');
              //             },
              //           ),
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             setState(() {
              //               _send_code_by = "email";
              //             });
              //           },
              //           child: Text(
              //             AppLocalizations.of(context)!.or_send_code_via_email,
              //             style: TextStyle(
              //                 color: MyTheme.accent_color,
              //                 fontStyle: FontStyle.italic,
              //                 decoration: TextDecoration.underline),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              ,
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  height: 45,
                  child: Btn.basic(
                    minWidth: MediaQuery.of(context).size.width,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      "Send Code",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onPressSendCode();
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
