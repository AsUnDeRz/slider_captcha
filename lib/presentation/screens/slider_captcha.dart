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
      required this.onClose,
      this.title = 'เลื่อนเพื่อยืนยัน',
      this.captchaSize = 30,
      this.maxWrongNumber = 2,
      this.titleSlider = 'Security Verification',
      Key? key})
      : super(key: key);

  final Image image;

  final void Function() onSuccess;

  final void Function() onFail;

  final void Function() onClose;

  final String title;

  final double captchaSize;

  final double maxWrongNumber;

  final String titleSlider;

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
                    height: 298,
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
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(titleSlider ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Color(0xff424242),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            InkWell(
                              onTap: onClose,
                              child: Container(
                                width: 50,
                                height: 40,
                                // color: Colors.red,
                                alignment: Alignment.topRight,
                                child: const Icon(Icons.close),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                          child: SliderPanel(
                              sizeCaptcha: captchaSize, image: image)),
                      const SizedBox(height: 8),
                      SliderBar(title: title)
                    ],
                  );
                }

                if (state is SliderCaptchaFailInLimit) {
                  return const SizedBox(
                    height: 298,
                    child: AnimationFailWidget(),
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

class AnimationFailWidget extends StatefulWidget {
  const AnimationFailWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimationFailWidgetState();
}

class _AnimationFailWidgetState extends State<AnimationFailWidget>
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
                    height: 298,
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
