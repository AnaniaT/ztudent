import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../env.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'index_page_model.dart';
export 'index_page_model.dart';

import 'package:dio/dio.dart';

import '../../models/user.dart';

class IndexPageWidget extends StatefulWidget {
  const IndexPageWidget({Key? key}) : super(key: key);

  @override
  _IndexPageWidgetState createState() => _IndexPageWidgetState();
}

class _IndexPageWidgetState extends State<IndexPageWidget> {
  late IndexPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  User? user;
  String loginCode = '';
  String? errMsg;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IndexPageModel());

    _model.textController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  void submitData(BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });

    if (loginCode.isEmpty) {
      setState(() {
        errMsg = 'Empty login code';
        isLoading = false;
      });
      return;
    }

    final Dio dio = new Dio(BaseOptions(baseUrl: Environment.baseURL));

    var res;
    try {
      res = await dio.post('/logincode', data: {'loginCode': loginCode});
      this.user = new User(res.data);

      final eprefs = EncryptedSharedPreferences();

      var success = await eprefs.setString('user', this.user!.toJSONString());
      if (!success) {
        return setState(() {
          errMsg = 'Something went wrong during login. Try again.';
          isLoading = false;
        });
      }
      isLoading = false;
      ctx.goNamed('HomePage');
    } catch (e) {
      if (res != null) if (res.statusCode == 400)
        return setState(() {
          errMsg = 'Invalid login code';
          isLoading = false;
        });

      setState(() {
        errMsg = 'Couldn\'t establish stable connection. Check your Internet.';
        isLoading = false;
      });
      print('===Err=== ' + e.toString());
      return;
    }
  }

  _onBackPressed() {
    showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        content: Text('You\'re about to exit. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () async {
              SystemChannels.platform
                  .invokeMethod('SystemNavigator.pop'); // kill app
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text('No'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isLoading = this.isLoading;
    errMsg = this.errMsg;
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            title: Text(
              'Sign In',
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Poppins',
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            actions: [],
            centerTitle: true,
            toolbarHeight: 64.0,
            elevation: 7.0,
          ),
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: 412,
                height: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 0.0),
                      child: Text(
                        'Ztudent',
                        textAlign: TextAlign.start,
                        style:
                            FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1.5,
                                  lineHeight: 2.2,
                                ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
                      child: TextFormField(
                        onChanged: (value) {
                          loginCode = value;
                        },
                        controller: TextEditingController(text: loginCode),
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Login code',
                          errorText: errMsg,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                        ),
                        style: FlutterFlowTheme.of(context).bodySmall,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                        child: FFButtonWidget(
                          onPressed: !isLoading
                              ? () async {
                                  submitData(context);
                                }
                              : null,
                          text: !isLoading ? 'Submit' : 'loading...',
                          options: FFButtonOptions(
                            disabledColor: FlutterFlowTheme.of(context).accent3,
                            width: 130.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                            elevation: 5.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
