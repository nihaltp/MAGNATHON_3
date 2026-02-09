import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:magnathon/database/admin_database.dart';
import 'package:magnathon/screens/qrscanner.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  Future<void> getActiveCoasters() async {
    List<String> activeCoasters = await DatabaseMethods().getActiveCoasters(Provider.of<StateManagement>(context, listen: false).docID);

    if(mounted) {
      log("$activeCoasters");
      Provider.of<StateManagement>(context, listen: false).setActiveCoasters(activeCoasters, activeCoasters.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 4.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(
                        fontSize: 20.sp
                      ),
                    ),
                    Text(
                      Provider.of<StateManagement>(context).username,
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: const Color(0xFF1A237E),
                        fontWeight: FontWeight.bold
                      ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannerScreen()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                  width: 89.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF1A237E), const Color(0xFF3F51B5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A237E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    spacing: 4.5.w,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 26.sp,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Scan QR Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active Coasters",
                    style: TextStyle(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      getActiveCoasters();
                    },
                    icon: Icon(Icons.refresh, color: const Color(0xFF1A237E)),
                    color: const Color(0xFF1A237E),
                  )
                ],
              ),
              SizedBox(height: 2.h,),
              Consumer<StateManagement>(
                builder: (context, value, child) {
                  
                  return CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 25.h,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.75,
                    ),
                    itemCount: value.activeCoasters == 0 ? 1 : value.activeCoasters,
                    itemBuilder: (context, index, realIndex) {
                      log("${value.activeCoasters}");
                      if(value.activeCoasters == 0) {
                        return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.black.withOpacity(0.05)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sensors_off,
                            color: Colors.red,
                            size: 32.sp,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "No Active\nCoasters",
                            style: TextStyle(
                              color: const Color(0xFF1A237E),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                      }else{
                      return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.black.withOpacity(0.05)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sensors_rounded,
                            color: const Color(0xFF3F51B5),
                            size: 32.sp,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Coaster ${index + 1}",
                            style: TextStyle(
                              color: const Color(0xFF1A237E),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                      }
                    }
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}