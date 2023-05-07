import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ztudent/env.dart';

import '../../flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';

import 'package:dio/dio.dart';

import '../../models/user.dart';

class DashboardTab extends StatefulWidget {
  final User user;
  final Function userUpdater;
  const DashboardTab({Key? key, required this.user, required this.userUpdater})
      : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late bool isEditMode = false;

  final Dio dio = new Dio(BaseOptions(baseUrl: Environment.baseURL));

  TextEditingController textFieldEngController = TextEditingController();
  TextEditingController textFieldMathController = TextEditingController();
  TextEditingController textFieldPhyController = TextEditingController();
  TextEditingController textFieldPsychController = TextEditingController();
  TextEditingController textFieldGeoController = TextEditingController();
  TextEditingController textFieldCriticalController = TextEditingController();
  FormFieldController<String> dropdownController =
      FormFieldController<String>(null);

  void bindUserData() {
    textFieldEngController.text = widget.user.eng.toString();
    textFieldMathController.text = widget.user.math.toString();
    textFieldPhyController.text = widget.user.phy.toString();
    textFieldGeoController.text = widget.user.geo.toString();
    textFieldCriticalController.text = widget.user.critical.toString();
    textFieldPsychController.text = widget.user.psych.toString();

    dropdownController.value = widget.user.department;
  }

  void cancelHandler() {
    setState(() {
      bindUserData();
      isEditMode = false;
    });
  }

  @override
  void initState() {
    super.initState();

    bindUserData();
  }

  bool _isFormValid() {
    var q = [
      textFieldEngController.text,
      textFieldMathController.text,
      textFieldPhyController.text,
      textFieldGeoController.text,
      textFieldCriticalController.text,
      textFieldPsychController.text
    ];

    // RegEx for numbers 1 upto 100 both inclusive
    final gradeRegX = RegExp(r'^(?:[1-9]|[1-9][0-9]|100)$');

    return q.every((val) => gradeRegX.hasMatch(val)) &&
        widget.user.deptList.contains(dropdownController.value);
  }

  void snackbarMsg(BuildContext context, String msgText) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msgText)));
  }

  void submitHandler(BuildContext ctx) async {
    if (!_isFormValid()) {
      return snackbarMsg(ctx, 'Invalid input. Please check.');
    }

    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text('Updating info...'),
      duration: const Duration(days: 1),
    ));

    try {
      var res = await dio.post('/updateGrade', data: {
        "id": widget.user.id,
        "department": dropdownController.value,
        "eng": textFieldEngController.text,
        "math": textFieldMathController.text,
        "phy": textFieldPhyController.text,
        "geo": textFieldGeoController.text,
        "critical": textFieldCriticalController.text,
        "psych": textFieldPsychController.text
      });

      var _user = User(res.data);
      final eprefs = EncryptedSharedPreferences();

      var success = await eprefs.setString('user', _user.toJSONString());
      if (!success)
        return snackbarMsg(
            context, 'Something went wrong during update. Try again later.');

      isEditMode = false; // No setState b/c eventually userUpdater calls it
      widget.userUpdater(_user);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      snackbarMsg(context, "Successfully done.");
    } catch (e) {
      print("==== Error dashboardTab ====" + e.toString());
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      snackbarMsg(context,
          'Couldn\'t establish stable connection. Check your Internet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: KeepAliveWidgetWrapper(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 20.0, 5.0),
              child: TextFormField(
                initialValue: widget.user.name,
                textCapitalization: TextCapitalization.words,
                readOnly: true,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Name',
                  enabled: false,
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                  filled: true,
                ),
                style: FlutterFlowTheme.of(context).bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
              child: TextFormField(
                initialValue: widget.user.registrationNo,
                textCapitalization: TextCapitalization.none,
                readOnly: true,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Registration No.',
                  enabled: false,
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                  filled: true,
                ),
                style: FlutterFlowTheme.of(context).bodySmall,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(25.0, 15.0, 10.0, 15.0),
                  child: Text(
                    'Your Grade (out of 100)',
                    style: FlutterFlowTheme.of(context).titleSmall,
                  ),
                ),
                if (!isEditMode)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0.0, 25.0, 0.0),
                    child: FFButtonWidget(
                      text: 'Edit',
                      options: FFButtonOptions(
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: !widget.user.isEditAllowed
                          ? null
                          : () {
                              setState(() {
                                isEditMode = true;
                              });
                            },
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 50,
                          icon: Icon(
                            Icons.check_circle,
                            color: FlutterFlowTheme.of(context).success,
                            size: 20,
                          ),
                          onPressed: () => submitHandler(context),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 50,
                          icon: Icon(
                            Icons.cancel_sharp,
                            color: FlutterFlowTheme.of(context).error,
                            size: 20,
                          ),
                          onPressed: cancelHandler,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 7.0, 0.0),
              child: GridView(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.1,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                primary: true,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: TextFormField(
                      controller: textFieldEngController,
                      textCapitalization: TextCapitalization.none,
                      readOnly: !isEditMode,
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
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                        filled: true,
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: TextFormField(
                      controller: textFieldMathController,
                      textCapitalization: TextCapitalization.none,
                      readOnly: !isEditMode,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Maths',
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
                        fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                        filled: true,
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: TextFormField(
                      controller: textFieldPhyController,
                      textCapitalization: TextCapitalization.none,
                      readOnly: !isEditMode,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Physics',
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
                        fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                        filled: true,
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: TextFormField(
                      controller: textFieldGeoController,
                      textCapitalization: TextCapitalization.none,
                      readOnly: !isEditMode,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Geography',
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
                        fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                        filled: true,
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: TextFormField(
                      controller: textFieldCriticalController,
                      textCapitalization: TextCapitalization.none,
                      readOnly: !isEditMode,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Critical Thinking',
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
                        fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                        filled: true,
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: TextFormField(
                      controller: textFieldPsychController,
                      textCapitalization: TextCapitalization.none,
                      readOnly: !isEditMode,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Psychology',
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
                        fillColor: FlutterFlowTheme.of(context).dropdownBgColor,
                        filled: true,
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 10.0, 0.0),
                    child: Text(
                      'Department',
                      style: FlutterFlowTheme.of(context).titleSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                    child: FlutterFlowDropDown<String>(
                      controller: dropdownController,
                      options: widget.user.deptList,
                      onChanged: (value) {},
                      width: 180.0,
                      height: 40.0,
                      searchHintTextStyle:
                          FlutterFlowTheme.of(context).bodySmall,
                      textStyle:
                          FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Poppins',
                                lineHeight: 1.0,
                              ),
                      hintText: 'Please select...',
                      fillColor: FlutterFlowTheme.of(context).accent4,
                      elevation: 2.0,
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      borderRadius: 10.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                      hidesUnderline: true,
                      disabled: !isEditMode,
                      isSearchable: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
