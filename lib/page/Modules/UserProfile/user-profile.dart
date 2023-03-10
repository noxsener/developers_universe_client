import 'package:cached_network_image/cached_network_image.dart';
import 'package:developersuniverse_client/models/common-model.dart';
import 'package:developersuniverse_client/page/Modules/UserProfile/user-profile-controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../services/common-service.dart';
import '../../../services/translate-pipe.dart';
import '../../../webservices/user-service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  static String? token;
  static User? user;

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
  String username = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
  }

  @override
  bool get wantKeepAlive => true;

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SizedBox();  //RegisterPage(dataContext: dataContext);
    }));
  }

  void restorePassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SizedBox(); //ForgotPasswordPage();
    }));
  }

  void tryLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    loginCall(context, username, password).then((token) {
      UserProfile.token = token;
      if(UserProfile.token == null) {
        return;
      }
      LoginUserModel loginUserModel = LoginUserModel(refreshToken: UserProfile.token);
      loginByTokenRequest(context, loginUserModel).then((user) {
        UserProfile.user = user;
        if(UserProfile.user != null) {
          showAlertDialog(context,
              Text("Login Successful", style: theme.textTheme().titleSmall),
              Text("Login successful", style: theme.textTheme().bodySmall),
              [
            TextButton(
                onPressed: () => {
                  Navigator.pop(context)
                },
                child: Text(
                  "Ok",
                  style: theme.textTheme().button,
                ))
          ]);
          setState(() {

          });
        }
      });
    });


  }


  Widget registerButton() {
    return ElevatedButton(
      style: theme.positiveButtonStyle(),
      onPressed: () {
        register();
      },
      child: Text(
        transform("register"),
        style: theme.textTheme().labelSmall,
      ),
    );
  }

  Widget restorePasswordButton() {
    return ElevatedButton(
      style: theme.negativeButtonStyle(),
      onPressed: () {
        restorePassword();
      },
      child: Text(
        transform("forgotPassword"),
        style: theme.textTheme().bodyMedium!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (UserProfile.user == null) Container(
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
                                              borderRadius: BorderRadius.circular(10))),
                                      onPressed: () {

                                      }, child: Text("Forgot Password", style: theme.textTheme().bodySmall!.copyWith(inherit: true, color: Colors.white),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10))),
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
                                  //             borderRadius: BorderRadius.circular(10))),
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
                                              borderRadius: BorderRadius.circular(10))),
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
                  ),
                  if (UserProfile.user != null) Container(
                    width: size.shortestSide / (size.shortestSide < 900 ? 1
                        : size.shortestSide < 1200 ? 1.8 : 3.6),
                    height: size.shortestSide / (size.shortestSide < 900 ? 1
            : size.shortestSide < 1200 ? 1.8 : 3.6) * 0.6547619047694043,
                    decoration: BoxDecoration(
                       gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.bottomRight ,colors: [theme.cyanTransparent[100]!, theme.cyanTransparent[500]!]),
                        borderRadius: BorderRadius.circular(10),
                      // image: DecorationImage(
                      //   fit: BoxFit.cover,
                      //   image: CachedNetworkImageProvider(
                      //     'https://storage.cloudconvert.com/tasks/4e562b9f-45d6-40e3-925a-e4bdccc713d9/1600w-LqUfJRUvvrI.png?AWSAccessKeyId=cloudconvert-production&Expires=1673296721&Signature=mkYx4krhF0BorOvAE2bT0smgmlQ%3D&response-content-disposition=inline%3B%20filename%3D%221600w-LqUfJRUvvrI.png%22&response-content-type=image%2Fpng'),
                      //   ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("DevelopersUniverse ID Card", style: theme.textTheme().titleMedium,),
                            )),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(UserProfile.user!.name ?? UserProfile.user!.username!, style: theme.textTheme().titleSmall,),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text("Junior Flutter Developer", style: theme.textTheme().bodySmall,),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(right: 4),
                                                  child: Icon(FontAwesomeIcons.earthAmericas),
                                                ),
                                                Text("www.ihavenowebpage.com", style: theme.textTheme().bodySmall,)
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(right: 4),
                                                  child: Icon(FontAwesomeIcons.envelopeOpen),
                                                ),
                                                Text("ihavenoemail@notdomain.com", style: theme.textTheme().bodySmall,)
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(right: 4),
                                                  child: Icon(FontAwesomeIcons.phone),
                                                ),
                                                Text("+1 234 567 89 01", style: theme.textTheme().bodySmall,)
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(right: 4),
                                                  child: Icon(FontAwesomeIcons.locationDot),
                                                ),
                                                Text("Somewhere in planet", style: theme.textTheme().bodySmall,)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          child: CachedNetworkImage(
                                            fadeInCurve: Curves.easeInOut,
                                            fadeInDuration: const Duration(milliseconds: 200),
                                            imageUrl: 'https://c.pxhere.com/photos/37/2f/cat_red_cute_mackerel_tiger_sweet_cuddly_animal-675156.jpg!d',
                                            fit: BoxFit.scaleDown,
                                            progressIndicatorBuilder:
                                                (context, url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    color: theme.cyanTransparent,
                                                    value: downloadProgress.progress),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(const Uuid().v1(), style: theme.textTheme().bodySmall,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(UserProfile.user!.username!, style: theme.textTheme().bodySmall,),
                                      )
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),),
                ],
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      );
    });
  }
}
