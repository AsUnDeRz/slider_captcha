import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/standard/slider_captcha_cubit.dart';
import 'package:slider_captcha/presentation/widgets/slider_bar.dart';
import 'package:slider_captcha/presentation/widgets/slider_panel.dart';

class SliderCaptcha extends StatelessWidget {
  const SliderCaptcha(
      {required this.image,
      required this.onSuccess,
      required this.onFail,
      this.title = 'เลื่อนเพื่อยืนยัน',
      this.captchaSize = 30,
      this.maxWrongNumber = 2,
      Key? key})
      : super(key: key);

  final Image image;

  final void Function() onSuccess;

  final void Function() onFail;

  final String title;

  final double captchaSize;

  final double maxWrongNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) => SliderCaptchaCubit(
            context: context,
            height: 200,
            sizeCaptcha: captchaSize,
            maxWrongNumber: maxWrongNumber,
            onSuccess: onSuccess,
            onFail: onFail),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 200,
                child: SliderPanel(sizeCaptcha: captchaSize, image: image)),
            const SizedBox(height: 8),
            SliderBar(title: title),
          ],
        ),
      ),
    );
  }
}
