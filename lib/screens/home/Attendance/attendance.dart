import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as nav;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../blocs/attendanceBloc/attendance_bloc.dart';
import '../../../db/attendance/currentAttendanceModel.dart';
import '../../../widgets/full_screen_image.dart';
import 'my_attendance.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<AttendanceElement>? attendance = [];
  String? role = 'user';

  @override
  void initState() {
    BlocProvider.of<AttendanceBloc>(context).add(GetCurrentAttendance());
    getRole();
    super.initState();
  }

  void getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceBloc = context.read<AttendanceBloc>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text("Today's Attendance"),
        actions: [
          // if (role == 'user')
          IconButton(
              tooltip: "My Attendance",
              onPressed: () {
                nav.Get.to(const MyAttendance());
              },
              icon: const Icon(Icons.history_toggle_off))
        ],
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is GetCurrentAttendanceSuccess) {
            setState(() {
              attendance = state.attendance;
            });
          } else if (state is GetCurrentAttendanceEmpty) {
            setState(() {
              attendance = [];
            });
          }
        },
        builder: (context, state) {
          if (state is GetCurrentAttendanceLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetCurrentAttendanceEmpty ||
              attendance!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetCurrentAttendance()),
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
          } else if (state is GetCurrentAttendanceError) {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetCurrentAttendance()),
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
          } else if (state is GetCurrentAttendanceSuccess ||
              attendance!.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetCurrentAttendance()),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: attendance!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = attendance![index];
                    return ListTile(
                      leading: item.image == ''
                          ? const CircleAvatar(
                              radius: 30,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                nav.Get.to(FullScreenImagePage(
                                  image: item.image!,
                                  title: '${item.name}',
                                ));
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    MemoryImage(base64Decode(item.image!)),
                              ),
                            ),
                      title: Text("${item.name}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('In Time: '),
                              Text(
                                '${item.attendance!.attendanceIn!.time}',
                                style: TextStyle(
                                    color:
                                        item.attendance!.attendanceIn!.late ==
                                                true
                                            ? Colors.red
                                            : Colors.black),
                              ),
                            ],
                          ),
                          Text('Out Time: ${item.attendance!.out!.time}'),
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async => attendanceBloc.add(GetCurrentAttendance()),
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
