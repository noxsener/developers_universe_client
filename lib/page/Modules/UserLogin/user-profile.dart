import 'package:developersuniverse_client/page/Modules/UserLogin/user-profile-controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../component/progress_button_flykobi.dart';
import '../../../services/common-service.dart';
import '../../../services/translate-pipe.dart';
import '../../../webservices/user-profile-service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<UserProfile> {
  final c = Get.put(UserProfileController());

  bool landscape = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  String username = "admin";
  String password = "12345678";

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
  }

  @override
  bool get wantKeepAlive => true;

  void kayitOl() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SizedBox();  //RegisterPage(dataContext: dataContext);
    }));
  }

  void sifremiUnuttum() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SizedBox(); //ForgotPasswordPage();
    }));
  }

  void tryLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String? token = await loginCall(context, username, password);
    showAlertDialog(context, Text("Login Success", style: theme.textTheme().titleSmall,), Text(token ?? "???", style: theme.textTheme().bodySmall,), [
      TextButton(
          onPressed: () => {
            Navigator.pop(context)
          },
          child: Text(
            transform("accept"),
            style: theme.textTheme().button,
          ))
    ]);
  }


  Widget getKayitOlButton() {
    return ElevatedButton(
      style: theme.positiveButtonStyle(),
      onPressed: () {
        kayitOl();
      },
      child: Text(
        transform("register"),
        style: theme.textTheme().labelSmall,
      ),
    );
  }

  Widget sifremiUnuttumButton() {
    return ElevatedButton(
      style: theme.negativeButtonStyle(),
      onPressed: () {
        sifremiUnuttum();
      },
      child: Text(
        transform("forgotPassword"),
        style: theme.textTheme().bodyMedium!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * (size.width < 800
                      ? 0.95
                      : size.width < 1000
                      ? 0.8
                      : 0.5),
                  decoration: BoxDecoration(
                    color: theme.cyanTransparent[200],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _usernameController,
                            onChanged: (text) => username = text,
                            style: theme.inputFieldStyle(),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return transform("usernameInvalid");
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: transform("username"),
                              suffixIcon: const Icon(FontAwesomeIcons.user),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return transform("enterCurrentPassword");
                              }
                              return null;
                            },
                            onChanged: (text) => password = text,
                            obscureText: !showPassword,
                            style: theme.inputFieldStyle(),
                            decoration: InputDecoration(
                                labelText: transform("password"),
                                suffixIcon: IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      showPassword = !showPassword;
                                    })
                                  },
                                  icon: Icon((showPassword) ? FontAwesomeIcons.unlockKeyhole : FontAwesomeIcons.lock, size: 17, color: Colors.white),
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50))),
                                    onPressed: () {

                                    }, child: Text("Forgot Password", style: theme.textTheme().bodySmall!.copyWith(inherit: true, color: Colors.white),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50))),
                                    onPressed: () {

                                    }, child: Text("Sign Up", style: theme.textTheme().bodySmall!.copyWith(inherit: true, color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: OutlinedButton(
                                //     style: OutlinedButton.styleFrom(
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(50))),
                                //     onPressed: () {
                                //
                                //     }, child: Text("Cancel", style: theme.textTheme().bodySmall!.copyWith(inherit: true, color: Colors.white),),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan,
                                        disabledBackgroundColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50))),
                                    onPressed: () => tryLogin(), child: Text("Login", style: theme.textTheme().bodySmall!.copyWith(inherit: true, color: Colors.white),),
                                  ),

                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
          ],
        ),
      );
    });
  }
}
