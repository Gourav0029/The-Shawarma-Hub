import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/helper/cart_db_helper.dart';
import 'package:the_shawarma_hub/model/cart_items_model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> deliveryAddressList = [1, 2, 3];
  List<CartItem> cartItems = [];
  final dbHelper = CartDatabaseHelper();

  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      List<CartItem> items = await dbHelper.getCartItems();
      log('Fetched items: $items'); // Verify fetched items

      setState(() {
        cartItems = items;
        log('Updated cartItems in state: ${cartItems.length}');
      });
      calculateTotalPrice();
    } catch (e) {
      log('Error fetching items: $e');
    }
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += (item.quantity ?? 0) * (item.price ?? 0.0);
    }
    setState(() {
      totalPrice = total;
    });
  }

  String convertToDirectLink(String driveLink) {
    final RegExp regex = RegExp(r'file/d/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(driveLink);
    if (match != null && match.groupCount == 1) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    } else {
      return 'Invalid Google Drive link';
    }
  }

  Color getDotColor(String subCategory) {
    if (subCategory.toLowerCase() == 'veg') {
      return Colors.green;
    } else if (subCategory.toLowerCase() == 'nonveg') {
      return Colors.red;
    } else {
      return Colors.grey; // Default color if subCategory is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F0F9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              deliveryAddressList.isNotEmpty
                  ? Container(
                      width: screenWidth,
                      //height: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7219F7).withOpacity(0.14),
                            offset: const Offset(4, 6),
                            blurRadius: 16,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Deliver To',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: const Color(0xFF201135),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  // Get.to(() => const ChangeAddress());
                                  // Navigate to the change address page and await the result
                                  // final newIndex = await Get.to<int>(
                                  //     () => const ChangeAddress());
                                  // if (newIndex != null &&
                                  //     newIndex != selectedAddressIndex) {
                                  //   // Update selected address index and trigger UI refresh
                                  //   setState(() {
                                  //     selectedAddressIndex = newIndex;
                                  //     storage.write('selectedAddressIndex',
                                  //         selectedAddressIndex);
                                  //     refreshDeliveryAddress();
                                  //   });
                                  //   setState(() {});
                                  // }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAE1F7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Change',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: const Color(0xFFE23744),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gourav',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sample address',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mobile Number: 7488850519',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: screenWidth,
                      //height: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE23744).withOpacity(0.14),
                            offset: const Offset(4, 6),
                            blurRadius: 16,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Deliver To',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: const Color(0xFF201135),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              // log("Address details added");
                              // //Add Navigation to Add Delivery Page
                              // final bool? result = await Get.to(
                              //     () => const AddDeliveryAddress());

                              // log(result.toString());

                              // if (result == true) {
                              //   refreshDeliveryAddress();
                              // }
                            },
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              borderPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 4.0),
                              strokeWidth: 3,
                              color: const Color(0xFFBAB1C7),
                              dashPattern: const [12, 12, 12, 12],
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              child: SizedBox(
                                width: screenWidth <= 400 ? 240 : 220,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const ClipOval(child: Icon(Icons.add)),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Add New Delivery Address",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF524862),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Enter address to know expected delivery date.",
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF857B94),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 12),
              const Divider(
                thickness: 2,
                color: Color(0xFFE0DCE5),
              ),
              const SizedBox(height: 12),
              cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: cartItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        try {
                          CartItem items = cartItems[index];
                          String directImageLink =
                              convertToDirectLink(items.photo!);
                          // RxInt itemCount = (items.quantity ?? 0).obs;
                          log("Building item: ${items.name}");
                          return Padding(
                            key: ValueKey(items.itemId),
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE23744)
                                        .withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(4, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                          directImageLink,
                                          height: 100,
                                          width: 75,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items.name!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFF2D2D2D),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                3, 4, 3, 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFBCF2C8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          'In Stock',
                                                          style: GoogleFonts
                                                              .outfit(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xFF107025),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        '₹ ${items.price}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style:
                                                            GoogleFonts.outfit(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFFE23744),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  CustomCartStepper(
                                                    // itemCount: itemCount,
                                                    item: items,
                                                    onUpdate: fetchCartItems,
                                                    onItemRemoved: () {
                                                      setState(() {
                                                        cartItems
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              ExpansionTile(
                                                title: Row(
                                                  children: [
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        color: getDotColor(
                                                            items.subCategory!),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Product Description',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0xFF2D2D2D),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      items.description!,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 14,
                                                        color: const Color(
                                                            0xFF2D2D2D),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } catch (e) {
                          log('Error building item at index $index: $e');
                          return const SizedBox.shrink(); // Fallback widget
                        }
                      },
                    )
                  : const Center(
                      child: Text(
                        'Cart Items can not be fetched, right now.',
                      ),
                    ),
              const SizedBox(height: 12),
              const Divider(
                thickness: 2,
                color: Color(0xFFE0DCE5),
              ),
              const SizedBox(height: 12),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF8F5FF)
                    ], // Subtle gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE23744).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Details',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: const Color(0xFF201135),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Item Price:',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rs. $totalPrice',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discount:',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '-Rs. 10',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF107025),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Charge:',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '+ 0',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFFC14141),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 2,
                      color: Color(0xFFE0DCE5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount:',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rs. $totalPrice',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFF201135),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCartStepper extends StatefulWidget {
  //final RxInt itemCount;
  final CartItem item;
  final VoidCallback onUpdate;
  final VoidCallback onItemRemoved;

  const CustomCartStepper(
      {required this.item,
      required this.onUpdate,
      required this.onItemRemoved,
      super.key});

  @override
  State<CustomCartStepper> createState() => _CustomCartStepperState();
}

class _CustomCartStepperState extends State<CustomCartStepper> {
  final storage = GetStorage();
  final dbHelper = CartDatabaseHelper();

  late RxInt itemCount;

  void updateCartItem(int quantity) async {
    if (quantity > 0) {
      // Update the cart item in the database
      await dbHelper
          .insertOrUpdateCartItem(widget.item.copyWith(quantity: quantity));
    } else {
      await dbHelper.deleteCartItem(widget.item.itemId!);
      widget.onItemRemoved();
    }
    widget.onUpdate(); // Trigger the callback to refresh the parent
  }
  //final controller = Get.put(MedicineSearchController());

  @override
  void initState() {
    super.initState();
    itemCount = (widget.item.quantity ?? 0).obs;
  }

  void increment() {
    itemCount.value++;
    updateCartItem(itemCount.value);
  }

  void decrement() {
    if (itemCount.value > 0) {
      itemCount.value--;
      updateCartItem(itemCount.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      height: 34.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xFFEAE1F7),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                decrement();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFCCAFF7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                ),
                child: const Icon(Icons.remove,
                    color: Color(0xFFE23744), size: 32),
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      '${itemCount.value}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                increment();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFCCAFF7),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child:
                    const Icon(Icons.add, color: Color(0xFFE23744), size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
