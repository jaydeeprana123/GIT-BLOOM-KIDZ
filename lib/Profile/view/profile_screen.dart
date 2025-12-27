import 'package:bloom_kidz/Authentication/controller/login_controller.dart';
import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Profile/controller/profile_controller.dart';
import 'package:bloom_kidz/Profile/view/change_pin_dialog.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Chat/View/chat_screen.dart';
import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/black_large_regular_text.dart';
import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_medium_bold_text.dart';
import '../../CommonWidgets/common_appbar.dart';
import 'change_password_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();

    profileController.callGetProfileAPI(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(title: "Profile", showMenu: true),
      body: SafeArea(
        child: Obx(
                () =>Stack(
                  children: [
                    SingleChildScrollView(
                                        child: Card(
                                          color: Colors.white,
                                          shadowColor: color_secondary,
                                          elevation: 6,
                                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ), // change 16 to any radius you like
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                /// 👤 Profile Image
                                                const CircleAvatar(
                                                  radius: 45,
                                                  backgroundImage: NetworkImage(
                                                    "https://randomuser.me/api/portraits/women/44.jpg",
                                                  ),
                                                ),
                                            
                                                const SizedBox(height: 20),
                                            
                                                /// Name
                                                _infoRow(
                                                  icon: Icons.person,
                                                  label: "Name",
                                                  value: profileController.profileUser.value.name??"",
                                                ),
                                            
                                                const Divider(),
                                            
                                                /// Contact No
                                                _infoRow(
                                                  icon: Icons.phone,
                                                  label: "Contact No.",
                                                  value: profileController.profileUser.value.phone??"",
                                                ),
                                            
                                                const Divider(),
                                            
                                                /// Email
                                                _infoRow(
                                                  icon: Icons.email,
                                                  label: "Email Address",
                                                  value: profileController.profileUser.value.email??"",
                                                ),
                                            
                                                const SizedBox(height: 20),
                                            
                                                /// 🔘 Buttons
                                                Row(
                                                  children: [
                                                    Expanded(
                                                              child: ElevatedButton(
                                            
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.red,
                                                                  padding: EdgeInsets.zero,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  showChangePasswordDialog(context, profileController);
                                                                },
                                                                child:  BlackSmallMediumText("Change Password", color: Colors.white, fontSize: 11),
                                                              ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  padding: EdgeInsets.zero,
                                                                  backgroundColor: color_secondary,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  showChangePinDialog(context, profileController);
                                                                },
                                                                child:  BlackSmallMediumText("Set Up Quick Access Pin", color: Colors.white, textAlign: TextAlign.center, fontSize: 11),
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                    ),

                    if(profileController.isLoading.value)Center(child: CircularProgressIndicator(),)
                  ],
                )),
      ),
    );
  }

  /// ℹ️ Info Row Widget
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color_secondary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔵 Blue Label Text
            BlueMediumBoldText(
              label,
              fontSize: 12,
            ),
            const SizedBox(height: 4),

            /// ⚫ Black Value Text
            BlackLargeRegularText(
              value,
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }


  void showChangePasswordDialog(BuildContext context, ProfileController profileController) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return  ChangePasswordDialog(controller : profileController);
      },
    );
  }

  void showChangePinDialog(BuildContext context, ProfileController profileController) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return  ChangePinDialog(controller : profileController);
      },
    );
  }

}

