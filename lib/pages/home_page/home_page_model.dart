import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  String? dept;

  bool isDeptSelected = false;

  bool isEditMode = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField-Name widget.
  TextEditingController? textFieldNameController;
  String? Function(BuildContext, String?)? textFieldNameControllerValidator;
  // State field(s) for TextField-RegNo widget.
  TextEditingController? textFieldRegNoController;
  String? Function(BuildContext, String?)? textFieldRegNoControllerValidator;
  // State field(s) for TextField-Eng widget.
  TextEditingController? textFieldEngController;
  String? Function(BuildContext, String?)? textFieldEngControllerValidator;
  // State field(s) for TextField-Math widget.
  TextEditingController? textFieldMathController;
  String? Function(BuildContext, String?)? textFieldMathControllerValidator;
  // State field(s) for TextField-Phy widget.
  TextEditingController? textFieldPhyController;
  String? Function(BuildContext, String?)? textFieldPhyControllerValidator;
  // State field(s) for TextField-Psych widget.
  TextEditingController? textFieldPsychController;
  String? Function(BuildContext, String?)? textFieldPsychControllerValidator;
  // State field(s) for TextField-Geo widget.
  TextEditingController? textFieldGeoController;
  String? Function(BuildContext, String?)? textFieldGeoControllerValidator;
  // State field(s) for TextField-Critical widget.
  TextEditingController? textFieldCriticalController;
  String? Function(BuildContext, String?)? textFieldCriticalControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownController2;
  // State field(s) for TextField widget.
  TextEditingController? textController9;
  String? Function(BuildContext, String?)? textController9Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController10;
  String? Function(BuildContext, String?)? textController10Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController11;
  String? Function(BuildContext, String?)? textController11Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController12;
  String? Function(BuildContext, String?)? textController12Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController13;
  String? Function(BuildContext, String?)? textController13Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController14;
  String? Function(BuildContext, String?)? textController14Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController15;
  String? Function(BuildContext, String?)? textController15Validator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textFieldNameController?.dispose();
    textFieldRegNoController?.dispose();
    textFieldEngController?.dispose();
    textFieldMathController?.dispose();
    textFieldPhyController?.dispose();
    textFieldPsychController?.dispose();
    textFieldGeoController?.dispose();
    textFieldCriticalController?.dispose();
    textController9?.dispose();
    textController10?.dispose();
    textController11?.dispose();
    textController12?.dispose();
    textController13?.dispose();
    textController14?.dispose();
    textController15?.dispose();
  }

  /// Additional helper methods are added here.

}
