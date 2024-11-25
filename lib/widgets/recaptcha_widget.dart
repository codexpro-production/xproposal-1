import 'package:flutter/material.dart';



class RecaptchaWidget extends StatefulWidget {
  const RecaptchaWidget({super.key});

  @override
  _RecaptchaWidgetState createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  final String createdViewId = 'recaptcha-widget';

  @override
  void initState() {
    super.initState();

    // reCAPTCHA HTML içeriğini oluşturmak için view factory kaydediyoruz.
    // ui.platformViewRegistry.registerViewFactory(
    //   createdViewId,
    //   (int viewId) => html.IFrameElement()
    //     ..src = 'assets/html/recaptcha.html'  // HTML dosyasının yolu
    //     ..style.border = 'none'
    //     ..style.width = '100%'
    //     ..style.height = '100%',
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 250, // Yükseklik
      padding: const EdgeInsets.all(8),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: HtmlElementView(viewType: createdViewId),
      ),
    );
  }
}
