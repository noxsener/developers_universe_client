import 'package:developersuniverse_client/page/Modules/UserLogin/user-profile-controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../component/progress_button_flykobi.dart';
import '../../../services/common-service.dart';
import '../../../services/translate-pipe.dart';

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
  ButtonState girisButtonState = ButtonState.idle;
  String kullaniciAdi = "admin";
  String sifre = "12345678";

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

  void girisDene() async {
    /*
    if (girisButtonState != ButtonState.idle) {
      showSnackBar(context, transform("pleaseWait"));
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    LoginUserModel loginUserModel = LoginUserModel();
    loginUserModel.kullaniciAdi = kullaniciAdi;
    loginUserModel.sifre = sifre;
    String jsonRequest = jsonEncode(loginUserModel.toJson());

    setState(() {
      girisButtonState = ButtonState.loading;
    });

    HClient()
        .post(uaaServiceLogin, jsonRequest)
        .then((response) => {
      setState(() {
        if (response.statusCode != 200) {
          girisButtonState = ButtonState.fail;
          errorHandler(context, response);
          Future.delayed(
              const Duration(seconds: 2),
                  () => {
                setState(() {
                  if (girisButtonState != ButtonState.idle) {
                    girisButtonState = ButtonState.idle;
                  }
                })
              });
          return;
        }
        Map<String, dynamic> value = jsonDecode(utf8.decode(response.bodyBytes));
        if (value["kullanici"] != null) {
          dataContext.kullanici = Kullanici.fromJSON(value["kullanici"]);
        }
        dataContext.kullaniciKurumYetkiList = [];
        if (value["yetkiList"] != null) {
          for (int i = 0; i < value["yetkiList"].length; i++) {
            dataContext.kullaniciKurumYetkiList!.add(KullaniciKurumYetki.fromJSON(value["yetkiList"][i]));
          }
        }
        if (dataContext.kullaniciKurumYetkiList!.isNotEmpty) {
          dataContext.seciliKullaniciKurumYetki = dataContext.kullaniciKurumYetkiList![0];
          if (dataContext.seciliKullaniciKurumYetki != null) {
            if (dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciIsletmeYetkiList != null && dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciIsletmeYetkiList!.isNotEmpty) {
              dataContext.seciliKullaniciIsletmeYetki = dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciIsletmeYetkiList![0];
              dataContext.kullaniciIsletmeYetkiList = dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciIsletmeYetkiList;
            }
            if (dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciStokDepoYetkiList != null && dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciStokDepoYetkiList!.isNotEmpty) {
              dataContext.seciliKullaniciStokDepoYetki = dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciStokDepoYetkiList![0];
              dataContext.kullaniciStokDepoYetkiList = dataContext.seciliKullaniciKurumYetki!.kurum!.kullaniciStokDepoYetkiList;
            }
          }
        }
        girisButtonState = ButtonState.success;
        kullaniciAdi = "";
        sifre = "";
        _usernameController.clear();
        _passwordController.clear();

        Future.delayed(
            const Duration(seconds: 2),
                () => {
              setState(() {
                if (girisButtonState == ButtonState.fail) {
                  girisButtonState = ButtonState.idle;
                  return;
                }
                if(dataContext.kullanici != null && dataContext.kullanici!.language == "tr_TR") {
                  locale = const Locale("tr","TR");
                } else {
                  locale = const Locale("en","US");
                }
                girisButtonState = ButtonState.idle;
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DashboardPage(dataContext: dataContext);
                }));
              })
            });

      })
    })
        .onError((error, stackTrace) {

      setState(() {
        girisButtonState = ButtonState.fail;
      });
      return Future.delayed(
          const Duration(seconds: 2),
              () => {
            setState(() {
              if (girisButtonState != ButtonState.idle) {
                girisButtonState = ButtonState.idle;
              }
            })
          });
    }); */
  }

  Widget getGirisButton() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(text: transform("login"), icon: const Icon(Icons.send, color: Colors.white), color: Colors.blue.shade700, textStyle: theme.textTheme.bodyMedium!),
      ButtonState.loading: IconedButton(text: transform("pleaseWait"), color: Color(0xFF6A1B9A), textStyle: theme.textTheme.bodyMedium!),
      ButtonState.fail: IconedButton(text: transform("error"), icon: Icon(Icons.cancel, color: Colors.white), color: Color(0xFFC10685), textStyle: theme.textTheme.bodyMedium!),
      ButtonState.success: IconedButton(
          text: "Başarılı",
          icon: const Icon(
            FontAwesomeIcons.check,
            color: Colors.white,
          ),
          color: Colors.green.shade400,
          textStyle: theme.textTheme.bodyMedium!),
    }, onPressed: girisDene, state: girisButtonState);
  }

  Widget getKayitOlButton() {
    return ElevatedButton(
      style: theme.positiveButtonStyle(),
      onPressed: () {
        kayitOl();
      },
      child: Text(
        transform("register"),
        style: theme.textTheme.labelSmall,
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
        style: theme.textTheme.bodyMedium!,
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
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * (size.width < 737
                      ? 0.95
                      : size.width < 981
                      ? 0.8
                      : 0.5),
                  height: 400,
                  decoration: BoxDecoration(
                    color: theme.cyanTransparent[200],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _usernameController,
                            onChanged: (text) => kullaniciAdi = text,
                            style: theme.inputFieldStyle,
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
                            onChanged: (text) => sifre = text,
                            obscureText: !showPassword,
                            style: theme.inputFieldStyle,
                            decoration: InputDecoration(
                                labelText: transform("password"),
                                suffixIcon: IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      showPassword = !showPassword;
                                    })
                                  },
                                  icon: Icon((showPassword) ? FontAwesomeIcons.unlockKeyhole : FontAwesomeIcons.lock, size: 17),
                                )),
                          ),
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
