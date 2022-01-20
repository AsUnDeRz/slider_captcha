part of 'slider_captcha_cubit.dart';

@immutable
abstract class SliderCaptchaState extends Equatable {
  const SliderCaptchaState(this.offsetMove);

  final double offsetMove;
}

class SliderCaptchaLoading extends SliderCaptchaState {
  const SliderCaptchaLoading() : super(0);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SliderCaptchaMove extends SliderCaptchaState {
  const SliderCaptchaMove(double offsetX) : super(offsetX);

  @override
  // TODO: implement props
  List<Object?> get props => [offsetMove];
}

class SliderCaptchaLock extends SliderCaptchaState {
  const SliderCaptchaLock(this.timer) : super(0);
  final int timer;
  @override
  // TODO: implement props
  List<Object?> get props => [timer];
}

class SliderCaptchaSuccess extends SliderCaptchaState {
  const SliderCaptchaSuccess() : super(0);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SliderCaptchaFailInLimit extends SliderCaptchaState {
  const SliderCaptchaFailInLimit() : super(0);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
