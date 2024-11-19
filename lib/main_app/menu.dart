import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_shawarma_hub/controller/cart_controller.dart';
import 'package:the_shawarma_hub/helper/cart_db_helper.dart';
import 'package:the_shawarma_hub/model/cart_items_model.dart';
import 'package:the_shawarma_hub/model/menu_items_model.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuItems> menuItems = [];
  bool isLoading = true;
  final dbHelper = CartDatabaseHelper();

  final Map<String?, RxInt> itemCounts = {};
  final CartController cartController = Get.find<CartController>();
  @override
  void initState() {
    super.initState();
    getAllMenuItems();
    //initializeItemCounts();
  }

  Future<void> initializeItemCounts() async {
    // Wait for all counts to be fetched
    await Future.wait(menuItems.map((item) async {
      int count = await dbHelper.getItemCount(item.itemId!);
      itemCounts[item.itemId!] = count.obs; // Initialize with stored count
    }));
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

  Future<void> getAllMenuItems() async {
    String apiUrl = '${dotenv.get('API_URL')}/shawarmahouse/v1/getAllMenuItems';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        log('Response: ${response.body}');
        menuItems =
            jsonResponse.map((item) => MenuItems.fromJson(item)).toList();
        await initializeItemCounts();
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load menu items. Response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        isLoading = false; // Avoid infinite loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Additional safety: Ensure itemCounts is fully initialized
    if (menuItems.isEmpty || itemCounts.isEmpty) {
      return const Center(child: Text("No menu items available."));
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : menuItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: menuItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            MenuItems items = menuItems[index];
                            String directImageLink =
                                convertToDirectLink(items.photo!);
                            // Retrieve the `itemCount` for this item
                            RxInt itemCount =
                                itemCounts[items.itemId!] ?? 0.obs;
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Text(
                                                            'In Stock',
                                                            style: GoogleFonts
                                                                .outfit(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xFF107025),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 2),
                                                        Text(
                                                          '₹ ${items.price}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: GoogleFonts
                                                              .outfit(
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
                                                    Obx(() {
                                                      if (itemCount.value > 0) {
                                                        return CustomCartStepper(
                                                          itemCount: itemCount,
                                                          item: items,
                                                        );
                                                      } else {
                                                        return InkWell(
                                                          onTap: () async {
                                                            itemCount.value++;

                                                            CartItem cartItem =
                                                                CartItem
                                                                    .fromMenuItem(
                                                                        items,
                                                                        1);

                                                            await dbHelper
                                                                .insertOrUpdateCartItem(
                                                                    cartItem);

                                                            await cartController
                                                                .updateCartItemCount();
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    12,
                                                                    12,
                                                                    12,
                                                                    12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFFE23744),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '+ Add',
                                                                style:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: const Color(
                                                                      0xFFFFFFFF),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                ExpansionTile(
                                                  title: Row(
                                                    children: [
                                                      Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: getDotColor(
                                                              items
                                                                  .subCategory!),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Product Description',
                                                        style:
                                                            GoogleFonts.outfit(
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
                                                        style:
                                                            GoogleFonts.outfit(
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
                          },
                        )
                      : const Center(
                          child: Text(
                            'Menu Items can not be fetched, right now.',
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomCartStepper extends StatefulWidget {
  final RxInt itemCount;
  final MenuItems item;

  const CustomCartStepper(
      {required this.itemCount, required this.item, super.key});

  @override
  State<CustomCartStepper> createState() => _CustomCartStepperState();
}

class _CustomCartStepperState extends State<CustomCartStepper> {
  final storage = GetStorage();
  final dbHelper = CartDatabaseHelper();
  final CartController cartController = Get.find<CartController>();

  void updateCartItem(int quantity) async {
    if (quantity > 0) {
      CartItem cartItem = CartItem.fromMenuItem(widget.item, quantity);
      await dbHelper.insertOrUpdateCartItem(cartItem);
      await cartController.updateCartItemCount();
    } else {
      await dbHelper.deleteCartItem(widget.item.itemId!);
      await cartController.updateCartItemCount();
    }
  }

  //final controller = Get.put(MedicineSearchController());

  @override
  void initState() {
    super.initState();
    updateCartItem(widget.itemCount.value);
  }

  increment() {
    widget.itemCount.value++;
    setState(() {
      updateCartItem(widget.itemCount.value);
    });
  }

  decrement() async {
    setState(() {
      if (widget.itemCount > 0) {
        widget.itemCount.value--;
        updateCartItem(widget.itemCount.value);
      } else {
        updateCartItem(widget.itemCount.value);
      }
    });
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
          Expanded(
            child: Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    '${widget.itemCount.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
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
