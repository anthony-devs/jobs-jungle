import 'package:flutter/material.dart';

//By Anthony Devs

//This is a Conditional Rendering Widget, that renders any 3 Widgets depending on the Device's width
//This Script makes Responsive Designs Easier to Implement
//To use this script you have to: Import It in the Page you want to Implement it on and make sure you have 3 widgets, for Mobile, Desktop and Tablet
//Then, you call it Like This: RespnsiveDesign(DesktopView: DesktopView(), TabletView: TabletView(), MobileView: MobileView)
class ResponsiveDesign extends StatelessWidget {
  //Declaration of The Variables
  Widget DesktopView;
  Widget TabletView;
  Widget MobileView;
  ResponsiveDesign(
      {super.key,
      required this.DesktopView,
      required this.MobileView,
      required this.TabletView});

  @override
  Widget build(BuildContext context) {
    //To Get The Windows Width
    double Width = MediaQuery.of(context).size.width;

    //Mobile
    if (Width < 480) {
      return MobileView;
    } 
    //Tablets
    else if (Width < 1024) {
      return TabletView;
    } 
    //PCs and Large Screens
    else {
      return DesktopView;
    }
  }
}
