import 'package:flutter/material.dart';
import 'package:ztudent/env.dart';

import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
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
    final prefs = await SharedPreferences.getInstance();

    // await Future.delayed(Duration(seconds: 2));

    setState(() {
      user = User.fromJSONString(prefs.getString('user')!);
      isLoading = false;
    });
  }

  void refresh() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _user;

    try {
      var res = await dio.post('/refresh', data: {'id': user.id});
      _user = new User(res.data);
      await prefs.setString('user', _user.toJSONString());
    } catch (e) {
      print("==== Error homePage ====" + e.toString());
    }

    setState(() {
      user = _user;
      isLoading = false;
    });
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
    return GestureDetector(
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
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
                          labelColor: FlutterFlowTheme.of(context).primary,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondary,
                          labelStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                          indicatorColor: FlutterFlowTheme.of(context).primary,
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
    );
  }
}
