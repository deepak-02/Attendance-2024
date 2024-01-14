import 'package:attendance/db/attendance/myAttendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as nav;
import '../../../blocs/attendanceBloc/attendance_bloc.dart';

class MyAttendance extends StatefulWidget {
  final String ? email;
  const MyAttendance({super.key, this.email});

  @override
  State<MyAttendance> createState() => _MyAttendanceState();
}

class _MyAttendanceState extends State<MyAttendance> {
  List<Attendance>? attendance = [];

  @override
  void initState() {
    BlocProvider.of<AttendanceBloc>(context).add(GetMyAttendance(widget.email));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceBloc = context.read<AttendanceBloc>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Text(widget.email == '' || widget.email == null ? "My Attendance" : "Attendance"),
        leading: IconButton(
          tooltip: "back",
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            nav.Get.back();
          },
        ),
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is MyAttendanceSuccess) {
            setState(() {
              attendance = state.attendance;
            });
          } else if (state is MyAttendanceEmpty) {
            setState(() {
              attendance = [];
            });
          }
        },
        builder: (context, state) {
          if (state is MyAttendanceLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MyAttendanceEmpty || attendance!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetMyAttendance(widget.email)),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("No data available for now."),
                  ),
                ],
              ),
            );
          } else if (state is MyAttendanceError) {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetMyAttendance(widget.email)),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(state.message),
                  ),
                ],
              ),
            );
          } else if (state is MyAttendanceSuccess || attendance!.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetMyAttendance(widget.email)),
              child: ListView.separated(
                itemCount: attendance!.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = attendance![index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(
                      "${item.attendanceIn!.date}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('In Time: '),
                            Text(
                              '${item.attendanceIn!.time}',
                              style: TextStyle(
                                  color: item.attendanceIn!.late == true
                                      ? Colors.red
                                      : Colors.black),
                            ),
                          ],
                        ),
                        Text('Out Time: ${item.out!.time}'),
                      ],
                    ),
                    trailing: Text(
                      item.attendanceIn!.late == true ? "late" : "",
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.black12,
                  );
                },
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetMyAttendance(widget.email)),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Something went wrong!"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
