import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';

class ShowAllWidget extends StatelessWidget {
  final String title;
  final VoidCallback onpress;

  const ShowAllWidget({
    Key? key, required this.title, required this.onpress, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: BLACK_COLOR
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onpress,
                child: Text(
                "عرض الكل",
                style: TextStyle(
                  fontSize: 10,
                 
                ),
              ),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 10,
                color: AMBER_COLOR,
              ),
            ],
          ),
        ],
      ),
    );
  }
}