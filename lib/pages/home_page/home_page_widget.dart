import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ztudent/env.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';

import './dashboard_tab.dart';
import './scoreboard_tab.dart';
import '../../models/user.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  final Dio dio = new Dio(BaseOptions(baseUrl: Environment.baseURL));

  late User user;
  void _updateUser(User u) => setState(() {
        user = u;
      });

  late bool isLoading = true;

  void _fetchData() async {
    final eprefs = EncryptedSharedPreferences();

    String _u = await eprefs.getString('user');

    setState(() {
      user = User.fromJSONString(_u);
      isLoading = false;
    });
  }

  void refresh() async {
    setState(() {
      isLoading = true;
    });
    final eprefs = EncryptedSharedPreferences();
    var _user;

    try {
      var res = await dio.post('/refresh', data: {'id': user.id});
      _user = new User(res.data);
      var success = await eprefs.setString('user', _user.toJSONString());
      if (!success)
        return snackbarErr(
            context, 'Something went wrong during refresh. Try again.');
    } catch (e) {
      print("==== Error homePage ====" + e.toString());
      return snackbarErr(context,
          'Couldn\'t establish stable connection. Check your Internet.');
    }

    setState(() {
      user = _user;
      isLoading = false;
    });
  }

  void snackbarErr(BuildContext context, String errText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errText)),
    );
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
  void initState() {
    super.initState();

    _fetchData();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Ztudent',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: 22.0,
                  ),
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: InkWell(
                  onTap: this.refresh,
                  child: Icon(
                    Icons.refresh_rounded,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 28,
                  ),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: 412,
                height: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (isLoading)
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                child: Lottie.network(
                                  'https://assets2.lottiefiles.com/packages/lf20_aZTdD5.json',
                                  width: 150,
                                  height: 130,
                                  fit: BoxFit.contain,
                                  animate: true,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.05, 0),
                              child: Text(
                                'Loading...',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor:
                                    FlutterFlowTheme.of(context).primary,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context).secondary,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                indicatorColor:
                                    FlutterFlowTheme.of(context).primary,
                                tabs: [
                                  Tab(
                                    text: 'Dashboard',
                                  ),
                                  Tab(
                                    text: 'Scoreboard',
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    DashboardTab(
                                      user: this.user,
                                      userUpdater: _updateUser,
                                    ),
                                    ScoreboardTab(
                                      user: this.user,
                                    )
                                  ],
                                ),
                              ),
                            ],
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
