import 'package:attendance/db/late/getlateModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../blocs/lateBloc/late_bloc.dart';

class LateRequests extends StatefulWidget {
  const LateRequests({super.key});

  @override
  _LateRequestsState createState() => _LateRequestsState();
}

class _LateRequestsState extends State<LateRequests> {
  bool btn1 = true;
  bool btn2 = false;
  bool btn3 = false;
  bool btn4 = false;

  String? email = '';
  String? role = 'user';

  List<LateRequest>? lateRequests = [];
  @override
  void initState() {
    getUserEmail();
    super.initState();
  }

  getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    email = prefs.getString("email");
    getData();
  }

  getData() {
    if (role == 'admin') {
      BlocProvider.of<LateBloc>(context).add(GetAllLateEvent(status: 'all'));
    } else {
      BlocProvider.of<LateBloc>(context)
          .add(GetLateByEmailEvent(status: 'all'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lateBloc = context.read<LateBloc>();
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
      body: BlocConsumer<LateBloc, LateState>(
        listener: (context, state) {
          if (state is GetLateByEmailSuccessState) {
            setState(() {
              lateRequests = state.lateRequests;
            });
          } else if (state is GetAllLateSuccessState) {
            setState(() {
              lateRequests = state.lateRequests;
            });
          } else if(state is ChangeLateStatusSuccessState){
            getData();
          } else if(state is ChangeLateStatusErrorState){
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
          if (state is GetAllLateSuccessState ||
              state is GetLateByEmailSuccessState ||
              state is GetLateByEmailNotFoundState ||
              state is GetAllLateNotFoundState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Late Requests',
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
                                if (role == 'admin') {
                                  lateBloc.add(GetAllLateEvent(status: 'all'));
                                } else {
                                  lateBloc
                                      .add(GetLateByEmailEvent(status: 'all'));
                                }
                                setState(() {
                                  btn1 = true;
                                  btn2 = false;
                                  btn3 = false;
                                  btn4 = false;
                                });
                              },
                              child: btn1 == true
                                  ? Container(
                                      // width: 60,
                                      padding:
                                          const EdgeInsets.only(left: 10, right: 10),
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
                                      padding: EdgeInsets.only(left: 20),
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
                                if (role == 'admin') {
                                  lateBloc.add(
                                      GetAllLateEvent(status: 'requested'));
                                } else {
                                  lateBloc.add(
                                      GetLateByEmailEvent(status: 'requested'));
                                }

                                setState(() {
                                  btn1 = false;
                                  btn2 = true;
                                  btn3 = false;
                                  btn4 = false;
                                });
                              },
                              child: btn2 == true
                                  ? Container(
                                      // width: 80,
                                      padding:
                                          const EdgeInsets.only(left: 10, right: 10),
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Pending",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : SizedBox(
                                      // width: 60,
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
                                            " Pending",
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
                                if (role == 'admin') {
                                  lateBloc
                                      .add(GetAllLateEvent(status: 'approved'));
                                } else {
                                  lateBloc.add(
                                      GetLateByEmailEvent(status: 'approved'));
                                }

                                setState(() {
                                  btn1 = false;
                                  btn2 = false;
                                  btn3 = true;
                                  btn4 = false;
                                });
                              },
                              child: btn3 == true
                                  ? Container(
                                      // width: 100,
                                      padding:
                                          const EdgeInsets.only(left: 10, right: 10),
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
                                  : SizedBox(
                                      // width: 80,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: ShapeDecoration(
                                              color: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                          const Text(
                                            " Approved",
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
                                if (role == 'admin') {
                                  lateBloc
                                      .add(GetAllLateEvent(status: 'rejected'));
                                } else {
                                  lateBloc.add(
                                      GetLateByEmailEvent(status: 'rejected'));
                                }

                                setState(() {
                                  btn1 = false;
                                  btn2 = false;
                                  btn3 = false;
                                  btn4 = true;
                                });
                              },
                              child: btn4 == true
                                  ? Container(
                                      // width: 100,
                                      padding:
                                          const EdgeInsets.only(left: 10, right: 10),
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
                                  : SizedBox(
                                      // width: 80,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: ShapeDecoration(
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                          const Text(
                                            " Rejected",
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
                      if (state is GetAllLateSuccessState ||
                          state is GetLateByEmailSuccessState)
                        GroupedListView<LateRequest, dynamic>(
                          elements: lateRequests!,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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

                          indexedItemBuilder: (context, late, index) {
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  late.requestMethod=='app'?'user' :'admin',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: ShapeDecoration(
                                                    color: late.requestStatus ==
                                                        'rejected'
                                                        ? const Color(
                                                        0x3FFF3737)
                                                        : late.requestStatus ==
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
                                                    late.requestStatus ==
                                                        'rejected'
                                                        ? 'Rejected'
                                                        : late.requestStatus ==
                                                        'approved'
                                                        ? 'Approved'
                                                        : 'Awaiting',
                                                    style: TextStyle(
                                                      color: late.requestStatus ==
                                                          'rejected'
                                                          ? Colors.redAccent
                                                          : late.requestStatus ==
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
                                                  "${late.email}",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${late.name}',
                                                  style: const TextStyle(
                                                    color: Colors.black26,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
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
                                                            '${late.requestedOn}',
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
                                                        text: formatDateString("${late.on}"),
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
                                                        text: '${late.reason}',
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
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                if (role == 'admin' &&
                                                    late.requestStatus ==
                                                        'requested')
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          lateBloc.add(ChangeLateStatusEvent(
                                                              email:
                                                                  "${late.email}",
                                                              id:
                                                                  "${late.lateId}",
                                                              status:
                                                                  'rejected'));
                                                          Navigator.pop(
                                                              context);
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
                                                        child: const Text(
                                                            "Reject"),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          lateBloc.add(ChangeLateStatusEvent(
                                                              email:
                                                                  "${late.email}",
                                                              id:
                                                                  "${late.lateId}",
                                                              status:
                                                                  'approved'));
                                                          Navigator.pop(
                                                              context);
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
                                                        child: const Text(
                                                            "Approve"),
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
                                    color: late.requestStatus == 'rejected'
                                        ? const Color(0x3FFF3737)
                                        : late.requestStatus == 'approved'
                                            ? const Color(0x7037FF87)
                                            : const Color(0x3FFFD337),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    late.requestStatus == 'rejected'
                                        ? 'Rejected'
                                        : late.requestStatus == 'approved'
                                            ? 'Approved'
                                            : 'Awaiting',
                                    style: TextStyle(
                                      color: late.requestStatus == 'rejected'
                                          ? Colors.redAccent
                                          : late.requestStatus == 'approved'
                                              ? Colors.green
                                              : const Color(0xFFDAAD0C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${late.email}',
                                  style: const TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatDateString("${late.on}"),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                    Text(
                                      "${late.reason}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemComparator: (item1, item2) => item1.requestedOn!
                              .compareTo(item2.requestedOn!), // optional
                          useStickyGroupSeparators: false, // optional
                          floatingHeader: true, // optional
                          order: GroupedListOrder.DESC, // optional
                        ),
                      if (state is GetLateByEmailNotFoundState ||
                          state is GetAllLateNotFoundState)
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
          } else if (state is GetAllLateErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is GetLateByEmailErrorState) {
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
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat('EEE, dd MMM yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid Date";
    }
  }

}
