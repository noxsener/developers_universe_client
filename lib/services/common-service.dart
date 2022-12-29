library commonService;

import "dart:convert";

import 'package:developersuniverse_client/services/theme.dart';
import 'package:developersuniverse_client/services/translate-pipe.dart';
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:http/http.dart";
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher.dart";

import "dart:convert" show utf8;

import '../models/common-model.dart';

bool appCanCall = false;
bool appCanSms = false;
bool appCanHttp = false;
bool appCanHttps = false;

DateFormat dateFormat = DateFormat("dd.MM.yyyy");
DateFormat dateFormatDetailed = DateFormat("dd.MM.yyyy HH:mm:ss");
DateFormat dateFormatOnlyTime = DateFormat("HH:mm:ss");
DateFormat iso8601WithZone = DateFormat("yyyy-MM-ddTHH:mm:ssZ","en-US");
NumberFormat moneyFormat = NumberFormat("#.00");
Locale locale = const Locale("en");
RegExp emailRegex = RegExp(r"^[a-zA-Z][._a-zA-Z0-9]+[@][a-zA-Z][._a-zA-Z0-9]+[.][a-zA-Z0-9]{2,12}([.][a-zA-Z0-9]{2,12})?$", caseSensitive: true, multiLine: false);
RegExp integerRegex = RegExp(r"^[0-9]*$", caseSensitive: true, multiLine: false);
RegExp imageRegex = RegExp(r".*(jpg|jpeg|png|webp|gif)", caseSensitive: false);

CodenfastTheme theme = CodenfastTheme();
DateTime? time;

String uaaServiceLogin = "/uaa/login";

Future<void> init(BuildContext context) async {

  initTranslate(context);
  canLaunch("tel:+908501234567").then((bool result) {
    appCanCall = result;
  }).onError((error, stackTrace) {
    appCanCall = false;
  });
  canLaunch("sms:+908501234567").then((bool result) {
    appCanSms = result;
  }).onError((error, stackTrace) {
    appCanSms = false;
  });
  canLaunch("http://codenfast.com").then((bool result) {
    appCanHttp = result;
  }).onError((error, stackTrace) {
    appCanHttp = false;
  });
  canLaunch("https://codenfast.com").then((bool result) {
    appCanHttps = result;
  }).onError((error, stackTrace) {
    appCanHttps = false;
  });
}

List<Color> colorList = [
  const Color(0xFFc62828),
  const Color(0xFF6a1b9a),
  const Color(0xFF4527a0),
  const Color(0xFF1565c0),
  const Color(0xFF0277bd),
  const Color(0xFF00695c),
  const Color(0xFF2e7d32),
  const Color(0xFF9e9d24),
  const Color(0xFFf9a825),
  const Color(0xFFef6c00),
  const Color(0xFFd84315),
  const Color(0xFF4e342e),
  const Color(0xFF37474f),
  const Color(0xFFad1457),
  const Color(0xFF283593),
  const Color(0xFF00838f),
  const Color(0xFF558b2f),
  const Color(0xFFff8f00),
  const Color(0xFF4e342e)
];

DateTime get now {
  return time != null ? time!.toUtc() :  DateTime.now().toUtc();
}

class CodenfastPageRoute extends MaterialPageRoute {
  CodenfastPageRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: theme.animationDuration);
}

double getGridSquareAspectRatio(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return size.width < 737
      ? (size.aspectRatio / 0.33)
      : size.width < 981
      ? (size.aspectRatio / 0.643)
      : (size.aspectRatio / 1.3);
}

Visibility generateVisibleWidget(Widget widget, bool isShow, bool stillCollapsingArea) {
  return Visibility(
    child: widget,
    maintainSize: stillCollapsingArea,
    maintainAnimation: stillCollapsingArea,
    maintainState: stillCollapsingArea,
    visible: isShow,
  );
}

showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text, style: theme.normal()),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

