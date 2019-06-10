import 'model/timeinout.dart';
//String path="http://192.168.0.200/vtltransport/index.php/Att_services/";
//String loginpath="http://192.168.0.200/vtltransport";
String loginpath="http://vtltransport.xyz";
String path="http://vtltransport.xyz/vtltransport/index.php/Att_services/";
//String path="https://vtl.ubiattendance.com/index.php/Att_services/";
MarkTime mk1;
String path_hrm_india="https://ubitech.ubihrm.com/services/"; // FOR LEAVE
List<Map<String, double>> list = new List();
String globalstreamlocationaddr="";
bool stopstreamingstatus = false;
int timeOff=0,bulkAttn = 0,geoFence=0,payroll=0,tracking=0,visitpunch=0,department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1,punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0;
int globalalertcount = 0;