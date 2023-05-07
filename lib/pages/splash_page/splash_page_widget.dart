import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import '../../env.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../models/user.dart';
import '../../index.dart';

class SplashPageWidget extends StatefulWidget {
  const SplashPageWidget({Key? key}) : super(key: key);

  @override
  State<SplashPageWidget> createState() => _SplashPageWidgetState();
}

class _SplashPageWidgetState extends State<SplashPageWidget> {
  final Dio dio = new Dio(BaseOptions(baseUrl: Environment.baseURL));

  void _setApp() async {
    final eprefs = EncryptedSharedPreferences();

    String? storedData = await eprefs.getString('user');

    if (storedData == null || storedData == '')
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IndexPageWidget()),
      );
    else {
      User idleUser = User.fromJSONString(storedData);
      var res;
      try {
        res = await dio
            .post('/logincode', data: {'loginCode': idleUser.loginCode});
      } catch (e) {
        return snackbarErr(context, 'Network error couldn\'t log you in');
      }
      idleUser = new User(res.data);

      var success = await eprefs.setString('user', idleUser.toJSONString());
      if (!success) {
        return snackbarErr(
            context, 'Something went wrong. Please try again later.');
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePageWidget()),
      );
    }
  }

  void snackbarErr(BuildContext context, String errText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(days: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(errText),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 40,
              icon: Icon(
                Icons.refresh_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: 20,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _setApp();
              },
            )
          ],
        )));
  }

  @override
  void initState() {
    super.initState();

    _setApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gradient.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/app_launcher_icon.png',
                    height: 95,
                  ),
                  Text(
                    'Ztudent',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.2,
                          color: Color(0xff1A1A1A),
                          fontWeight: FontWeight.w500,
                          lineHeight: 1,
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    // 'Make informed decisions to shape your future',
                    'by Anania Temtim',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: 'Roboto',
                          color: Color(0xff1A1A1A),
                          fontSize: 12,
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
