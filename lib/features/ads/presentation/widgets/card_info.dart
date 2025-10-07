import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/home/presentation/screens/home_screen.dart';

class InfoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String address;
  final String status;
  final String date;
  final String eventStatus;

  const InfoCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.address,
    required this.status,
    required this.date,
    required this.eventStatus
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: Card(
        color: WHITE_COLOR,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                        "assets/images/sagr-logo.png",
                        fit: BoxFit.contain,
                 
                      ),
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            //   child: Image.network(
            //     imageUrl,
            //     height: 150,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      AppliedWidgetStatusAndApplyButton(status: status),
                      
                      _buildStatusBadge(eventStatus),
                      Text(
                        date,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildStatusBadge(String status) {
  Color statusColor;
  String displayText;
  
  switch (status) {
    case "EventStatus.upcoming":
      statusColor = Colors.blue;
      displayText = "Upcoming";
      break;
    case "EventStatus.active":
      statusColor = Colors.green;
      displayText = "Active";
      break;
    case "EventStatus.finished":
      statusColor = Colors.orange;
      displayText = "Finished";
      break;
    default:
      statusColor = Colors.grey;
      displayText = "Unknown";
  }
  
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      displayText.tr,
      style: TextStyle(
        color: statusColor, 
        fontWeight: FontWeight.bold
      ),
    ),
  );
}
}
