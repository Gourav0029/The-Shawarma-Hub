import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/sidebar/manage_address.dart';
import 'package:http/http.dart' as http;

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final storage = GetStorage();
  String tokens = '';
  String name = '';

  Future<void> getAvailableToken() async {
    String phoneNumber = storage.read('phone');
    String apiUrl =
        '${dotenv.get('API_URL')}/shawarmahouse/v1/gettokens?phoneNumber=$phoneNumber';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.body);
        setState(() {
          tokens = response.body;
        });

        debugPrint('Available Tokens: $tokens');
      } else {
        throw Exception(
            'Failed to load Available tokens. Response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAvailableToken();
    name = storage.read('name');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              UserAccountsDrawerHeader(
                // decoration: const BoxDecoration(
                //   color: Color.fromARGB(255, 228, 247, 232),
                // ),
                accountName: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Align the account name to the baseline
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    // Adjust the width between the name and avatar
                  ],
                ),
                accountEmail: Row(
                  children: [
                    Text(
                      'Available token: $tokens',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      // Ensure the IconButton is expanded to take remaining space
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // Align the IconButton to the right
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFFFFFFFF)),
                            onPressed: () {
                              // Navigate to the EditPage class
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                currentAccountPicture: Container(
                  margin: const EdgeInsets.only(bottom: 9.0),
                  child:
                      //  profileImage.isNotEmpty
                      //     ? CircleAvatar(
                      //         backgroundImage: NetworkImage(profileImage),
                      //         radius: 50, // Adjust the radius as needed
                      //       )
                      //     :
                      const CircleAvatar(
                    child: Icon(Icons.account_circle,
                        size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.add_location_alt),
            title: Text(
              'Manage Delivery Address',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.to(() => const ManageAddress());
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(
              'Order History',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Get.to(() => const ManageAddress());
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(
              'Favourites',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              //Get.to(() => const MyOrders());
            },
          ),
          //const SizedBox(height: 4),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(
              'FAQ',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Get.to(() => FAQPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(
              'Grievance',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              //Get.to(() => const GrievancePage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(
              'Feedback',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              //Get.to(() => const FeedbackPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(
              'Log Out',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // storage.erase();
              // Show the sign-out confirmation dialog
              showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showSignOutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color(0xFF201135),
              fontWeight: FontWeight.w500),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color(0xFF201135),
              fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Get.offAll(
              //   const LoginPage(),
              // ); // Close the dialog

              //logout();
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF201135),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    },
  );
}
