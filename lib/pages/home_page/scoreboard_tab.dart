import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ztudent/env.dart';
import 'package:ztudent/models/user.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';

class ScoreboardTab extends StatefulWidget {
  final User user;
  const ScoreboardTab({Key? key, required this.user}) : super(key: key);

  @override
  State<ScoreboardTab> createState() => _ScoreboardTabState();
}

class _ScoreboardTabState extends State<ScoreboardTab> {
  TextEditingController textFieldEngController = TextEditingController();
  TextEditingController textFieldMathController = TextEditingController();
  TextEditingController textFieldPhyController = TextEditingController();
  TextEditingController textFieldPsychController = TextEditingController();
  TextEditingController textFieldGeoController = TextEditingController();
  TextEditingController textFieldCriticalController = TextEditingController();
  FormFieldController<String> dropdownController =
      FormFieldController<String>(null);

  final Dio dio = new Dio(BaseOptions(baseUrl: Environment.baseURL));

  bool isDeptSelected = false;
  bool isLoading = false;
  int deptStuCount = 0;

  String? errMsg;

  void deptSelectionHandler(String? department) async {
    if (department == null) return;
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    var res;
    try {
      res =
          await dio.post('/departmentScore', data: {'department': department});
    } catch (e) {
      print("==== Error scoreboardTab ====" + e.toString());
    }

    if (res.data.length == 0)
      setState(() {
        isDeptSelected = false;
        isLoading = false;
        errMsg = 'No students have chosen this department';
      });
    else
      setState(() {
        textFieldEngController.text =
            '${res.data[0]['avgEng'].round()} (${res.data[0]['stdDevEng'].round()})';
        textFieldMathController.text =
            '${res.data[0]['avgMath'].round()} (${res.data[0]['stdDevMath'].round()})';
        textFieldPhyController.text =
            '${res.data[0]['avgPhy'].round()} (${res.data[0]['stdDevPhy'].round()})';
        textFieldGeoController.text =
            '${res.data[0]['avgGeo'].round()} (${res.data[0]['stdDevGeo'].round()})';
        textFieldCriticalController.text =
            '${res.data[0]['avgCritical'].round()} (${res.data[0]['stdDevCritical'].round()})';
        textFieldPsychController.text =
            '${res.data[0]['avgPsych'].round()} (${res.data[0]['stdDevPsych'].round()})';

        deptStuCount = res.data[0]['count'];
        isDeptSelected = true;
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWidgetWrapper(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.max,
        children: !widget.user.isEditAllowed
            ? [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                  child: Text(
                    'Since grades aren\'t known yet average scores can\'t be provided.',
                    style: FlutterFlowTheme.of(context).labelLarge,
                    textAlign: TextAlign.center,
                  ),
                )
              ]
            : !widget.user.isScoreboardAllowed
                ? [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: Text(
                        'Gain access to the average scores by contributing your grades in the dashboard tab.',
                        style: FlutterFlowTheme.of(context).labelLarge,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]
                : [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10.0, 15.0, 10.0, 10.0),
                      child: Text(
                        'Select a department to view the average grades of students interested in the department.',
                        style: FlutterFlowTheme.of(context).labelLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                25.0, 0.0, 10.0, 0.0),
                            child: Text(
                              'Department',
                              style: FlutterFlowTheme.of(context).titleMedium,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 5.0, 0.0),
                            child: FlutterFlowDropDown<String>(
                              controller: dropdownController,
                              options: widget.user.deptList,
                              onChanged: (val) => deptSelectionHandler(val),
                              width: 180.0,
                              height: 40.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    lineHeight: 1.0,
                                  ),
                              hintText: 'Please select...',
                              fillColor:
                                  FlutterFlowTheme.of(context).dropdownBgColor,
                              elevation: 2.0,
                              borderColor: Colors.transparent,
                              borderWidth: 0.0,
                              borderRadius: 10.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 4.0, 12.0, 4.0),
                              hidesUnderline: true,
                              isSearchable: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 30.0,
                      thickness: 1.5,
                      indent: 50.0,
                      endIndent: 50.0,
                      color: FlutterFlowTheme.of(context).dropdownBgColor,
                    ),
                    if (isDeptSelected && !isLoading) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Text(
                          '$deptStuCount student(s) interested in this department',
                          style: FlutterFlowTheme.of(context).labelLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 7.0, 0.0),
                        child: GridView(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.1,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: TextFormField(
                                controller: textFieldEngController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.none,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'English',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .dropdownBgColor,
                                ),
                                style: FlutterFlowTheme.of(context).bodySmall,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: TextFormField(
                                controller: textFieldMathController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.none,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Maths',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .dropdownBgColor,
                                  filled: true,
                                ),
                                style: FlutterFlowTheme.of(context).bodySmall,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: TextFormField(
                                controller: textFieldPhyController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.none,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Physics',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .dropdownBgColor,
                                  filled: true,
                                ),
                                style: FlutterFlowTheme.of(context).bodySmall,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: TextFormField(
                                controller: textFieldGeoController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.none,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Geography',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .dropdownBgColor,
                                  filled: true,
                                ),
                                style: FlutterFlowTheme.of(context).bodySmall,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: TextFormField(
                                controller: textFieldCriticalController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.none,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Critical Thinking',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .dropdownBgColor,
                                  filled: true,
                                ),
                                style: FlutterFlowTheme.of(context).bodySmall,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: TextFormField(
                                controller: textFieldPsychController,
                                autofocus: true,
                                textCapitalization: TextCapitalization.none,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Psychology',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .dropdownBgColor,
                                  filled: true,
                                ),
                                style: FlutterFlowTheme.of(context).bodySmall,
                                maxLines: null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 15.0, 10.0, 10.0),
                        child: Text(
                          isLoading
                              ? 'Loading department data...'
                              : errMsg ??
                                  'You haven\'t selected any departmet yet.',
                          style: FlutterFlowTheme.of(context).labelLarge,
                          textAlign: TextAlign.center,
                        ),
                      )
                  ],
      ),
    );
  }
}
