import 'package:flutter/material.dart';
import 'package:slider_captcha/self.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () => showCaptcha(context),
        ),
        body: const SizedBox());
  }

  void showMyDialog(BuildContext context, String message) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message),
              ],
            ),
          );
        });
    Navigator.of(context).pop();
  }

  void showCaptcha(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SliderCaptcha(
                title: 'เลื่อนเพื่อยืนยัน',
                captchaSize: 36,
                image: Image.network(
                  'https://alpha-res.bluedragonlottery.cloud/c_thumb/505c3aff8aff6813edc7db736692ba80e/tree-g92abafe9e_640.jpg',
                  fit: BoxFit.fitWidth,
                ),
                onSuccess: () async {
                  debugPrint('สำเร็จ');
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pop();
                },
                onFail: () async {
                  debugPrint('ไม่สำเร็จ');
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pop();
                },
                onClose: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        });
  }
}
