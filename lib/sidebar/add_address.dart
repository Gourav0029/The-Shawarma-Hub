import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/helper/address_db_helper.dart';

class AddDeliveryAddress extends StatefulWidget {
  const AddDeliveryAddress({super.key});

  @override
  State<AddDeliveryAddress> createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<AddDeliveryAddress> {
  final storage = GetStorage();

  int selectedContainerIndex = 0;
  int selectedAddressTypeIndex = 0;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  String addressTypeSave = 'Home';

  bool areAllFieldsFilled() {
    return fullNameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        pincodeController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        addressLine1Controller.text.isNotEmpty &&
        addressLine2Controller.text.isNotEmpty;
  }

  String combineAddressFields() {
    return
        // "${fullNameController.text}, " // Full Name
        //     "${mobileNumberController.text}, " // Mobile Number
        "${addressLine1Controller.text}, " // Address Line 1
            "${addressLine2Controller.text}, " // Address Line 2
            "${landmarkController.text.isNotEmpty ? "${landmarkController.text}, " : ""}" // Landmark (if provided)
            "${cityController.text}, " // City
            "${stateController.text}, " // State
            "Pin: ${pincodeController.text}"; // Pincode
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool allFieldsFilled = areAllFieldsFilled();
    return Scaffold(
      appBar: AppBar(
        elevation: 24,
        backgroundColor: const Color(0xFFF4F0F9),
        title: Text(
          'Add Delivery Address',
          style: GoogleFonts.outfit(
            fontSize: 20,
            color: const Color(0xFF201135),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputTextField(
                  label: 'Full Name*',
                  hintText: 'Full Name (required)',
                  keyboardType: TextInputType.text,
                  controller: fullNameController),
              const SizedBox(height: 12),
              InputTextField(
                  label: 'Mobile Number*',
                  hintText: 'Mobile Number (required)',
                  keyboardType: TextInputType.phone,
                  controller: mobileNumberController),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 42,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFEAE1F7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.my_location,
                        color: Color(0xFFE23744),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Use Current Location',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE23744),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InputTextField(
                label: 'Pin Code*',
                hintText: 'Pin Code (required)',
                keyboardType: TextInputType.number,
                controller: pincodeController,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputTextField(
                        label: 'State*',
                        hintText: 'State (required)',
                        keyboardType: TextInputType.text,
                        controller: stateController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputTextField(
                        label: 'City*',
                        hintText: 'City (required)',
                        keyboardType: TextInputType.text,
                        controller: cityController),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InputTextField(
                  label: 'Address Line 1*',
                  hintText: 'House No., Building Name (required)',
                  keyboardType: TextInputType.text,
                  controller: addressLine1Controller),
              const SizedBox(height: 12),
              InputTextField(
                  label: 'Address Line 2*',
                  hintText: 'Road, Area, Colony (required)',
                  keyboardType: TextInputType.text,
                  controller: addressLine2Controller),
              const SizedBox(height: 12),
              InputTextField(
                label: 'Landmark',
                hintText: 'Landmark (optional)',
                keyboardType: TextInputType.text,
                controller: landmarkController,
              ),
              const SizedBox(height: 16),
              Text(
                'Address Type*',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF201135),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  addressType(0, 'Home'),
                  const SizedBox(width: 8),
                  addressType(1, 'Work'),
                  const SizedBox(width: 8),
                  addressType(2, 'Others'),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: screenWidth,
        height: screenHeight * 0.22,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                if (allFieldsFilled) {
                  String userId = storage.read(
                      'userId'); // Replace with your method to fetch userId.

                  int id = await AddressDatabaseHelper().saveAddress(
                    userId: userId,
                    fullName: fullNameController.text,
                    mobileNumber: mobileNumberController.text,
                    addressLine1: addressLine1Controller.text,
                    addressLine2: addressLine2Controller.text,
                    landmark: landmarkController.text.isNotEmpty
                        ? landmarkController.text
                        : null,
                    city: cityController.text,
                    state: stateController.text,
                    pincode: pincodeController.text,
                    addressType: addressTypeSave,
                  );

                  if (id > 0) {
                    Get.snackbar('Success', 'Address saved successfully!');
                    Get.back(); // Navigate back after saving
                  } else {
                    Get.snackbar('Error', 'Failed to save address!');
                  }
                } else {
                  Get.snackbar('Error', 'Please fill all required fields.');
                }
              },
              child: Container(
                width: screenWidth,
                height: 50,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: allFieldsFilled
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFCB202D), Color(0xFFE23744)])
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFE0DCE5), Color(0xFFE0DCE5)],
                        ),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Handle onTap action
                cancelButtonDialog();
              },
              child: Container(
                width: screenWidth,
                height: 50,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFEAE1F7)),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: const Color(0xFFE23744),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressType(int index, String title) {
    bool isSelected = selectedAddressTypeIndex == index;

    Map<String, dynamic> iconPaths = {
      'Home': Icons.home,
      'Work': Icons.work_rounded,
      'Others': Icons.add_to_photos_outlined,
    };
    IconData iconPath = iconPaths[title] ?? Icons.error;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedAddressTypeIndex = index;
            addressTypeSave = title;
          });
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? const Color(0xFFE23744) : Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconPath,
                  color: isSelected
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF201135)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF201135),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> cancelButtonDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Do Not Save Address'),
            content: const Text('All changes will be lost?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await Future.delayed(const Duration(milliseconds: 400));
                  Get.back();
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        });
  }
}

class InputTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const InputTextField(
      {required this.label,
      required this.hintText,
      required this.keyboardType,
      required this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
