import 'package:flutter/material.dart';

import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/appbar/unauthenticated_appbar.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController resetPasswordEditTextController =
      TextEditingController();

  TextEditingController passwordEditText1Controller = TextEditingController();

  TextEditingController passwordEditText2Controller = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
                appBar: PreferredSize(
        preferredSize: Size.fromHeight(77), child: UnAuthenticatedAppBar()),
      body: SizedBox(
        width: SizeUtils.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: 398.h,
              margin: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 5.v),
              padding: EdgeInsets.symmetric(
                horizontal: 12.h,
                vertical: 11.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reset password",
                    style: CustomTextStyles.titleLargePoppins,
                  ),
                  SizedBox(height: 4.v),
                  Text(
                    "Please kindly set your new password",
                    style: CustomTextStyles.bodyMediumGray50001,
                  ),
                  SizedBox(height: 23.v),
                  // _buildResetPasswordEditText(context),
                  // SizedBox(height: 12.v),
                  // _buildPasswordEditText1(context),
                  // SizedBox(height: 12.v),
                  // _buildPasswordEditText2(context),
                  // SizedBox(height: 24.v),
                  // _buildResetPasswordButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
