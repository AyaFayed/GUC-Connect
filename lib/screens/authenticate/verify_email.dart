import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/home/home.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large__icon_btn.dart';
import 'package:quickalert/quickalert.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final AuthService _auth = AuthService();

  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    dynamic result = await _auth.sendVerificationEmail();

    if (context.mounted) {
      if (result == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          confirmBtnColor: AppColors.confirm,
          text: Confirmations.verifyEmail,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnColor: AppColors.confirm,
          text: result,
        );
      }
    }

    setState(() {
      canResendEmail = false;
    });

    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      canResendEmail = true;
    });
  }

  // @override
  // void initState() {
  //   super.initState();

  //   isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  //   if (!isEmailVerified) {
  //     sendVerificationEmail();
  //     timer = Timer.periodic(
  //         const Duration(seconds: 3), (_) => checkEmailVerified());
  //   }
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => const Home();

  // => isEmailVerified
  //     ? const Home()
  //     : Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Verify Email'),
  //         ),
  //         body: Padding(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'A verification email has been sent to your email.',
  //                   style: TextStyle(
  //                     fontSize: Sizes.medium,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 const SizedBox(
  //                   height: 24,
  //                 ),
  //                 LargeIconBtn(
  //                     onPressed: canResendEmail ? sendVerificationEmail : null,
  //                     text: 'Resend email',
  //                     icon: Icon(Icons.email, size: Sizes.medium)),
  //                 TextButton.icon(
  //                     icon: Icon(
  //                       Icons.arrow_back,
  //                       size: Sizes.medium,
  //                     ),
  //                     onPressed: () => _auth.logout(),
  //                     label: Text(
  //                       'Back',
  //                       style: TextStyle(fontSize: Sizes.medium),
  //                     ))
  //               ],
  //             )),
  //       );
}
