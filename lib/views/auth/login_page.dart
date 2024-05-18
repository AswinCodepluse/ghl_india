import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/auth/password_forget.dart';
import 'package:ghl_callrecoding/views/dashboard/dashboard.dart';
import 'package:toast/toast.dart';
import '../../helpers/auth_helpers.dart';
import '../../repositories/auth_repositories.dart';
import '../../utils/colors.dart';
import '../../utils/toast_component.dart';
import 'components/btn_elements.dart';
import 'components/input_decorations.dart';
import 'components/loading_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _phone = "";
  bool _passwordVisible = false;
  String _login_by = "email";

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  onPressedLogin() async {
    // Loading.show(context);
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (email == "") {
      ToastComponent.showDialog("Enter Email",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    // else if ( _phone == "") {
    //   ToastComponent.showDialog(
    //       "",
    //       gravity: Toast.center,
    //       duration: Toast.lengthLong);
    //   return;
    // }
    else if (password == "") {
      ToastComponent.showDialog("Enter Password",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var loginResponse = await AuthRepository().getLoginResponse(
        _login_by == 'email' ? email : _phone, password, _login_by);
    // Loading.close();
    if (loginResponse.result == false) {
      if (loginResponse.message.runtimeType == List) {
        ToastComponent.showDialog(loginResponse.message!.splitMapJoin("\n"),
            gravity: Toast.center, duration: 3);
        return;
      }
      ToastComponent.showDialog(loginResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(loginResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);
      SharedPreference().setUserData(loginResponse: loginResponse);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return DashBoard();
      }), (newRoute) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      //drawer: MainDrawer(),
      backgroundColor: Colors.white,
      //appBar: buildAppBar(context),
      body: buildBody(context),
      // body: Stack(
      //   children: [
      //     Container(
      //       height: MediaQuery.of(context).size.height,
      //       width: MediaQuery.of(context).size.width,
      //       color: Color(0XFF9BD1E5),
      //       // alignment: Alignment.topRight,
      //       child: Image.asset(
      //         "assets/image/login_background.png",
      //       ),
      //     ),
      //     CustomScrollView(
      //       //controller: _mainScrollController,
      //       physics: const BouncingScrollPhysics(
      //           parent: AlwaysScrollableScrollPhysics()),
      //       slivers: [
      //         SliverList(
      //           delegate: SliverChildListDelegate(
      //             [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 48.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       padding: const EdgeInsets.symmetric(
      //                           horizontal: 8, vertical: 12),
      //                       width: 72,
      //                       height: 72,
      //                       decoration: BoxDecoration(
      //                           color: Colors.white,
      //                           borderRadius: BorderRadius.circular(8)),
      //                       child: Image.asset('assets/image/app_logo.jpg'),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(bottom: 20.0, top: 10),
      //                 child: Text(
      //                   'Welcome to GHL',
      //                   style: const TextStyle(
      //                       color: MyTheme.accent_color,
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.w600),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 18.0),
      //                 child: Container(
      //                   padding: const EdgeInsets.symmetric(vertical: 20),
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(6.0),
      //                     color: Colors.transparent,
      //                     // boxShadow: [
      //                     //   BoxShadow(
      //                     //     color: Colors.black.withOpacity(.08),
      //                     //     blurRadius: 20,
      //                     //     spreadRadius: 0.0,
      //                     //     offset: Offset(
      //                     //         0.0, 10.0), // shadow direction: bottom right
      //                     //   )
      //                     // ],
      //                   ),
      //                   child: buildBody(context),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/ghl_login_bg.png"),
                fit: BoxFit.fill
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("LOGIN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          SizedBox(height: 10,),
          Text("Please Log into your account",style: TextStyle(color: MyTheme.textfield_grey,fontSize: 16),),
          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width * (3 / 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    'Email',
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _emailController,
                          autofocus: false,
                          decoration: InputDecorations.buildInputDecoration_1(
                              hint_text: "Enter Username or Email"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    "Password",
                    style: const TextStyle(
                        color: Colors.red,
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
                          obscureText: !_passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "• • • • • • • •",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    _passwordVisible = !_passwordVisible;
                                  },
                                );
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: MyTheme.accent_color,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PasswordForget();
                          }));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: const TextStyle(
                              color: MyTheme.accent_color,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: Btn.minWidthFixHeight(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.red,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: Text(
                        "LOG IN",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressedLogin();
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
