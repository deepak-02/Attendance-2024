import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as nav;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../blocs/leaveBloc/leave_bloc.dart';
import '../../../db/leave/listLeave.dart';

class LeaveRequests extends StatefulWidget {
  const LeaveRequests({super.key});

  @override
  _LeaveRequestsState createState() => _LeaveRequestsState();
}

class _LeaveRequestsState extends State<LeaveRequests> {
  bool btn1 = true;
  bool btn2 = false;
  bool btn3 = false;

  List<LeaveRequest>? leaveRequests = [];
  @override
  void initState() {
    BlocProvider.of<LeaveBloc>(context).add(ListLeaveEvent(type: 'all'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leaveBloc = context.read<LeaveBloc>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        leading: IconButton(
          tooltip: "back",
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            nav.Get.back();
          },
        ),
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is ListLeaveSuccessState) {
            setState(() {
              leaveRequests = state.leaveRequests;
            });
          }
        },
        builder: (context, state) {
          if (state is ListLeaveSuccessState ||
              state is ListLeaveNotFoundState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Leaves',
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
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                leaveBloc.add(ListLeaveEvent(type: 'all'));
                                setState(() {
                                  btn1 = true;
                                  btn2 = false;
                                  btn3 = false;
                                });
                              },
                              child: btn1 == true
                                  ? Container(
                                      width: 100,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "All",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Text(
                                        "All",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                leaveBloc.add(ListLeaveEvent(type: 'casual'));
                                setState(() {
                                  btn1 = false;
                                  btn2 = true;
                                  btn3 = false;
                                });
                              },
                              child: btn2 == true
                                  ? Container(
                                      width: 100,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Casual",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFFFD337),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                          const Text(
                                            " Casual",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                leaveBloc.add(ListLeaveEvent(type: 'sick'));
                                setState(() {
                                  btn1 = false;
                                  btn2 = false;
                                  btn3 = true;
                                });
                              },
                              child: btn3 == true
                                  ? Container(
                                      width: 100,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Sick",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: ShapeDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                          const Text(
                                            " Sick",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (state is ListLeaveSuccessState)
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: leaveRequests!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var leave = leaveRequests![index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: ListTile(
                                  onTap: () {
                                    showGeneralDialog(
                                        barrierDismissible: true,
                                        barrierLabel: '',
                                        transitionDuration:
                                            const Duration(milliseconds: 200),
                                        context: context,
                                        barrierColor: const Color(0x32000000),
                                        pageBuilder:
                                            (context, animation1, animation2) {
                                          return Container();
                                        },
                                        transitionBuilder:
                                            (context, a1, a2, widget) {
                                          return ScaleTransition(
                                            scale: Tween<double>(
                                                    begin: 0.5, end: 1.0)
                                                .animate(a1),
                                            child: AlertDialog(
                                              surfaceTintColor: Colors.white,
                                              backgroundColor: Colors.white,
                                              shadowColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    leave.type == null ||
                                                            leave.type == ''
                                                        ? ""
                                                        : leave.type![0]
                                                                .toUpperCase() +
                                                            leave.type!
                                                                .substring(1),
                                                    style: TextStyle(
                                                      color: leave.type ==
                                                              'sick'
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary
                                                          : const Color(
                                                              0xFFFFD337),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 30,
                                                    decoration: ShapeDecoration(
                                                      color: leave.requestStatus ==
                                                              'rejected'
                                                          ? const Color(
                                                              0x3FFF3737)
                                                          : leave.requestStatus ==
                                                                  'approved'
                                                              ? const Color(
                                                                  0x7037FF87)
                                                              : const Color(
                                                                  0x3FFFD337),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: Text(
                                                      leave.requestStatus ==
                                                              'rejected'
                                                          ? 'Rejected'
                                                          : leave.requestStatus ==
                                                                  'approved'
                                                              ? 'Approved'
                                                              : 'Awaiting',
                                                      style: TextStyle(
                                                        color: leave.requestStatus ==
                                                                'rejected'
                                                            ? Colors.redAccent
                                                            : leave.requestStatus ==
                                                                    'approved'
                                                                ? Colors.green
                                                                : const Color(
                                                                    0xFFDAAD0C),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    leave.requestDate == null ||
                                                            leave.requestDate ==
                                                                '' ||
                                                            leave.toDate ==
                                                                null ||
                                                            leave.toDate == ''
                                                        ? ""
                                                        : '${getDifference(leave.requestDate!, leave.toDate!)} Day Application',
                                                    style: const TextStyle(
                                                      color: Colors.black26,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Requested on: ',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${leave.requestedOn}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Request Date: ',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${leave.requestDate}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Requested Until: ',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${leave.toDate}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // RichText(
                                                  //   text:  TextSpan(
                                                  //     text: 'Leave Type: ',
                                                  //     style: const TextStyle(
                                                  //         fontSize: 14,
                                                  //         fontWeight: FontWeight.w400,
                                                  //         color: Colors.black
                                                  //     ),
                                                  //     children: <TextSpan>[
                                                  //       TextSpan(
                                                  //         text: '${leave.type![0].toUpperCase() + leave.type!.substring(1)}',
                                                  //         style: TextStyle(
                                                  //           fontSize: 14,
                                                  //           fontWeight: FontWeight.bold,
                                                  //           color: leave.type == 'sick' ? Theme.of(context)
                                                  //               .colorScheme
                                                  //               .inversePrimary : Color(0xFFFFD337),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),

                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Reason: ',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${leave.reason}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // RichText(
                                                  //   text:  TextSpan(
                                                  //     text: 'Request Status: ',
                                                  //     style: const TextStyle(
                                                  //         fontSize: 14,
                                                  //         fontWeight: FontWeight.w400,
                                                  //         color: Colors.black
                                                  //     ),
                                                  //     children: <TextSpan>[
                                                  //       TextSpan(
                                                  //         text: leave.requestStatus == 'rejected' ? 'Rejected' : leave.requestStatus == 'approved' ? 'Approved' : 'Awaiting',
                                                  //         style: TextStyle(
                                                  //           fontSize: 14,
                                                  //           fontWeight: FontWeight.bold,
                                                  //           color: leave.requestStatus == 'rejected' ?  Color(0x3FFF3737) : leave.requestStatus == 'approved' ? Color(0x7037FF87) : Color(0x3FFFD337),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),

                                                  if (leave
                                                          .approvedOrRejectedOn !=
                                                      "")
                                                    RichText(
                                                      text: TextSpan(
                                                        text:
                                                            '${leave.requestStatus![0].toUpperCase() + leave.requestStatus!.substring(1)} on: ',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: leave
                                                                .approvedOrRejectedOn,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: leave.requestStatus ==
                                                                      'rejected'
                                                                  ? Colors
                                                                      .redAccent
                                                                  : Colors
                                                                      .green,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              shape: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none),
                                            ),
                                          );
                                        });
                                  },
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      color: leave.requestStatus == 'rejected'
                                          ? const Color(0x3FFF3737)
                                          : leave.requestStatus == 'approved'
                                              ? const Color(0x7037FF87)
                                              : const Color(0x3FFFD337),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      leave.requestStatus == 'rejected'
                                          ? 'Rejected'
                                          : leave.requestStatus == 'approved'
                                              ? 'Approved'
                                              : 'Awaiting',
                                      style: TextStyle(
                                        color: leave.requestStatus == 'rejected'
                                            ? Colors.redAccent
                                            : leave.requestStatus == 'approved'
                                                ? Colors.green
                                                : const Color(0xFFDAAD0C),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    leave.requestDate == null ||
                                            leave.requestDate == '' ||
                                            leave.toDate == null ||
                                            leave.toDate == ''
                                        ? ""
                                        : '${getDifference(leave.requestDate!, leave.toDate!)} Day Application',
                                    style: const TextStyle(
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatDateString(
                                            "${leave.requestDate}"),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                      Text(
                                        leave.type![0].toUpperCase() +
                                            leave.type!.substring(1),
                                        style: TextStyle(
                                          color: leave.type == 'sick'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                              : const Color(0xFFFFD337),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      if (state is ListLeaveNotFoundState)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                // width: 100,
                                child:
                                    Lottie.asset('assets/lottie/noData.json')),
                            const Text("No Leave Details Found!"),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ListLeaveErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String formatDateString(String dateString) {
    try {
      DateTime dateTime = DateFormat('MM/dd/yyyy').parse(dateString);
      String formattedDate = DateFormat('EEE, dd MMM yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid Date";
    }
  }

  int getDifference(String requestDate, String toDate) {
    DateTime date1 = DateFormat('MM/dd/yyyy').parse(requestDate);
    DateTime date2 = DateFormat('MM/dd/yyyy').parse(toDate);
    Duration difference = date2.difference(date1);
    int differenceInDays = difference.inDays;
    return differenceInDays + 1;
  }
}
