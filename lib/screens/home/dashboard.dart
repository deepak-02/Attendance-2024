import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../blocs/attendanceBloc/attendance_bloc.dart';
import 'Attendance/attendance.dart';
import 'home/home.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    attendanceBloc = BlocProvider.of<AttendanceBloc>(context);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(context),
      confineInSafeArea: true,
      onItemSelected: (item){
        print(item);
      },
      // backgroundColor: const Color(0xffffffff),
      // backgroundColor: Color(0xffc993c7), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      // decoration: NavBarDecoration(
      //   borderRadius: BorderRadius.circular(20.0),
      //   colorBehindNavBar: Colors.white,
      // ),
      padding: const NavBarPadding.all(5),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      navBarHeight: 56,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style9, // Choose the nav bar style with this property.
    );
  }
}

PersistentTabController _controller = PersistentTabController(initialIndex: 0);
 var  attendanceBloc;
List<Widget> _buildScreens() {
  return [
    const MyHomePage(),
    const Attendance(),
    // const Profile(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      iconSize: 24,
      textStyle: const TextStyle(fontSize: 12, fontFamily: "Metropolis"),
      title: ("Home"),
      activeColorPrimary: Theme.of(context).colorScheme.primary,
      inactiveColorPrimary: Theme.of(context).colorScheme.inversePrimary,
      // activeColorPrimary: const Color(0xff92278f),
      // inactiveColorPrimary: const Color(0xffd3a9d2),
    ),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.history),
        iconSize: 24,
        textStyle: const TextStyle(fontSize: 12, fontFamily: "Metropolis"),
        title: ("Attendance"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.inversePrimary,
        onPressed: (context) {
          _controller.jumpToTab(1);
          // BlocProvider.of<AttendanceBloc>(context!).add(GetCurrentAttendance());
          attendanceBloc.add(GetCurrentAttendance());

          // Get.to(Attendance());
        }),
    // PersistentBottomNavBarItem(
    //   icon: const Icon(Icons.person),
    //   iconSize: 24,
    //   textStyle: const TextStyle(fontSize: 12, fontFamily: "Metropolis"),
    //   title: ("Profile"),
    //   activeColorPrimary: Theme.of(context).colorScheme.primary,
    //   inactiveColorPrimary: Theme.of(context).colorScheme.inversePrimary,
    // ),
  ];
}
