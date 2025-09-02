import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/chat/data/models/conversation_model.dart';

import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';

// ignore: must_be_immutable
class ChatItemWidget extends StatelessWidget {
  final ConversationModel conversation;
  const ChatItemWidget(this.conversation,{Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: () => Get.toNamed('/messages_list', arguments: conversation),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: AppDecoration.fillOnPrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    24.h,
                  ),
                  child: Image.network(conversation.sender_avatar!,  height: 48.adaptSize,
                  width: 48.adaptSize, fit: BoxFit.cover,),
                ),
             
                Padding(
                  padding: EdgeInsets.only(left: 11.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${conversation.sender_name}",
                        style: CustomTextStyles.titleMediumBluegray90001SemiBold,
                      ),
                      SizedBox(height: 4.v),
                     conversation.message == null ? SizedBox.shrink() :  FittedBox(
                      fit: BoxFit.fitWidth, 
                      child: Container(
                        width: MediaQuery.of(context).size.width - 180,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          "${conversation.message}",
                          style: CustomTextStyles.bodyMediumGray60001,
                        ),
                      ),),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.v),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 20.adaptSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Text(
                        
                        "${conversation.unread_count}",
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.labelLargeOnPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.v),
                  Text(
                    "${conversation.created_at}",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
