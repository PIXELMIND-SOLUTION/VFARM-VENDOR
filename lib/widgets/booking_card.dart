// import 'package:flutter/material.dart';
// import 'package:vendor_app/models/booking_model.dart';
// import '../constants/app_colors.dart';
// import '../utils/responsive_helper.dart';
// import '../utils/date_formatter.dart';

// class BookingCard extends StatelessWidget {
//   final BookingModel booking;

//   const BookingCard({super.key, required this.booking});

//   @override
//   Widget build(BuildContext context) {
//     ResponsiveHelper.init(context);

//     return Container(
//       margin: EdgeInsets.only(bottom: ResponsiveHelper.h(2)),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             // Navigate to booking details
//           },
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: EdgeInsets.all(ResponsiveHelper.w(3)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             booking.user?.name ?? 'Guest User',
//                             style: TextStyle(
//                               fontSize: ResponsiveHelper.sp(4),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: ResponsiveHelper.h(0.5)),
//                           Text(
//                             booking.bookingDetails?.label ?? 'Slot',
//                             style: TextStyle(
//                               fontSize: ResponsiveHelper.sp(3.2),
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: ResponsiveHelper.w(2),
//                         vertical: ResponsiveHelper.h(0.5),
//                       ),
//                       decoration: BoxDecoration(
//                         color: booking.statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         booking.statusText,
//                         style: TextStyle(
//                           fontSize: ResponsiveHelper.sp(2.8),
//                           color: booking.statusColor,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: ResponsiveHelper.h(2)),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.calendar_today,
//                       size: ResponsiveHelper.sp(4),
//                       color: AppColors.grey,
//                     ),
//                     SizedBox(width: ResponsiveHelper.w(2)),
//                     Text(
//                       DateFormatter.formatDate(
//                           booking.bookingDetails?.date ?? DateTime.now()),
//                       style: TextStyle(
//                         fontSize: ResponsiveHelper.sp(3.2),
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     SizedBox(width: ResponsiveHelper.w(4)),
//                     Icon(
//                       Icons.access_time,
//                       size: ResponsiveHelper.sp(4),
//                       color: AppColors.grey,
//                     ),
//                     SizedBox(width: ResponsiveHelper.w(2)),
//                     Text(
//                       booking.bookingDetails?.timing ?? '',
//                       style: TextStyle(
//                         fontSize: ResponsiveHelper.sp(3.2),
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: ResponsiveHelper.h(1.5)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Amount',
//                           style: TextStyle(
//                             fontSize: ResponsiveHelper.sp(3),
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         Text(
//                           '₹${booking.totalAmount.toStringAsFixed(0)}',
//                           style: TextStyle(
//                             fontSize: ResponsiveHelper.sp(4.5),
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Container(
//                     //   padding: EdgeInsets.symmetric(
//                     //     horizontal: ResponsiveHelper.w(2),
//                     //     vertical: ResponsiveHelper.h(0.5),
//                     //   ),
//                     //   decoration: BoxDecoration(
//                     //     color: booking.isPaymentCompleted
//                     //         ? AppColors.success.withOpacity(0.1)
//                     //         : AppColors.warning.withOpacity(0.1),
//                     //     borderRadius: BorderRadius.circular(20),
//                     //   ),
//                     //   child: Text(
//                     //     booking.isPaymentCompleted ? 'Paid' : 'Pending',
//                     //     style: TextStyle(
//                     //       fontSize: ResponsiveHelper.sp(2.8),
//                     //       color: booking.isPaymentCompleted
//                     //           ? AppColors.success
//                     //           : AppColors.warning,
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:vendor_app/models/booking_model.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../utils/date_formatter.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 USER + STATUS
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.user?.name ?? 'Guest User',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.h(0.5)),
                          Text(
                            booking.bookingDetails?.label ?? 'Slot',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(3.2),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(2),
                        vertical: ResponsiveHelper.h(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: booking.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.statusText,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(2.8),
                          color: booking.statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(2)),

                // 🔹 DATE + TIME
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: ResponsiveHelper.sp(4),
                      color: AppColors.grey,
                    ),
                    SizedBox(width: ResponsiveHelper.w(2)),
                    Text(
                      DateFormatter.formatDate(
                          booking.bookingDetails?.date ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.2),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(4)),
                    Icon(
                      Icons.access_time,
                      size: ResponsiveHelper.sp(4),
                      color: AppColors.grey,
                    ),
                    SizedBox(width: ResponsiveHelper.w(2)),
                    Text(
                      booking.bookingDetails?.timing ?? '',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(3.2),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(1.5)),

                // 🔥 PAYMENT BREAKDOWN UI
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(3)),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _amountRow(
                        'Total Amount',
                        booking.totalAmount,
                        isBold: true,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: ResponsiveHelper.h(0.8)),

                      _amountRow(
                        'Advance Paid',
                        booking.advancePayment,
                        color: Colors.green,
                      ),
                      SizedBox(height: ResponsiveHelper.h(0.8)),

                      _amountRow(
                        'Remaining',
                        booking.remainingAmount,
                        color: booking.remainingAmount > 0
                            ? Colors.red
                            : Colors.green,
                      ),

                      SizedBox(height: ResponsiveHelper.h(1)),

                      // 🔥 PAYMENT STATUS
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(2),
                            vertical: ResponsiveHelper.h(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: booking.paymentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking.paymentText,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(2.8),
                              color: booking.paymentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Helper
  Widget _amountRow(String title, double value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(3),
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '₹${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(isBold ? 4 : 3.5),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
