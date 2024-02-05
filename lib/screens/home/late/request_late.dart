import 'dart:convert';

import 'package:attendance/widgets/big_button.dart';
import 'package:attendance/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../blocs/lateBloc/late_bloc.dart';
import '../../AdminScreens/user/all_users.dart';

class RequestLate extends StatefulWidget {
  const RequestLate({super.key});

  @override
  _RequestLateState createState() => _RequestLateState();
}

class _RequestLateState extends State<RequestLate> {
  DateTime today = DateTime.now();
  String onDate = DateTime.now().toString();
  String viewOnDay = '';

  bool showReason = false;
  bool showDate = false;
  String? email = '';
  String? role = 'user';

  TextEditingController reasonController = TextEditingController();

  void _onFromSelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
      onDate = selectedDay.toString();
      DateTime dateTime = DateTime.parse(onDate.toString()).toLocal();
      // DateTime dateTimeView = DateTime.parse(fromDay.toString()).toLocal();
      String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
      String formattedDate1 = DateFormat('EEE, dd MMM yyyy').format(dateTime);
      viewOnDay = formattedDate1;
      onDate = formattedDate;

      // BlocProvider.of<LeaveBloc>(context)
      //     .add(FromDateChangeEvent(fromDate: fromDay));
      print(formattedDate);
      print(formattedDate1);
    });
  }

  getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    email = prefs.getString("email");
    if (role != 'admin') {
      BlocProvider.of<LateBloc>(context).add(UserChangeEvent(email: email!));
    }
    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      viewOnDay = DateFormat('EEE, dd MMM yyyy').format(today);
      String formattedDate = DateFormat('MM/dd/yyyy').format(today);
      onDate = formattedDate;
      getUserEmail();
      print(formattedDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lateBloc = context.read<LateBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
              // title: const Text("Make Leave Request"),
              ),
          body: BlocConsumer<LateBloc, LateState>(
            listener: (context, state) {
              if (state is RequestLateSuccessState || state is RequestLateAdminSuccessState) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Requested",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color(0x3F000000),
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Request Late',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            color: const Color(0x00D9D9D9),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  // if admin get to user selection page
                                  if (role == 'admin') {
                                    Get.to(const AllUsers(
                                      page: "admin",
                                    ))!
                                        .then((value) {
                                      setState(() {});
                                    });
                                  }
                                  print(lateBloc.email);
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFC58EFC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.alternate_email_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  lateBloc.email,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (state is RequestLateAdminUserEmptyState)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 42,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFF5F5F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Select a user",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              const Divider(
                                color: Colors.black12,
                                thickness: 0.5,
                                indent: 10,
                                endIndent: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showReason = !showReason;
                                    showDate = false;
                                  });
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFC58EFC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.border_color,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'Reason',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  reasonController.text.isEmpty
                                      ? 'Reason'
                                      : reasonController.text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (showReason)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: InputField(
                                    hintText: 'Specify your reason',
                                    labelText: 'Reason',
                                    controller: reasonController,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (val) {
                                      setState(() {
                                        // leaveBloc.add(
                                        //     ReasonChangeEvent(reason: val));
                                      });
                                    },
                                  ),
                                ),
                              if (state is RequestLateAdminReasonEmptyState ||
                                  state is RequestLateReasonEmptyState)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 42,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFF5F5F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Specify your reason",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              const Divider(
                                color: Colors.black12,
                                thickness: 0.5,
                                indent: 10,
                                endIndent: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showReason = false;
                                    showDate = !showDate;
                                  });
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFC58EFC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'On',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  viewOnDay,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (showDate)
                                TableCalendar(
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  focusedDay: today,
                                  headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true),
                                  availableGestures: AvailableGestures.all,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(day, today),
                                  onDaySelected: _onFromSelected,
                                ),
                              if (state is RequestLateAdminDateEmptyState ||
                                  state is RequestLateDateEmptyState)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 42,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFF5F5F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Select a date",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              const Divider(
                                color: Colors.black12,
                                thickness: 0.5,
                                indent: 10,
                                endIndent: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        state is RequestLateLoadingState ||
                                state is RequestLateAdminLoadingState
                            ? const BigButtonLoading()
                            : BigButton(
                                title: "Request for late approval",
                                onPressed: () {
                                  if (role == "admin") {
                                    BlocProvider.of<LateBloc>(context).add(
                                        RequestLateAdminEvent(
                                            reason: reasonController.text,
                                            date: onDate));
                                  } else {
                                    BlocProvider.of<LateBloc>(context).add(
                                        RequestLateEvent(
                                            reason: reasonController.text,
                                            date: onDate));
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (state is RequestLateErrorState)
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF5F5F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              getErr(state.error),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        if (state is RequestLateAdminErrorState)
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF5F5F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              getErr(state.error),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  String getErr(String err) {
    Map<String, dynamic> jsonResponse = json.decode(err);
    String responseMessage = jsonResponse["message"] ?? "";
    if (responseMessage.isNotEmpty) {
      print(jsonResponse);
      return responseMessage;
    } else {
      return 'Something wrong!';
    }
  }
}
