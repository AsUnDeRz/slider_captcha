import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_captcha/logic/standard/slider_captcha_cubit.dart';
import 'package:slider_captcha/presentation/widgets/slider_bar.dart';
import 'package:slider_captcha/presentation/widgets/slider_panel.dart';

class SliderCaptcha extends StatelessWidget {
  SliderCaptcha(
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
            BlocBuilder<SliderCaptchaCubit, SliderCaptchaState>(
              builder: (context, state) {
                if (state is SliderCaptchaSuccess) {
                  return SizedBox(
                    height: 258,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Center(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                        Text(
                          'ยืนยันสำเร็จ',
                          style: TextStyle(color: Color(0xff3fa73c)),
                        ),
                      ],
                    ),
                  );
                }
                if (state is SliderCaptchaMove) {
                  return Column(
                    children: [
                      SizedBox(
                          height: 200,
                          child: Scaffold(
                            backgroundColor: Colors.red,
                            body: SizedBox(
                              height: 200,
                              child: SliderPanel(
                                  sizeCaptcha: captchaSize, image: image),
                            ),
                          )),
                      const SizedBox(height: 8),
                      SliderBar(title: title)
                    ],
                  );
                }

                if (state is SliderCaptchaFailInLimit) {
                  return SizedBox(
                    height: 258,
                    child: TestAnimWidget(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TestAnimWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAnimWidgetState();
}

class _TestAnimWidgetState extends State<TestAnimWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
              animation: offsetAnimation,
              builder: (buildContext, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  padding: EdgeInsets.only(
                      left: offsetAnimation.value + 24.0,
                      right: 24.0 - offsetAnimation.value),
                  child: SizedBox(
                    height: 258,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Center(
                          child: Icon(
                            Icons.close_outlined,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                        Text(
                          'ยืนยันผิดพลาด',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
