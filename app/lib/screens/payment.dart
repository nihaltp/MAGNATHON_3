import 'package:flutter/material.dart';
import 'package:magnathon/database/admin_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class PaymentQRScreen extends StatefulWidget {
  const PaymentQRScreen({super.key, required this.amount, required this.userName, required this.userID, required this.points});

  final double amount;
  final String userName;
  final String userID;
  final int points;
  @override
  State<PaymentQRScreen> createState() => _PaymentQRScreenState();
}

class _PaymentQRScreenState extends State<PaymentQRScreen> {

  Future<void> _confirmPayment() async {
    await DatabaseMethods().redeemPoints(widget.userID, widget.points);
    if(mounted) Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: Container(
          width: 85.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("PAYMENT DUE", style: TextStyle(color: Colors.grey, fontSize: 17.sp, letterSpacing: 2)),
              SizedBox(height: 1.h),
              Text("₹${widget.amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 2.h),
              
              QrImageView(
                data: "upi://pay?pa=nihaltpnki@okhdfcbank&pn=NIHAL%20T%20P&aid=uGICAgMCniZ_ETA&am=${widget.amount}&cu=INR",
                version: QrVersions.auto,
                size: 60.w,
              ),
              
              SizedBox(height: 2.h),
              Text("Scan to Pay for ${widget.userName}", textAlign: TextAlign.center, style: TextStyle(fontSize: 15.sp, color: Colors.black54)),
              SizedBox(height: 3.h),
              
              OutlinedButton(
                onPressed: _confirmPayment,
                child: const Text("Confirm Payment Received"),
              )
            ],
          ),
        ),
      ),
    );
  }
}