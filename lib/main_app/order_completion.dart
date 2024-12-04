import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/controller/cart_controller.dart';
import 'package:the_shawarma_hub/main_app/landing_page.dart';
import 'package:http/http.dart' as http;

class PaymentCompletion extends StatefulWidget {
  const PaymentCompletion({super.key});

  @override
  State<PaymentCompletion> createState() => _PaymentCompletionState();
}

class _PaymentCompletionState extends State<PaymentCompletion> {
  final storage = GetStorage();

  String name = 'username';
  String phone = '';
  String token = '0.0';
  bool isLoading = true;
  Map<String, dynamic>? address;

  @override
  void initState() {
    super.initState();
    getAvailableToken();
    address = storage.read('selectedAddress');
  }

  Future<void> getAvailableToken() async {
    name = storage.read('name') ?? 'default_name';
    phone = storage.read('phone') ?? 'default_phone';
    String apiUrl =
        '${dotenv.get('API_URL')}/shawarmahouse/v1/gettokens?phoneNumber=$phone';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.body);
        setState(() {
          token = response.body;
        });

        storage.write('tokens', token);

        debugPrint('Available Tokens: $token');
      } else {
        throw Exception(
            'Failed to load Available tokens. Response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 75),
              Image.asset(
                'assets/images/SuccessfullyDone.gif',
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 8),
              Text(
                'Order Successful!',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your Order has been placed successfully!',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF857B94),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 44),
              Container(
                width: screenWidth,
                height: screenWidth <= 400 ? 120 : 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Information:',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: const Color(0xFF201135),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Name:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            'phone:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          phone,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: screenWidth,
                //height: screenWidth <= 400 ? 120 : 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Details:',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: const Color(0xFF201135),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Name:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          address?['fullName'],
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Address:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ' ${address?['addressLine1']}, ${address?['addressLine2']}, ${address?['landmark'] ?? ''} ',
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Mobile:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          address?['mobileNumber'],
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFFEAE1F7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Available Tokens:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF857B94),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            token,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  // Handle onTap action
                  Get.find<CartController>().updateCartItemCount();
                  Get.offAll(() => const LandingPage());
                },
                child: Container(
                  width: screenWidth,
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE1F7), // #EAE1F7
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Go Back to Home',
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
      ),
    );
  }
}
