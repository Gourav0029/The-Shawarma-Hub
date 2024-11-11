import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:the_shawarma_hub/helper/custom_snackbar.dart';
import 'package:the_shawarma_hub/helper/location_helper.dart';
import 'package:the_shawarma_hub/helper/utils.dart';
import 'package:the_shawarma_hub/main_app/landing_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isProcessing = false; //? for login process
  final locationHelper = LocationHelper();
  final storage = GetStorage();

  Future<void> login(String name, String phone) async {
    setState(() {
      isProcessing = true;
    });
    String apiUrl = '${dotenv.get('API_URL')}/shawarmahouse/v1/createUser';

    final requestBody = {'name': name, 'phoneNumber': phone};

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody));

      log(response.statusCode.toString());

      if (response.statusCode == 201) {
        log(response.body);
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final String userId = jsonResponse['user_id'];
        final String name = jsonResponse['name'];
        final String phone = jsonResponse['phone'];
        final double tokens = jsonResponse['tokens'];

        storage.write('userId', userId);
        storage.write('name', name);
        storage.write('phone', phone);
        storage.write('tokens', tokens);

        Get.to(() => const LandingPage());
      } else {
        throw Exception(
            'failed to Login User. Response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    locationHelper.initLocation();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFAE3C8),
        ),
        child: Stack(
          children: [
            Positioned(
              top: screenHeight *
                  0.05, // Adjust the top value to move the image up or down
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(bottom: -5, child: _buildBottom()),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      //height: screenHeight * 0.48,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 24,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Welcome!',
            style: GoogleFonts.outfit(
              color: const Color(0xFF2D2D2D),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _buildBlackText("Mobile Number"),
          const SizedBox(height: 4),
          _buildInputField(mobileController),
          const SizedBox(height: 12),

          InputTextField(
              label: 'Full Name',
              hintText: 'Full Name (required)',
              keyboardType: TextInputType.text,
              controller: fullNameController),
          const SizedBox(height: 30),
          _buildLoginButton(),
          const SizedBox(height: 16),
          // Text(
          //   'OR',
          //   textAlign: TextAlign.center,
          //   style: GoogleFonts.outfit(
          //     color: const Color(0xFF1A351A),
          //     fontSize: 20,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
          // const SizedBox(height: 16),
          // continueWithoutLogin(),
          // const SizedBox(height: 24)
        ],
      ),
    );
  }

  Widget _buildBlackText(String text) {
    return Text(text,
        style: GoogleFonts.outfit(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400));
  }

  Widget _buildInputField(
    TextEditingController controller,
  ) {
    return SizedBox(
      child: IntlPhoneField(
        controller: controller,
        keyboardType: TextInputType.phone,
        focusNode: focusNode,
        languageCode: "en",
        initialCountryCode: 'IN',
        onChanged: (phone) {
          debugPrint(phone.completeNumber);
        },
        onCountryChanged: (country) {
          debugPrint('Country changed to: ${country.name}');
        },
        decoration: InputDecoration(
          counterText: '',
          hintText: 'Enter mobile number',
          hintStyle: GoogleFonts.outfit(
            color: const Color(0xFF597173),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          fillColor: const Color(0xFFFFFFFF),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFCBD6D6),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFCBD6D6),
              width: 0.3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFCBD6D6),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget continueWithoutLogin() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF237236), Color(0xFF237236)],
          ),
        ),
        child: Text(
          'Continue without Login',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      child: InkWell(
        onTap: () async {
          if (mobileController.text.isEmpty ||
              fullNameController.text.isEmpty) {
            CustomSnackbar.showSnackbar(
                context, "Mobile Number and Name can't be empty", Colors.red);
          } else {
            Utils.dismissKeyboard(context: context);
            await login(fullNameController.text, mobileController.text);
          }
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCB202D), Color(0xFFE23744)]),
          ),
          child: isProcessing == true
              ? const Center(
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                )
              : Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
        ),
      ),
    );
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
        const SizedBox(height: 4),
        TextField(
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFFFFF),
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
