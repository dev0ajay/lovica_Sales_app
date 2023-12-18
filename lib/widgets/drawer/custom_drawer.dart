// import 'dart:async';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:lovica_sales_app/common/constants.dart';
//
// import 'inner_drawer.dart';
//
// class CustomDrawer extends StatefulWidget {
//   final Widget? scaffold;
//   final GlobalKey<InnerDrawerState>? innerDrawerKey;
//
//   CustomDrawer({
//     Key? key,
//     this.scaffold,
//     this.innerDrawerKey,
//   }) : super(key: key);
//
//   @override
//   _CustomDrawerState createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   MainPageIcons assets = MainPageIcons(); //From my actual code dont care it
//   final vars = KeyValues().innerKeys; //From my actual code dont care it
//
//   @override
//   Widget build(BuildContext context) {
//     return InnerDrawer(
//         key: widget.innerDrawerKey,
//         onTapClose: true,
//         tapScaffoldEnabled: true,
//         swipe: true,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.teal,
//             blurRadius: 20.0,
//             // has the effect of softening the shadow
//             spreadRadius: 10.0,
//             // has the effect of extending the shadow
//             offset: Offset(
//               10.0, // horizontal, move right 10
//               10.0, // vertical, move down 10
//             ),
//           )
//         ],
//         borderRadius: 20,
//         // default 0
//         leftAnimationType: InnerDrawerAnimation.quadratic,
//         // default static
//         //when a pointer that is in contact with the screen and moves to the right or left
//         onDragUpdate: (double val, InnerDrawerDirection? direction) =>
//             setState(() => _dragUpdate = val),
//         //innerDrawerCallback: (a) => print(a),
//
//         // innerDrawerCallback: (a) => print(a), // return  true (open) or false (close)
//         leftChild: menus(),
//         // required if rightChild is not set
//
//         scaffold: widget.scaffold ?? SizedBox());
//   }
//
//   double _dragUpdate = 0;
//
//   Widget menus() {
//     return Material(
//         child: Stack(
//       children: <Widget>[
//         Container(
//           decoration: const BoxDecoration(
//             color: Colors.yellow,
//           ),
//           child: Stack(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(left: 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.only(left: 10, bottom: 15),
//                           width: 80,
//                           child: ClipRRect(
//                             child: Image.network(
//                               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrWfWLnxIT5TnuE-JViLzLuro9IID2d7QEc2sRPTRoGWpgJV75",
//                             ),
//                             borderRadius: BorderRadius.circular(60),
//                           ),
//                         ),
//                         Text(
//                           "User",
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         )
//                       ],
//                       //mainAxisAlignment: MainAxisAlignment.center,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(10),
//                     ),
//                     ListTile(
//                       onTap: () => navigate(Profile.tag),
//                       title: Text(
//                         "Profile",
//                         style: TextStyle(color: Colors.white, fontSize: 14),
//                       ),
//                       leading: Icon(
//                         Icons.dashboard,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                     ),
//                     ListTile(
//                         title: Text(
//                           "Camera",
//                           style: TextStyle(fontSize: 14, color: Colors.white),
//                         ),
//                         leading: Icon(
//                           Icons.camera,
//                           size: 22,
//                           color: Colors.white,
//                         ),
//                         onTap: () => navigate(Camera.tag)),
//                     ListTile(
//                         title: Text(
//                           "Pharmacies",
//                           style: TextStyle(fontSize: 14, color: Colors.white),
//                         ),
//                         leading: Icon(
//                           Icons.add_to_photos,
//                           size: 22,
//                           color: Colors.white,
//                         ),
//                         onTap: () => navigate(Pharmacies.tag)),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 20,
//                 child: Container(
//                   alignment: Alignment.bottomLeft,
//                   margin: EdgeInsets.only(top: 50),
//                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//                   width: double.maxFinite,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Icon(
//                         Icons.all_out,
//                         size: 18,
//                         color: Colors.grey,
//                       ),
//                       Text(
//                         " LogOut",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         _dragUpdate < 1
//             ? BackdropFilter(
//                 filter: ImageFilter.blur(
//                     sigmaX: (10 - _dragUpdate * 10),
//                     sigmaY: (10 - _dragUpdate * 10)),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0),
//                   ),
//                 ),
//               )
//             : const SizedBox(),
//       ].where((a) => a != null).toList(),
//     ));
//   }
//
//   navigate(String route) async {
//     await navigatorKey.currentState.pushNamed(route).then((_) {
//       Timer(Duration(milliseconds: 500),
//           () => widget.innerDrawerKey?.currentState!.toggle());
//     });
//   }
// }
