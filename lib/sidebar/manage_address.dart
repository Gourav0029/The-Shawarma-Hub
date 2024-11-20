import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/helper/address_db_helper.dart';
import 'package:the_shawarma_hub/sidebar/add_address.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  List<Map<String, dynamic>> _deliveryAddressList =
      []; // Holds fetched addresses.
  final storage = GetStorage();

  // Define a map to associate address types with icons
  Map<String, IconData> iconPaths = {
    'Home': Icons.home,
    'Work': Icons.work_rounded,
    'Others': Icons.add_to_photos_outlined,
  };

// Get the icon for a specific address type
  IconData getAddressTypeIcon(String addressType) {
    return iconPaths[addressType] ??
        Icons.error; // Default to error icon if type not found
  }

  @override
  void initState() {
    super.initState();
    _refreshDeliveryAddress(); // Fetch addresses when page loads.
  }

  // Fetch saved addresses from the database
  Future<void> _refreshDeliveryAddress() async {
    try {
      String userId = storage.read('userId');
      final List<Map<String, dynamic>> addresses =
          await AddressDatabaseHelper().fetchAddresses(userId);
      log('Fetched addresses: $addresses'); // Log the fetched data.
      setState(() {
        _deliveryAddressList = addresses;
      });
    } catch (e) {
      log("Error fetching addresses: $e");
    }
  }

  Future<void> _deleteAddress(int addressId) async {
    try {
      await AddressDatabaseHelper().deleteAddress(addressId);
      await _refreshDeliveryAddress(); // Refresh the list after deletion

      log('Address with ID $addressId deleted successfully');
    } catch (e) {
      log('Error deleting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 24,
        title: Text(
          'Manage Address',
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
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE23744).withOpacity(0.08),
                      spreadRadius: 4.0,
                      blurRadius: 16.0,
                      offset: const Offset(4, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final bool? result =
                            await Get.to(() => const AddDeliveryAddress());
                        if (result == true) {
                          _refreshDeliveryAddress(); // Refresh after adding a new address.
                        }
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        borderPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 4.0),
                        strokeWidth: 3,
                        color: const Color(0xFFBAB1C7),
                        dashPattern: const [8, 8, 8, 8],
                        radius: const Radius.circular(8),
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_location_alt_rounded,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Add New Delivery Address',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: const Color(0xFF524862),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _deliveryAddressList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _deliveryAddressList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final address = _deliveryAddressList[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: const Color(0xFFE0DCE5),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 24.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 24.0,
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 4.0, 8.0, 4.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE23744),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              getAddressTypeIcon(address[
                                                      'addressType'] ??
                                                  'Others'), // Fetch icon dynamically
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              address['addressType'] ??
                                                  'Others',
                                              style: GoogleFonts.outfit(
                                                fontSize: 14,
                                                color: const Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${address['fullName']}, ${address['addressLine1']}, ${address['addressLine2'] ?? ''}, ${address['landmark'] ?? ''}, ${address['city']}, ${address['state']} - ${address['pincode']}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: const Color(0xFF201135),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Color(0xFFE0DCE5),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        child: Text(
                                          'Edit',
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            color: const Color(0xFFE23744),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () {
                                          // Implement edit functionality
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            color: const Color(0xFFE23744),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () {
                                          final addressId = address[
                                              'id']; // Get the ID from the address map
                                          _deleteAddress(
                                              addressId); // Pass the ID to the delete function
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No Delivery Address saved until now!',
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
