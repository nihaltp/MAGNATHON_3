import 'package:flutter/material.dart';
import 'package:magnathon/screens/payment.dart';
import 'package:sizer/sizer.dart';

class RedemptionScreen extends StatefulWidget {
  final String userName;
  final int userPoints;
  final String userID;

  const RedemptionScreen({super.key, required this.userName, required this.userPoints, required this.userID});

  @override
  State<RedemptionScreen> createState() => _RedemptionScreenState();
}

class _RedemptionScreenState extends State<RedemptionScreen> {
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _pointsToRedeemController = TextEditingController();
  double _discount = 0;
  double pointsUsed = 0;
  double _finalAmount = 0;

  // Example: 10 points = 1 Rupee
  final double pointValue = 0.1;

  void _calculateTotal(String value) {
    if (value.isEmpty) return;
    double bill = double.tryParse(value) ?? 0;
    
    setState(() {
      // Calculate how much discount the points can give
      _discount = pointsUsed * pointValue;
      
      // Ensure discount doesn't exceed the bill
      if (_discount > bill) _discount = bill;
      
      _finalAmount = bill - _discount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Redeem Points"), elevation: 0),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserSummary(),
            SizedBox(height: 4.h),
            Text("Enter Bill Amount", style: TextStyle(fontSize: 15.sp, color: Colors.grey)),
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(prefixText: "₹ ", border: InputBorder.none),
              onChanged: _calculateTotal,
            ),
            const Divider(),
            SizedBox(height: 2.h,),
            Text("Enter Points", style: TextStyle(fontSize: 15.sp, color: Colors.grey)),
            TextField(
              controller: _pointsToRedeemController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: InputBorder.none, hintText: "0"),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int points = int.tryParse(value) ?? 0;
                  if (points > widget.userPoints) {
                    _pointsToRedeemController.text = widget.userPoints.toString();
                  }
                  pointsUsed = points.toDouble();
                }
                _calculateTotal(_billController.text);
              },
            ),
            const Divider(),
            SizedBox(height: 2.h),
            _buildCalculationRow("Available Points", "${widget.userPoints}"),
            _buildCalculationRow("Points Discount", "- ₹${_discount.toStringAsFixed(2)}", isDiscount: true),
            const Divider(),
            _buildCalculationRow("Total Payable", "₹${_finalAmount.toStringAsFixed(2)}", isTotal: true),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _finalAmount > 0 ? () => _navigateToPayment() : null,
                child: Text("Generate Payment QR", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserSummary() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.indigo, child: Text(widget.userName[0], style: const TextStyle(color: Colors.white))),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              Text("${widget.userPoints} Points", style: TextStyle(color: Colors.indigo, fontSize: 14.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(String label, String val, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(val, style: TextStyle(fontSize: isTotal ? 16.sp : 14.sp, fontWeight: FontWeight.bold, color: isDiscount ? Colors.green : Colors.black)),
        ],
      ),
    );
  }

  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentQRScreen(amount: _finalAmount, userName: widget.userName, userID: widget.userID, points: _pointsToRedeemController.text.isEmpty ? 0 : int.parse(_pointsToRedeemController.text)),
      ),
    );
  }
}