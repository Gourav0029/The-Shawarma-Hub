import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/sidebar/add_address.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 24,
        //backgroundColor: const Color(0xFFF4F0F9),
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
                        log(result.toString());

                        if (result == true) {
                          //refreshDeliveryAddress();
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
              ListView.builder(
                  itemCount: 4,
                  //deliveryAddressList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    // AddressList address =
                    //     deliveryAddressList[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Container(
                        width: screenWidth,
                        // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                                    // width: 73.0,
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
                                        // SvgPicture.asset(
                                        //   iconPaths[
                                        //       '${address.addressType}']!,
                                        //   color: const Color(
                                        //       0xFF201135),
                                        // ),
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          //'${address.addressType}',
                                          'Home',
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
                                //'${address.fullName}, ${address.address}',
                                'Gourav Kumar Jha, Dummy Address',
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
                                    onPressed: () async {
                                      // final bool? result =
                                      //     await Get.to(() =>
                                      //         EditDeliveryAddress(
                                      //           address: address,
                                      //         ));
                                      // log(result.toString());

                                      // if (result == true) {
                                      //  // refreshDeliveryAddress();
                                      // }
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
                                      // addressId =
                                      //     address.addressId!;
                                      // cancelButtonDialog(
                                      //     addressId);
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
