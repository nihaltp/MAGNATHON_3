import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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
                      "Magnathon Cafe",
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              GestureDetector(
                onTap: () {
                  
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                  width: 89.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    spacing: 4.5.w,
                    children: [
                      Icon(
                        Icons.qr_code_scanner_outlined,
                        size: 28.sp,
                        color: Colors.white,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Active Coasters",
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 2.h,),
              CarouselSlider.builder(
                options: CarouselOptions(
                  enlargeCenterPage: true
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
                    height: 12.h,
                    width: 89.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.casino_outlined, 
                          color: Colors.white,
                          size: 35.sp,
                        ),
                        Text(
                          "Coaster ${itemIndex + 1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
          )
            ],
          ),
        ),
      ),
    );
  }
}