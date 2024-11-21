import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v3/flutter_recaptcha_v3.dart';


class RecaptchaWidget extends StatefulWidget {
  @override
  _RecaptchaWidgetState createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  final String createdViewId = 'recaptcha-widget';

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    // // reCAPTCHA HTML içeriğini oluşturmak için view factory kaydediyoruz.
    // ui.platformViewRegistry.registerViewFactory(
    //   createdViewId,
    //   (int viewId) => html.IFrameElement()
    //     ..src = 'assets/html/recaptcha.html' // HTML dosyasının yolu
    //     ..style.border = 'none'
    //     ..style.width = '100%' // Genişliği %100 yapıyoruz
    //     ..style.height = '100%', // Yüksekliği %100 yapıyoruz
    // );
=======

    // reCAPTCHA HTML içeriğini oluşturmak için view factory kaydediyoruz.
    ui.platformViewRegistry.registerViewFactory(
      createdViewId,
      (int viewId) => html.IFrameElement()
        ..src = 'assets/html/recaptcha.html'  // HTML dosyasının yolu
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%',
    );
>>>>>>> fda8b22 (Şifre belirleme ekranı password gereksinimleri tamamlandı)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // Yüzde olarak genişlik
      height: 250, // Yükseklik
      padding: EdgeInsets.all(8),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: HtmlElementView(viewType: createdViewId),  // reCAPTCHA widget'ını render ediyoruz
      ),
    );
  }
}
