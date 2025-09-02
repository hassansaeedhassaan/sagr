import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/profile/profile_controller.dart';
import 'package:sagr/view/widgets/Forms/easy_app_password_form_field.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/appbar/basic_app_bar.dart';

import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class ContactUsTwoScreen extends StatelessWidget {
  ContactUsTwoScreen({Key? key})
      : super(
          key: key,
        );

  final TextEditingController passwordEditTextController =
      TextEditingController();

  final TextEditingController newPasswordEditTextController =
      TextEditingController();

  final TextEditingController newPasswordEditTextController1 =
      TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(66),
            child: BasicAppBar(title: "Change Password")),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(height: 16.v),
                    _buildFrame(context),
                    // Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return GetBuilder(builder: (ProfileController _controller) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        padding: EdgeInsets.all(12.h),
        decoration: AppDecoration.fillOnPrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


          EasyAppPasswordFormField(
            
            hintText: "Old Password",
            labelText: "Old Password",
            onSave: (val) =>  _controller.old_password = val,
            onValidate: (val) {
              if (val!.length == 0){
                return  "Requqired";
              }else{
                return null;
              }
            }  ,
          ),
          
            SizedBox(height: 12.v),
            EasyAppPasswordFormField(
            hintText: "New Password",
            labelText: "New Password",
            onSave: (val) =>  _controller.new_password = val,
            onValidate: (val) {
              if (val!.length == 0){
                return  "Requqired";
             }else{
                return null;
              }
            }  ,
          ),
            SizedBox(height: 12.v),
            EasyAppPasswordFormField(
            hintText: "New Password Confirmation",
            labelText: "New Password Confirmation" ,
            onSave: (val) =>  _controller.new_password_confirmation = val,
            onValidate: (val) {
              if (val!.length == 0){
                return  "Requqired";
              }else{
                return null;
              }
         
            }  ,
          ),
            SizedBox(height: 24.v),
            CustomElevatedButton(
              onPressed: () {
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  _controller.changePassword(context);
                }
              },
              text: "Update ",
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
            )
          ],
        ),
      );
    });
  }

 
}
