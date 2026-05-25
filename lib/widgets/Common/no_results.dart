import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';

class NoResults extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const NoResults({
    Key? key,
    this.title = 'No Results Found',
    this.message = 'We couldn\'t find what you\'re looking for. Try adjusting your search or filters.',
    this.onRetry,
    this.retryButtonText = 'Try Again',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              // width: 200,
              // height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomPaint(
                painter: NoResultsPainter(),
              ),
            ),
            const SizedBox(height: 70),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            message != ''?  SizedBox(height: 12): SizedBox(),
            
            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            
            // Retry button (optional)
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SAGR_PRIMARY,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  retryButtonText!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NoResultsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Calendar body
    final calendarPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final calendarBorderPaint = Paint()
      ..color = const Color(0xFFCBD5E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final calendarRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: 100,
        height: 110,
      ),
      const Radius.circular(12),
    );

    canvas.drawRRect(calendarRect, calendarPaint);
    canvas.drawRRect(calendarRect, calendarBorderPaint);

    // Calendar header
    final headerPaint = Paint()
      ..color =  SAGR_PRIMARY
      ..style = PaintingStyle.fill;

    final headerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(centerX - 50, centerY - 55, 100, 30),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
    );

    canvas.drawRRect(headerRect, headerPaint);

    // Calendar rings
    final ringPaint = Paint()
      ..color = const Color(0xFFA0AEC0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX - 30, centerY - 60), 5, ringPaint);
    canvas.drawCircle(Offset(centerX + 30, centerY - 60), 5, ringPaint);

    // Calendar grid dots (representing dates)
    final dotPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(
            centerX - 30 + (col * 20),
            centerY - 15 + (row * 20),
          ),
          3,
          dotPaint,
        );
      }
    }

    // Draw big "X" over calendar
    // final xPaint = Paint()
    //   ..color = const Color(0xFFFC8181)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 6
    //   ..strokeCap = StrokeCap.round;

    // canvas.drawLine(
    //   Offset(centerX - 40, centerY - 40),
    //   Offset(centerX + 40, centerY + 40),
    //   xPaint,
    // );

    // canvas.drawLine(
    //   Offset(centerX + 40, centerY - 40),
    //   Offset(centerX - 40, centerY + 40),
    //   xPaint,
    // );

    // Decorative dots around calendar
    final decorDotPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX - 70, centerY - 50), 4, decorDotPaint);
    canvas.drawCircle(Offset(centerX + 70, centerY - 60), 5, decorDotPaint);
    canvas.drawCircle(Offset(centerX - 60, centerY + 60), 3, decorDotPaint);
    canvas.drawCircle(Offset(centerX + 65, centerY + 55), 4, decorDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// class NoResultsPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final centerX = size.width / 2;
//     final centerY = size.height / 2;

//     // Draw magnifying glass handle
//     final handlePaint = Paint()
//       ..color = const Color(0xFFA0AEC0)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8
//       ..strokeCap = StrokeCap.round;

//     canvas.drawLine(
//       Offset(centerX + 35, centerY + 35),
//       Offset(centerX + 55, centerY + 55),
//       handlePaint,
//     );

//     // Draw magnifying glass circle
//     final circlePaint = Paint()
//       ..color = const Color(0xFFCBD5E0)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8;

//     canvas.drawCircle(
//       Offset(centerX, centerY - 5),
//       40,
//       circlePaint,
//     );

//     // Draw "X" inside the magnifying glass
//     final xPaint = Paint()
//       ..color = const Color(0xFFFC8181)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 6
//       ..strokeCap = StrokeCap.round;

//     canvas.drawLine(
//       Offset(centerX - 15, centerY - 20),
//       Offset(centerX + 15, centerY + 10),
//       xPaint,
//     );

//     canvas.drawLine(
//       Offset(centerX + 15, centerY - 20),
//       Offset(centerX - 15, centerY + 10),
//       xPaint,
//     );

//     // Draw decorative dots
//     final dotPaint = Paint()
//       ..color = const Color(0xFFE2E8F0)
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(Offset(centerX - 70, centerY - 50), 4, dotPaint);
//     canvas.drawCircle(Offset(centerX + 70, centerY - 60), 5, dotPaint);
//     canvas.drawCircle(Offset(centerX - 60, centerY + 50), 3, dotPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }


