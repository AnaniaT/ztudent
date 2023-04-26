import 'package:flutter/material.dart';

import '../../env.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import 'index_page_model.dart';
export 'index_page_model.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user', this.user!.toJSONString());
      isLoading = false;
      ctx.goNamed('HomePage');
    } catch (e) {
      if (res.statusCode == 400)
        setState(() {
          errMsg = 'Invalid login code';
        });
      else
        setState(() {
          errMsg = 'Something went wrong. Check your internet.';
        });
      isLoading = false;
      print('===Err=== ' + e.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 0.0),
                child: Text(
                  'Ztudent',
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 1.5,
                        lineHeight: 2.2,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
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
                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
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
    );
  }
}
