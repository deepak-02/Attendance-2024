import 'dart:convert';

import 'package:attendance/screens/AdminScreens/user/users_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../blocs/adminBloc/admin_bloc.dart';
import '../../../db/admin/adminUsersModel.dart';
import '../../../widgets/big_button.dart';
import '../../../widgets/full_screen_image.dart';
import '../../../widgets/input_field.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  bool btn1 = false; // Initialize with the default state
  bool btn2 = false; // Initialize with the default state
  String selectedOption = 'All'; // Default selected radio button
  String selectedBatch = "";

  TextEditingController searchController = TextEditingController();
  List<AdminUsersModel> filteredUsers = [];
  // List<AdminUsersModel> allUsers = [];

  @override
  void initState() {
    BlocProvider.of<AdminBloc>(context).add(GetAllUsers(filter: "All"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text("Users"),
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
          if (state is GetAllUsersSuccess) {
            setState(() {
              filteredUsers = state.users;
              // allUsers = state.users;
            });
          }
        },
        builder: (context, state) {
          if (state is GetAllUsersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetAllUsersNotFound) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      // width: 100,
                      child: Lottie.asset('assets/lottie/noData.json')),
                  const Text("No Users Found!"),
                ],
              ),
            );
          } else if (state is GetAllUsersError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is GetAllUsersSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputField(
                    controller: searchController,
                    labelText: 'Search by name, phone, or email',
                    hintText: 'Search by name, phone, or email',
                    prefixIcon: Icon(Icons.search),
                    onChanged: (query) => _filterUsers(query, state),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredUsers.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var item = filteredUsers[index];
                        return ListTile(
                          onTap: () {
                            Get.to(UsersProfile(
                              user: item,
                            ));
                          },
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
                                    Get.to(FullScreenImagePage(
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
                          title: Text(
                            "${item.name}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.email}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w200,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              Text(
                                '${item.batch}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                '${item.designation}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Something Wrong!"),
            );
          }
        },
      ),
    );
  }

  void bottomSheet() {
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
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
                      const Text('All'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Batch wise',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            btn1 = false;
                            btn2 = true;
                          });
                        },
                      ),
                      const Text('Batch wise'),
                    ],
                  ),

                  if (selectedOption == "Batch wise")
                    DropDownField(
                      hintText: 'Select Batch',
                      items: const ['Batch 1', 'Batch 2', 'Batch 3'],
                      value: selectedBatch,
                      onChanged: (value) {
                        // Handle the selected batch
                        setState(() {
                          selectedBatch = value ?? "";
                        });
                      },
                    ),

                  const SizedBox(
                    height: 10,
                  ),
                  BigButton(
                    title: "Apply Filter",
                    onPressed: () {
                      if (selectedOption == "Batch wise") {
                        BlocProvider.of<AdminBloc>(context)
                            .add(GetAllUsers(filter: selectedBatch));
                      } else {
                        BlocProvider.of<AdminBloc>(context)
                            .add(GetAllUsers(filter: "All"));
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

  void _filterUsers(String query, GetAllUsersSuccess state) {
    // Function to filter users based on the search query
    List<AdminUsersModel> filteredList = [];
    for (var user in state.users) {
      // Check if the user matches the search query (you can customize the conditions)
      if (user.name!.toLowerCase().contains(query.toLowerCase()) ||
          user.email!.toLowerCase().contains(query.toLowerCase()) ||
          user.designation!.toLowerCase().contains(query.toLowerCase()) ||
          user.phoneNumber!.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(user);
      }
    }

    setState(() {
      filteredUsers = filteredList; // Update the filtered users list
    });
  }
}
