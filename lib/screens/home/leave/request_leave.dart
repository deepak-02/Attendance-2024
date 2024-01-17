import 'package:attendance/widgets/big_button.dart';
import 'package:attendance/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../blocs/leaveBloc/leave_bloc.dart';

class RequestLeave extends StatefulWidget {
  const RequestLeave({super.key});

  @override
  _RequestLeaveState createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  String leaveDate = '';
  DateTime today1 = DateTime.now();
  DateTime today2 = DateTime.now();
  String fromDay = DateTime.now().toString();
  String toDay = DateTime.now().toString();
  String viewFromDay = '';
  String viewToDay = '';

  bool showType = false;
  bool showReason = false;
  bool showFrom = false;
  bool showTo = false;

  String selectedType = 'casual';
  int days = 0;

  TextEditingController reasonController = TextEditingController();

  void _onFromSelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today1 = selectedDay;
      fromDay = selectedDay.toString();
      DateTime dateTime = DateTime.parse(fromDay.toString()).toLocal();
      // DateTime dateTimeView = DateTime.parse(fromDay.toString()).toLocal();
      String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
      String formattedDate1 = DateFormat('EEE, dd MMM yyyy').format(dateTime);
      viewFromDay = formattedDate1;
      fromDay = formattedDate;

      Duration difference = today2.difference(today1);
      days = difference.inDays;
      BlocProvider.of<LeaveBloc>(context)
          .add(FromDateChangeEvent(fromDate: fromDay));
      print(formattedDate);
      print(formattedDate1);
    });
  }

  void _onToSelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today2 = selectedDay;
      toDay = selectedDay.toString();
      DateTime dateTime = DateTime.parse(toDay.toString()).toLocal();
      // DateTime dateTimeView = DateTime.parse(fromDay.toString()).toLocal();
      String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
      String formattedDate1 = DateFormat('EEE, dd MMM yyyy').format(dateTime);
      viewToDay = formattedDate1;
      toDay = formattedDate;

      // DateTime date1 = DateTime.parse(fromDay);
      // DateTime date2 = DateTime.parse(toDay);

      Duration difference = today2.difference(today1);
      days = difference.inDays;
      BlocProvider.of<LeaveBloc>(context).add(ToDateChangeEvent(toDate: toDay));
      print(formattedDate);
      print(formattedDate1);
    });
  }

  @override
  void initState() {
    setState(() {
      viewFromDay = DateFormat('EEE, dd MMM yyyy').format(today1);
      viewToDay = DateFormat('EEE, dd MMM yyyy').format(today2);
      String formattedDate = DateFormat('MM/dd/yyyy').format(today1);
      BlocProvider.of<LeaveBloc>(context)
          .add(ToDateChangeEvent(toDate: formattedDate));
      BlocProvider.of<LeaveBloc>(context)
          .add(FromDateChangeEvent(fromDate: formattedDate));
      print(formattedDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leaveBloc = context.read<LeaveBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Make Leave Request"),
          ),
          body: BlocConsumer<LeaveBloc, LeaveState>(
            listener: (context, state) {
              if (state is RequestLeaveSuccessState) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Leave Requested",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color(0x3F000000),
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state is RequestLeaveErrorState) {
                Fluttertoast.showToast(
                    msg: state.error,
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
                          'New Leave',
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
                                  setState(() {
                                    showType = !showType;
                                    showReason = false;
                                    showFrom = false;
                                    showTo = false;
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
                                    Icons.grid_view_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'Type',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  selectedType == 'sick' ? 'Sick' : 'Casual',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (showType)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ChoiceChip(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          side: BorderSide.none),
                                      label: const Text('Casual'),
                                      selected: selectedType == 'casual',
                                      onSelected: (selected) {
                                        setState(() {
                                          selectedType =
                                              selected ? 'casual' : '';
                                          leaveBloc.add(TypeChangeEvent(
                                              type: selectedType));
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    ChoiceChip(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          side: BorderSide.none),
                                      label: const Text('Sick'),
                                      selected: selectedType == 'sick',
                                      onSelected: (selected) {
                                        setState(() {
                                          selectedType = selected ? 'sick' : '';
                                          leaveBloc.add(TypeChangeEvent(
                                              type: selectedType));
                                        });
                                      },
                                    ),
                                  ],
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
                                    showType = false;
                                    showReason = !showReason;
                                    showFrom = false;
                                    showTo = false;
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
                                    hintText: 'Reason for your leave?',
                                    labelText: 'Reason',
                                    controller: reasonController,
                                    onChanged: (val) {
                                      setState(() {
                                        leaveBloc.add(
                                            ReasonChangeEvent(reason: val));
                                      });
                                    },
                                  ),
                                ),
                              if (state is ReasonEmptyState)
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
                                    showType = false;
                                    showReason = false;
                                    showFrom = !showFrom;
                                    showTo = false;
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
                                    Icons.arrow_circle_right_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'From',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  viewFromDay,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (showFrom)
                                TableCalendar(
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  focusedDay: today1,
                                  headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true),
                                  availableGestures: AvailableGestures.all,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(day, today1),
                                  onDaySelected: _onFromSelected,
                                ),
                              if (state is FromDateEmptyState)
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
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showType = false;
                                    showReason = false;
                                    showFrom = false;
                                    showTo = !showTo;
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
                                    Icons.arrow_circle_left_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'To',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  viewToDay,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (showTo)
                                TableCalendar(
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  focusedDay: today2,
                                  headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true),
                                  availableGestures: AvailableGestures.all,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(day, today2),
                                  onDaySelected: _onToSelected,
                                ),
                              if (state is ToDateEmptyState)
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
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showType = false;
                                    showReason = false;
                                    showFrom = false;
                                    showTo = false;
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
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  'Days',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${days + 1}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        state is RequestLeaveLoadingState
                            ? const BigButtonLoading()
                            : BigButton(
                                title: "Request leave for ${days + 1} day",
                                onPressed: () {
                                  if (days < 0) {
                                    Fluttertoast.showToast(
                                        msg: "Invalid dates!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            const Color(0x3F000000),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    leaveBloc.add(RequestBtnPressEvent());
                                    setState(() {
                                      showType = false;
                                      showReason = false;
                                      showFrom = false;
                                      showTo = false;
                                    });
                                  }
                                },
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
}
