import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/helper/address_db_helper.dart';
import 'package:the_shawarma_hub/sidebar/add_address.dart';

class ChangeAddressPage extends StatefulWidget {
  const ChangeAddressPage({Key? key}) : super(key: key);

  @override
  ChangeAddressPageState createState() => ChangeAddressPageState();
}

class ChangeAddressPageState extends State<ChangeAddressPage> {
  final storage = GetStorage();
  List<Map<String, dynamic>> _addressList = [];
  int? _selectedAddressId; // Tracks the selected address ID

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    String userId = storage.read('userId');
    final addresses = await AddressDatabaseHelper().fetchAddresses(userId);
    setState(() {
      _addressList = addresses;
      // Preselect the address if stored in GetStorage
      _selectedAddressId = storage.read('selectedAddressId');
    });
  }

  void _selectAddress(Map<String, dynamic> address) {
    setState(() {
      _selectedAddressId = address['id'];
    });
    // Save the selected address in local storage
    storage.write('selectedAddress', address);
    storage.write('selectedAddressId', address['id']);
    Get.back(); // Navigate back to cart
  }

  // Get the icon based on address type (Home, Work, Others)
  Map<String, IconData> iconPaths = {
    'Home': Icons.home,
    'Work': Icons.work_rounded,
    'Others': Icons.add_to_photos_outlined,
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 24,
          title: Text(
            'Change Address',
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
                            //_refreshDeliveryAddress(); // Refresh after adding a new address.
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
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Addresses',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: const Color(0xFF201135),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _addressList.isEmpty
                          ? const Center(child: Text("No saved addresses."))
                          : ListView.builder(
                              itemCount: _addressList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final address = _addressList[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 24.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 24.0,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFE23744),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12.0),
                                                    bottomRight:
                                                        Radius.circular(12.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      iconPaths[address[
                                                              'addressType']] ??
                                                          Icons.error,
                                                      size: 18,
                                                      color: const Color(
                                                          0xFFFFFFFF),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      address['addressType'] ??
                                                          'Home',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 14,
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Radio<int>(
                                                value: address['id'],
                                                groupValue: _selectedAddressId,
                                                onChanged: (value) =>
                                                    _selectAddress(address),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${address['fullName']}, ${address['addressLine1']}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              color: const Color(0xFF201135),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
