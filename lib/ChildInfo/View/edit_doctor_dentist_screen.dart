import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:bloom_kidz/CommonWidgets/common_appbar.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import '../controller/child_info_controller.dart';

class EditDoctorDentistScreen extends StatefulWidget {
  final String childId;

  const EditDoctorDentistScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<EditDoctorDentistScreen> createState() => _EditDoctorDentistScreenState();
}

class _EditDoctorDentistScreenState extends State<EditDoctorDentistScreen> {
  final ChildInfoController controller = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();
    final health = controller.aboutChildren.value.healthInfo;
    
    // Prefill Doctor
    controller.docNameController.value.text = health?.doctor?.name ?? "";
    controller.docMobileController.value.text = health?.doctor?.mobile ?? "";
    controller.docStreetController.value.text = health?.doctor?.street ?? "";
    controller.docCityController.value.text = health?.doctor?.city ?? "";
    controller.docCountryController.value.text = health?.doctor?.country ?? "";
    controller.docPostcodeController.value.text = health?.doctor?.postcode ?? "";

    // Prefill Dentist
    controller.dentistNameController.value.text = health?.dentist?.name ?? "";
    controller.dentistMobileController.value.text = health?.dentist?.mobile ?? "";
    controller.dentistStreetController.value.text = health?.dentist?.street ?? "";
    controller.dentistCityController.value.text = health?.dentist?.city ?? "";
    controller.dentistCountryController.value.text = health?.dentist?.country ?? "";
    controller.dentistPostcodeController.value.text = health?.dentist?.postcode ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "Edit Doctor & Dentist",
        showBack: true,
        showMenu: false,
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Card(
              color: Colors.white,
              shadowColor: color_secondary,
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- DOCTOR SECTION ---
                    _sectionHeader("Doctor Information"),
                    const SizedBox(height: 12),
                    _buildField("Doctor Name", controller.docNameController.value),
                    _buildField("Doctor Mobile", controller.docMobileController.value),
                    _buildField("Street", controller.docStreetController.value),
                    _buildField("City", controller.docCityController.value),
                    _buildField("Country", controller.docCountryController.value),
                    _buildField("Postcode", controller.docPostcodeController.value),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),

                    // --- DENTIST SECTION ---
                    _sectionHeader("Dentist Information"),
                    const SizedBox(height: 12),
                    _buildField("Dentist Name", controller.dentistNameController.value),
                    _buildField("Dentist Mobile", controller.dentistMobileController.value),
                    _buildField("Street", controller.dentistStreetController.value),
                    _buildField("City", controller.dentistCityController.value),
                    _buildField("Country", controller.dentistCountryController.value),
                    _buildField("Postcode", controller.dentistPostcodeController.value),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: CommonGradientButton(
                        btnTitle: "UPDATE",
                        onPressed: () {
                          final Map<String, dynamic> body = {
                            "doc_name": controller.docNameController.value.text.trim(),
                            "doc_mobile": controller.docMobileController.value.text.trim(),
                            "doc_street": controller.docStreetController.value.text.trim(),
                            "doc_city": controller.docCityController.value.text.trim(),
                            "doc_country": controller.docCountryController.value.text.trim(),
                            "doc_postcode": controller.docPostcodeController.value.text.trim(),
                            "dentist_name": controller.dentistNameController.value.text.trim(),
                            "dentist_mobile": controller.dentistMobileController.value.text.trim(),
                            "dentist_street": controller.dentistStreetController.value.text.trim(),
                            "dentist_city": controller.dentistCityController.value.text.trim(),
                            "dentist_country": controller.dentistCountryController.value.text.trim(),
                            "dentist_postcode": controller.dentistPostcodeController.value.text.trim(),
                          };
                          controller.callUpdateDoctorDentistAPI(
                            context: context,
                            childId: widget.childId,
                            body: body,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueMediumBoldText(label, fontSize: 12),
          const SizedBox(height: 4),
          CommonTextField(hint: "", controller: controller),
        ],
      ),
    );
  }
}