errorHandler(BuildContext context, Response response) {
  String errorTitle = "error";
  String errorMessage = "";
  ErrorObject? errorObject;
  if (response != null && response.body != null) {
    try {
      errorObject = ErrorObject.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (parseError) {}
  }

  if(errorObject != null && errorObject.error != null && errorObject.error!.isNotEmpty) {
    errorTitle = errorObject.error!;
  }
  if(errorObject != null && errorObject.message != null && errorObject.message!.isNotEmpty) {
    errorMessage = errorObject.message!;
  }

  if (errorMessage == "" && response != null && response.statusCode == 403) {
    errorMessage = "unAuthorizedAccess";
  } else if (errorMessage == "" && response != null && response.statusCode == 401) {
    errorMessage = "loginFailed";
  }

  showAlertDialog(
      context,
      Text(
        transform(errorTitle),
        overflow: TextOverflow.fade,
        maxLines: 5,
        softWrap: true,
        style: theme.h1CrossColor(),
      ),
      Text(
        transform(errorMessage),
        overflow: TextOverflow.fade,
        maxLines: 5,
        softWrap: true,
        style: theme.normalCrossColor(),
      ),
      [
        TextButton(
            onPressed: () => {
              Navigator.pop(context)
            },
            child: Text(
              transform("accept"),
              style: theme.normalCrossColor(),
            ))
      ]);
}

showAlertDialog(BuildContext context, Widget title, Widget content, List<TextButton>? actions) {
  showDialog<String>(
      context: context,
      barrierColor: theme.dialogBarrier(),
      builder: (BuildContext context) => AlertDialog(
            title: title,
            content: content,
            actions: actions,
          ));
}

String getFileSize(int fileSize) {
  if(fileSize >= 1024 && fileSize < 1048576) {
    return (fileSize / 1024).ceil().toStringAsFixed(3)+" KB";
  } else if(fileSize >= 1048576 && fileSize < 1073741824) {
    // String kb =  ((fileSize % 1048576) / 1024).ceil().toString();
    return (fileSize / 1048576).toStringAsFixed(3).toString()+" MB";
  } else if(fileSize >= 1073741824) {
    // String mb =  ((fileSize % 1073741824) / 1048576).ceil().toString();
    return (fileSize / 1073741824).toStringAsFixed(3)+" GB";
  }
  return fileSize.toStringAsFixed(3)+" byte";
}

String? textToUrl(String? text) {
  if(text == null || text.isEmpty) {
    return text;
  }
  text = turkishToEnglishLetters(text.toLowerCase());
  text = text.replaceAll(RegExp(' '), '-');
  text = text.replaceAll(RegExp('[^a-z0-9-\/]'), '');
  return text;
}

String turkishToEnglishLetters(String text) {
  if(text.isEmpty) {
    return text;
  }
  text = text.replaceAll(RegExp('Ğ'), 'G');
  text = text.replaceAll(RegExp('ğ'), 'g');
  text = text.replaceAll(RegExp('Ü'), 'U');
  text = text.replaceAll(RegExp('ü'), 'u');
  text = text.replaceAll(RegExp('Ş'), 'S');
  text = text.replaceAll(RegExp('ş'), 's');
  text = text.replaceAll(RegExp('İ'), 'I');
  text = text.replaceAll(RegExp('ı'), 'i');
  text = text.replaceAll(RegExp('Ö'), 'O');
  text = text.replaceAll(RegExp('ö'), 'o');
  text = text.replaceAll(RegExp('Ç'), 'C');
  text = text.replaceAll(RegExp('ç'), 'c');
  return text;
}

String fallbackNetworkImage(String? image) {
  if (image == null) {
    return "https://app.codenfast.com:8443/api/rest/server-files/system/image/codenfast.com/012021/logo.webp";
  }
  return imageRegex.hasMatch(image) ? image : "https://app.codenfast.com:8443/api/rest/server-files/system/image/codenfast.com/012021/logo.webp";
}

String iconFromFileExtension(String fileName) {
  if(!fileName.contains(".")) {
    return "assets/ikonlar/files/applicationoctetstream.png";
  }
  String extension = fileName.substring(fileName.indexOf(".")+1);
  if(extension == '3ds') {
    return "assets/ikonlar/files/3ds.png";
  }
  if(extension == 'ai') {
    return "assets/ikonlar/files/ai.png";
  }
  if(extension == 'avi') {
    return "assets/ikonlar/files/avi.png";
  }
  if(extension == 'cab') {
    return "assets/ikonlar/files/cab.png";
  }
  if(extension == 'css') {
    return "assets/ikonlar/files/css.png";
  }
  if(extension == 'csv') {
    return "assets/ikonlar/files/csv.png";
  }
  if(extension == 'dll') {
    return "assets/ikonlar/files/dll.png";
  }
  if(extension == 'doc' || extension == 'docx') {
    return "assets/ikonlar/files/doc.png";
  }
  if(extension == 'dvg') {
    return "assets/ikonlar/files/dvg.png";
  }
  if(extension == 'exe') {
    return "assets/ikonlar/files/exe.png";
  }
  if(extension == 'eml') {
    return "assets/ikonlar/files/eml.png";
  }
  if(extension == 'gif') {
    return "assets/ikonlar/files/gif.png";
  }
  if(extension == 'html') {
    return "assets/ikonlar/files/html.png";
  }
  if(extension == 'iso') {
    return "assets/ikonlar/files/iso.png";
  }
  if(extension == 'jpg' || extension == 'jpeg' ||extension == 'jfif') {
    return "assets/ikonlar/files/jpg.png";
  }
  if(extension == 'mov') {
    return "assets/ikonlar/files/mov.png";
  }
  if(extension == 'mp3') {
    return "assets/ikonlar/files/mp3.png";
  }
  if(extension == 'mpg' || extension == 'mpeg') {
    return "assets/ikonlar/files/mpg.png";
  }
  if(extension == 'otf') {
    return "assets/ikonlar/files/otf.png";
  }
  if(extension == 'pdf') {
    return "assets/ikonlar/files/pdf.png";
  }
  if(extension == 'png') {
    return "assets/ikonlar/files/png.png";
  }
  if(extension == 'ppt' || extension == 'pptx') {
    return "assets/ikonlar/files/ppt.png";
  }
  if(extension == 'psd') {
    return "assets/ikonlar/files/psd.png";
  }
  if(extension == 'rar') {
    return "assets/ikonlar/files/rar.png";
  }
  if(extension == 'tiff') {
    return "assets/ikonlar/files/tiff.png";
  }
  if(extension == 'txt') {
    return "assets/ikonlar/files/txt.png";
  }
  if(extension == 'wav') {
    return "assets/ikonlar/files/wav.png";
  }
  if(extension == 'wma') {
    return "assets/ikonlar/files/wma.png";
  }
  if(extension == 'xls' || extension == 'xlsx') {
    return "assets/ikonlar/files/xls.png";
  }
  if(extension == 'zip' || extension == '7z' || extension == 'tar' || extension == 'gz') {
    return "assets/ikonlar/files/zip.png";
  }
  return "assets/ikonlar/files/applicationoctetstream.png";
}

