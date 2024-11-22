import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<bool> sendMail(String name, String email, String subject,
    String messages, BuildContext context) async {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.greenAccent,
        ),
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Mesaj Gönderiliyor...\nMessage Sending",
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }));
  bool sendStates;
  try {
    String username = '';
    String password = '';

    final smtpServer = SmtpServer('_username, _password',
        username: username,
        password: password,
        ignoreBadCertificate: false,
        ssl: false,
        allowInsecure: true);

    /* final smtpServer=hotmail(_username, _password); */

    String date = DateTime.now().toString();
    String sendmail = "info@yourcompany.com";
    String konu = subject;
    String mesajIcerigi =
        "Date/Tarih: $date \nSender name/ Gönderen İsim: $name \nSender e-mail/email: $email \nMesage/Mesaj: $messages";

    // Create our message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(sendmail)
      ..subject = konu
      ..text = mesajIcerigi;

    try {
      final sendReport = await send(message, smtpServer);
      sendStates = true;
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      sendStates = false;
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  } catch (Exception) {
    //Handle Exception
  } finally {
    Navigator.pop(context);
  }
  return true;
}