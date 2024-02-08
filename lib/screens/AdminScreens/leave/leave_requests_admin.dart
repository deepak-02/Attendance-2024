import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../blocs/adminBloc/admin_bloc.dart';
import '../../../db/leave/listLeave.dart';

class LeaveRequestsAdmin extends StatefulWidget {
  const LeaveRequestsAdmin({super.key});

  @override
  _LeaveRequestsAdminState createState() => _LeaveRequestsAdminState();
}

class _LeaveRequestsAdminState extends State<LeaveRequestsAdmin> {
  bool btn1 = true;
  bool btn2 = false;
  bool btn3 = false;
  bool btn4 = false;

  List<LeaveRequest>? leaveRequests = [];

  @override
  void initState() {
    BlocProvider.of<AdminBloc>(context)
        .add(GetAdminLeaveRequestsEvent(type: 'all'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leaveBloc = context.read<AdminBloc>();
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
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          print("State: $state");
          if (state is GetAdminLeaveRequestsSuccess) {
            setState(() {
              leaveRequests = state.leaveRequests;
            });
          } else if (state is LeaveStatusChangeSuccess ||
              state is LeaveStatusChangeError) {
            setState(() {
              btn1 = true;
              btn2 = false;
              btn3 = false;
              btn4 = false;
              leaveBloc.add(GetAdminLeaveRequestsEvent(type: 'all'));
            });
            if (state is LeaveStatusChangeError) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        builder: (context, state) {
          if (state is GetAdminLeaveRequestsNotFound ||
              state is LeaveStatusChangeError ||
              state is GetAdminLeaveRequestsSuccess) {
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
                                leaveBloc.add(
                                    GetAdminLeaveRequestsEvent(type: 'all'));
                                setState(() {
                                  btn1 = true;
                                  btn2 = false;
                                  btn3 = false;
                                  btn4 = false;
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
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "All",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                leaveBloc.add(GetAdminLeaveRequestsEvent(
                                    type: 'requested'));
                                setState(() {
                                  btn1 = false;
                                  btn2 = true;
                                  btn3 = false;
                                  btn4 = false;
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
                                        "Awaiting",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const Text(
                                      "Awaiting",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFDAAD0C),
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                leaveBloc.add(GetAdminLeaveRequestsEvent(
                                    type: 'approved'));
                                setState(() {
                                  btn1 = false;
                                  btn2 = false;
                                  btn3 = true;
                                  btn4 = false;
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
                                        "Approved",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const Text(
                                      "Approved",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                leaveBloc.add(GetAdminLeaveRequestsEvent(
                                    type: 'rejected'));
                                setState(() {
                                  btn1 = false;
                                  btn2 = false;
                                  btn3 = false;
                                  btn4 = true;
                                });
                              },
                              child: btn4 == true
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
                                        "Rejected",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Rejected",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (state is GetAdminLeaveRequestsSuccess)
                        GroupedListView<LeaveRequest, dynamic>(
                          elements: leaveRequests!,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: true,
                          groupBy: (element) {
                            // print(element.requestedOn);
                            String? dateString = element.requestedOn;
                            DateTime date =
                                DateFormat('MM/d/yyyy').parse(dateString!);
                            String monthName =
                                DateFormat('MMMM yyyy').format(date);
                            return monthName;
                          },
                          stickyHeaderBackgroundColor: Colors.transparent,
                          groupSeparatorBuilder: (groupByValue) => Container(
                              alignment: Alignment.center,
                              // height: 30,
                              // width: 200,
                              decoration: const BoxDecoration(
                                color: Color(0x32e1e1e1),
                                // borderRadius: BorderRadius.circular(16)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "$groupByValue",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              )),

                          indexedItemBuilder: (context, leave, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                                    color: leave.type == 'sick'
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary
                                                        : const Color(
                                                            0xFFFFD337),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  "${leave.email}",
                                                ),
                                                Text(
                                                  "${leave.name}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
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
                                                          color:
                                                              Theme.of(context)
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
                                                        style: const TextStyle(
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
                                                        text: '${leave.toDate}',
                                                        style: const TextStyle(
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
                                                    text: 'Reason: ',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '${leave.reason}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: leave
                                                              .approvedOrRejectedOn,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: leave.requestStatus ==
                                                                    'rejected'
                                                                ? Colors
                                                                    .redAccent
                                                                : Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                if(leave.requestStatus ==
                                                    'requested')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        leaveBloc.add(
                                                            LeaveStatusChangeEvent(
                                                                email:
                                                                    "${leave.email}",
                                                                id:
                                                                    "${leave.leaveId}",
                                                                status:
                                                                    "rejected"));
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                      ),
                                                      child: const Text("Reject"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        leaveBloc.add(
                                                            LeaveStatusChangeEvent(
                                                                email:
                                                                    "${leave.email}",
                                                                id:
                                                                    "${leave.leaveId}",
                                                                status:
                                                                    "approved"));
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                      ),
                                                      child: const Text("Approve"),
                                                    ),
                                                  ],
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
                                        borderRadius: BorderRadius.circular(8)),
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
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${leave.name}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${leave.email}",
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatDateString("${leave.requestDate}"),
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
                          },
                          itemComparator: (item1, item2) => item1.requestDate!
                              .compareTo(item2.requestDate!), // optional
                          useStickyGroupSeparators: false, // optional
                          floatingHeader: true, // optional
                          order: GroupedListOrder.DESC, // optional
                        ),

                      // ListView.builder(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: leaveRequests!.length,
                      //     shrinkWrap: true,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       var leave = leaveRequests![index];
                      //       return Padding(
                      //         padding: const EdgeInsets.only(
                      //             top: 8.0, bottom: 8.0),
                      //         child: ListTile(
                      //           onTap: () {
                      //             showGeneralDialog(
                      //                 barrierDismissible: true,
                      //                 barrierLabel: '',
                      //                 transitionDuration:
                      //                     const Duration(milliseconds: 200),
                      //                 context: context,
                      //                 barrierColor: const Color(0x32000000),
                      //                 pageBuilder:
                      //                     (context, animation1, animation2) {
                      //                   return Container();
                      //                 },
                      //                 transitionBuilder:
                      //                     (context, a1, a2, widget) {
                      //                   return ScaleTransition(
                      //                     scale: Tween<double>(
                      //                             begin: 0.5, end: 1.0)
                      //                         .animate(a1),
                      //                     child: AlertDialog(
                      //                       surfaceTintColor: Colors.white,
                      //                       backgroundColor: Colors.white,
                      //                       shadowColor: Colors.white,
                      //                       contentPadding:
                      //                           const EdgeInsets.all(15),
                      //                       title: Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment
                      //                                 .spaceBetween,
                      //                         children: [
                      //                           Text(
                      //                             leave.type == null ||
                      //                                     leave.type == ''
                      //                                 ? ""
                      //                                 : leave.type![0]
                      //                                         .toUpperCase() +
                      //                                     leave.type!
                      //                                         .substring(1),
                      //                             style: TextStyle(
                      //                               color: leave.type ==
                      //                                       'sick'
                      //                                   ? Theme.of(context)
                      //                                       .colorScheme
                      //                                       .inversePrimary
                      //                                   : const Color(
                      //                                       0xFFFFD337),
                      //                               fontSize: 18,
                      //                               fontWeight:
                      //                                   FontWeight.bold,
                      //                             ),
                      //                           ),
                      //                           Container(
                      //                             width: 100,
                      //                             height: 30,
                      //                             decoration: ShapeDecoration(
                      //                               color: leave.requestStatus ==
                      //                                       'rejected'
                      //                                   ? const Color(
                      //                                       0x3FFF3737)
                      //                                   : leave.requestStatus ==
                      //                                           'approved'
                      //                                       ? const Color(
                      //                                           0x7037FF87)
                      //                                       : const Color(
                      //                                           0x3FFFD337),
                      //                               shape:
                      //                                   RoundedRectangleBorder(
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(
                      //                                                   8)),
                      //                             ),
                      //                             alignment: Alignment.center,
                      //                             padding:
                      //                                 const EdgeInsets.all(2),
                      //                             child: Text(
                      //                               leave.requestStatus ==
                      //                                       'rejected'
                      //                                   ? 'Rejected'
                      //                                   : leave.requestStatus ==
                      //                                           'approved'
                      //                                       ? 'Approved'
                      //                                       : 'Awaiting',
                      //                               style: TextStyle(
                      //                                 color: leave.requestStatus ==
                      //                                         'rejected'
                      //                                     ? Colors.redAccent
                      //                                     : leave.requestStatus ==
                      //                                             'approved'
                      //                                         ? Colors.green
                      //                                         : const Color(
                      //                                             0xFFDAAD0C),
                      //                                 fontSize: 16,
                      //                                 fontWeight:
                      //                                     FontWeight.w700,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       content: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Text(
                      //                             leave.requestDate == null ||
                      //                                     leave.requestDate ==
                      //                                         '' ||
                      //                                     leave.toDate ==
                      //                                         null ||
                      //                                     leave.toDate == ''
                      //                                 ? ""
                      //                                 : '${getDifference(leave.requestDate!, leave.toDate!)} Day Application',
                      //                             style: const TextStyle(
                      //                               color: Colors.black26,
                      //                               fontSize: 14,
                      //                               fontWeight:
                      //                                   FontWeight.w400,
                      //                             ),
                      //                           ),
                      //                           Text(
                      //                             "${leave.email}",
                      //                           ),
                      //                           Text(
                      //                             "${leave.name}",
                      //                             style: const TextStyle(
                      //                               color: Colors.black,
                      //                               fontSize: 14,
                      //                               fontWeight:
                      //                                   FontWeight.w600,
                      //                             ),
                      //                           ),
                      //                           RichText(
                      //                             text: TextSpan(
                      //                               text: 'Requested on: ',
                      //                               style: const TextStyle(
                      //                                   fontSize: 14,
                      //                                   fontWeight:
                      //                                       FontWeight.w400,
                      //                                   color: Colors.black),
                      //                               children: <TextSpan>[
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${leave.requestedOn}',
                      //                                   style: TextStyle(
                      //                                     fontSize: 14,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                     color: Theme.of(
                      //                                             context)
                      //                                         .primaryColor,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           RichText(
                      //                             text: TextSpan(
                      //                               text: 'Request Date: ',
                      //                               style: const TextStyle(
                      //                                   fontSize: 14,
                      //                                   fontWeight:
                      //                                       FontWeight.w400,
                      //                                   color: Colors.black),
                      //                               children: <TextSpan>[
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${leave.requestDate}',
                      //                                   style:
                      //                                       const TextStyle(
                      //                                     fontSize: 14,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                     color:
                      //                                         Colors.blueGrey,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           RichText(
                      //                             text: TextSpan(
                      //                               text: 'Requested Until: ',
                      //                               style: const TextStyle(
                      //                                   fontSize: 14,
                      //                                   fontWeight:
                      //                                       FontWeight.w400,
                      //                                   color: Colors.black),
                      //                               children: <TextSpan>[
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${leave.toDate}',
                      //                                   style:
                      //                                       const TextStyle(
                      //                                     fontSize: 14,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                     color:
                      //                                         Colors.blueGrey,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           RichText(
                      //                             text: TextSpan(
                      //                               text: 'Reason: ',
                      //                               style: const TextStyle(
                      //                                   fontSize: 14,
                      //                                   fontWeight:
                      //                                       FontWeight.w400,
                      //                                   color: Colors.black),
                      //                               children: <TextSpan>[
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${leave.reason}',
                      //                                   style: TextStyle(
                      //                                     fontSize: 14,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                     color: Theme.of(
                      //                                             context)
                      //                                         .colorScheme
                      //                                         .primary,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           if (leave
                      //                                   .approvedOrRejectedOn !=
                      //                               "")
                      //                             RichText(
                      //                               text: TextSpan(
                      //                                 text:
                      //                                     '${leave.requestStatus![0].toUpperCase() + leave.requestStatus!.substring(1)} on: ',
                      //                                 style: const TextStyle(
                      //                                     fontSize: 14,
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                     color:
                      //                                         Colors.black),
                      //                                 children: <TextSpan>[
                      //                                   TextSpan(
                      //                                     text: leave
                      //                                         .approvedOrRejectedOn,
                      //                                     style: TextStyle(
                      //                                       fontSize: 14,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .bold,
                      //                                       color: leave.requestStatus ==
                      //                                               'rejected'
                      //                                           ? Colors
                      //                                               .redAccent
                      //                                           : Colors
                      //                                               .green,
                      //                                     ),
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                             ),
                      //                           SizedBox(
                      //                             height: 16,
                      //                           ),
                      //                           Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceEvenly,
                      //                             children: [
                      //                               ElevatedButton(
                      //                                 onPressed: () {
                      //                                   leaveBloc.add(LeaveStatusChangeEvent(
                      //                                       email:
                      //                                           "${leave.email}",
                      //                                       id:
                      //                                           "${leave.leaveId}",
                      //                                       status:
                      //                                           "rejected"));
                      //                                   Navigator.pop(
                      //                                       context);
                      //                                 },
                      //                                 child: Text("Reject"),
                      //                                 style: ElevatedButton
                      //                                     .styleFrom(
                      //                                   backgroundColor:
                      //                                       Colors.red,
                      //                                   foregroundColor:
                      //                                       Colors.white,
                      //                                   shape:
                      //                                       RoundedRectangleBorder(
                      //                                     borderRadius:
                      //                                         BorderRadius
                      //                                             .circular(
                      //                                                 5.0),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               ElevatedButton(
                      //                                 onPressed: () {
                      //                                   leaveBloc.add(LeaveStatusChangeEvent(
                      //                                       email:
                      //                                           "${leave.email}",
                      //                                       id:
                      //                                           "${leave.leaveId}",
                      //                                       status:
                      //                                           "approved"));
                      //                                   Navigator.pop(
                      //                                       context);
                      //                                 },
                      //                                 child: Text("Approve"),
                      //                                 style: ElevatedButton
                      //                                     .styleFrom(
                      //                                   backgroundColor:
                      //                                       Colors.green,
                      //                                   foregroundColor:
                      //                                       Colors.white,
                      //                                   shape:
                      //                                       RoundedRectangleBorder(
                      //                                     borderRadius:
                      //                                         BorderRadius
                      //                                             .circular(
                      //                                                 5.0),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       shape: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(10),
                      //                           borderSide: BorderSide.none),
                      //                     ),
                      //                   );
                      //                 });
                      //           },
                      //           shape: RoundedRectangleBorder(
                      //             side: BorderSide(
                      //               width: 1,
                      //               color: Colors.black.withOpacity(0.5),
                      //             ),
                      //             borderRadius: BorderRadius.circular(16),
                      //           ),
                      //           trailing: Container(
                      //             width: 100,
                      //             height: 30,
                      //             decoration: ShapeDecoration(
                      //               color: leave.requestStatus == 'rejected'
                      //                   ? const Color(0x3FFF3737)
                      //                   : leave.requestStatus == 'approved'
                      //                       ? const Color(0x7037FF87)
                      //                       : const Color(0x3FFFD337),
                      //               shape: RoundedRectangleBorder(
                      //                   borderRadius:
                      //                       BorderRadius.circular(8)),
                      //             ),
                      //             alignment: Alignment.center,
                      //             padding: const EdgeInsets.all(2),
                      //             child: Text(
                      //               leave.requestStatus == 'rejected'
                      //                   ? 'Rejected'
                      //                   : leave.requestStatus == 'approved'
                      //                       ? 'Approved'
                      //                       : 'Awaiting',
                      //               style: TextStyle(
                      //                 color: leave.requestStatus == 'rejected'
                      //                     ? Colors.redAccent
                      //                     : leave.requestStatus == 'approved'
                      //                         ? Colors.green
                      //                         : const Color(0xFFDAAD0C),
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.w700,
                      //               ),
                      //             ),
                      //           ),
                      //           title: Column(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Text(
                      //                 "${leave.name}",
                      //                 style: const TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "${leave.email}",
                      //                 style: const TextStyle(
                      //                   color: Colors.black38,
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.w400,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           subtitle: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 formatDateString(
                      //                     "${leave.requestDate}"),
                      //                 style: const TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w700,
                      //                   height: 0,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 leave.type![0].toUpperCase() +
                      //                     leave.type!.substring(1),
                      //                 style: TextStyle(
                      //                   color: leave.type == 'sick'
                      //                       ? Theme.of(context)
                      //                           .colorScheme
                      //                           .inversePrimary
                      //                       : const Color(0xFFFFD337),
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w400,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     }),

                      if (state is GetAdminLeaveRequestsNotFound)
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
          } else if (state is GetAdminLeaveRequestsError) {
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
