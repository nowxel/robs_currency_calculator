import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailSender {
  EmailSender({this.emailBody, this.emailSubject, this.emailAddress});

  final String emailBody;
  final String emailSubject;
  final String emailAddress;

  MailOptions _getMailOptions (){
    final MailOptions mailOptions = MailOptions(
      body: emailBody,
      subject: emailSubject,
      recipients: <String>[emailAddress],
    );
    return mailOptions;
  }

  Future<String> sendEmail() async{
    String platformResponse = '';
    try {
      if (Platform.isIOS){
        final bool canSend = await FlutterMailer.canSendMail();
        debugPrint("------- sending email: canSend = " + canSend.toString());
        if (canSend){
          final url = 'mailto:$emailAddress?body=$emailBody&subject=$emailSubject';
          debugPrint("------- sending email: url = " + url);
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            //throw 'Could not launch $url';
            return 'failure';
          }
        }
      }
      await FlutterMailer.send(_getMailOptions());
      platformResponse = 'success';
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      debugPrint(platformResponse);
    }
    return platformResponse;
  }

}