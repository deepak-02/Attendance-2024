import 'dart:convert';

import 'package:attendance/widgets/big_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as nav;
import 'package:lottie/lottie.dart';

import '../../../blocs/adminBloc/admin_bloc.dart';
import '../../../db/admin/adminAttendanceModel.dart';
import '../../../widgets/full_screen_image.dart';
import '../user/user_details_admin.dart';

class ListAttendanceAdmin extends StatefulWidget {
  const ListAttendanceAdmin({Key? key}) : super(key: key);

  @override
  _ListAttendanceAdminState createState() => _ListAttendanceAdminState();
}

class _ListAttendanceAdminState extends State<ListAttendanceAdmin> {



  bool btn1 = false; // Initialize with the default state
  bool btn2 = false; // Initialize with the default state
  String selectedOption = 'All'; // Default selected radio button

  final List<String> _monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> _yearList = [];

  late int selectedMonthIndex;
  late int selectedYearIndex;
  String selectedMonth = "";
  String selectedYear = "";
  String selectedBatch = "";

  List<Attendance>? attendances = [];

  @override
  void initState() {
    BlocProvider.of<AdminBloc>(context).add(GetAdminAttendanceEvent(filter: const {}));
    for (int i = 2022; i <= 2050; i++) {
      _yearList.add(i.toString());
    }
    selectedMonthIndex = DateTime.now().month - 1;
    selectedYearIndex = _yearList.indexOf(DateTime.now().year.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedMonth = _monthList[selectedMonthIndex];
        selectedYear = _yearList[selectedYearIndex];
        selectedBatch = "Batch 1";
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final adminBloc = context.read<AdminBloc>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text("Attendance"),
        actions: [
          IconButton(
            onPressed: () {
              bottomSheet();
            },
            tooltip: "Filter",
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is GetAdminAttendanceSuccess) {
            setState(() {
              attendances = state.attendances;
            });
          }
        },
        builder: (context, state) {
          if (state is GetAdminAttendanceLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }  else if(state is GetAdminAttendanceNotFound) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    // width: 100,
                      child:
                      Lottie.asset('assets/lottie/noData.json')),
                  const Text("No Details Found!"),
                ],
              ),
            );
          } else if(state is GetAdminAttendanceError) {
            return Center(
              child: Text(state.error),
            );
          }else if(state is GetAdminAttendanceSuccess){
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: attendances!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var item = attendances![index];
                  return ListTile(
                    onTap: () {
                      showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: '',
                          transitionDuration: const Duration(milliseconds: 200),
                          context: context,
                          barrierColor: const Color(0x32000000),
                          pageBuilder: (context, animation1, animation2) {
                            return Container();
                          },
                          transitionBuilder: (context, a1, a2, widget) {
                            return ScaleTransition(
                              scale:
                              Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                              child: AlertDialog(
                                surfaceTintColor: Colors.white,
                                backgroundColor: Colors.white,
                                shadowColor: Colors.white,
                                contentPadding: const EdgeInsets.all(15),
                                title: Text(
                                  "${item.name}",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item.email}",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "${item.batch}",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Date: ',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${item.attendanceIn!.date}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'In Time: ',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${item.attendanceIn!.time}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Out Time: ',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${item.out!.time}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Is late: ',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${item.attendanceIn!.late}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Get to profile page with the item details
                                            nav.Get.to(UserDetailsAdmin(details: item,));
                                          },
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "View Profile",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                              ),
                            );
                          });
                    },
                    leading:
                    item.image == '' ?
                    const CircleAvatar(
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
                              '${item.attendanceIn!.time}',
                              style: TextStyle(color: item.attendanceIn!.late  == true ? Colors.red : Colors.black),
                            ),
                          ],
                        ),
                        Text('Out Time: ${item.out!.time}'),
                      ],
                    ),
                  );
                });
          }else{
            return const Center(
              child: Text("Something Wrong!"),
            );
          }

        },
      ),
    );
  }


  bottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Radio buttons

                  Row(
                    children: [
                      Radio(
                        value: 'All',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            btn1 = true;
                            btn2 = false;
                          });
                        },
                      ),
                      Text('All'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Custom',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            btn1 = false;
                            btn2 = true;
                          });
                        },
                      ),
                      Text('Custom'),
                    ],
                  ),

                  if (selectedOption == "Custom")
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.black87,
                                style: BorderStyle.solid,
                                width: 1),
                          ),
                          child: DropdownButton<String>(
                            underline: Container(),
                            items: _monthList.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            value: selectedMonth,
                            onChanged: (val) {
                              setState(() {
                                selectedMonthIndex = _monthList.indexOf(val!);
                                selectedMonth = val;
                                print(selectedMonthIndex + 1);
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.black87,
                                style: BorderStyle.solid,
                                width: 1),
                          ),
                          child: DropdownButton<String>(
                            underline: Container(),
                            items: _yearList.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            value: selectedYear,
                            onChanged: (val) {
                              setState(() {
                                selectedYear = val ?? "";
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.black87,
                                style: BorderStyle.solid,
                                width: 1),
                          ),
                          child: DropdownButton<String>(
                            underline: Container(),
                            items: ['All','Batch 1', 'Batch 2', 'Batch 3'].map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            value: selectedBatch,
                            onChanged: (val) {
                              setState(() {
                                selectedBatch = val ?? "";
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(
                    height: 10,
                  ),
                  BigButton(
                    title: "Apply Filter",
                    onPressed: () {
                      if (selectedOption == "Custom"){
                        if (selectedBatch == 'All') {
                          BlocProvider.of<AdminBloc>(context).add(GetAdminAttendanceEvent(filter: {
                            "month": "${selectedMonthIndex+1}",
                            "year": selectedYear
                          }));
                        }  else{
                          BlocProvider.of<AdminBloc>(context).add(GetAdminAttendanceEvent(filter: {
                            "month": "${selectedMonthIndex+1}",
                            "year": selectedYear,
                            "batch": selectedBatch
                          }));
                        }

                      } else{
                        BlocProvider.of<AdminBloc>(context).add(GetAdminAttendanceEvent(filter: const {}));
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
