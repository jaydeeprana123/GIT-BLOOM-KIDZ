import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloom_kidz/CommonWidgets/common_appbar.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Notification/controller/notification_controller.dart';
import 'notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController = Get.put(NotificationController());
  final ScrollController notificationScrollController = ScrollController();

  Future<void> _onRefresh() async {
    notificationController.resetPagination();
    await notificationController.callNotificationsAPI(context, isToClearList: true);
    notificationController.unreadCount.value = 0;
  }

  void _initScrollListener() {
    notificationScrollController.addListener(() {
      if (!notificationScrollController.hasClients) return;
      final position = notificationScrollController.position;
      
      // Load more when user scrolls close to the bottom
      if (position.pixels >= position.maxScrollExtent - 50) {
        if (notificationController.isMoreDataAvailable.value &&
            !notificationController.isPaginationLoading.value &&
            !notificationController.isLoading.value) {
          notificationController.callNotificationsAPI(context, isToClearList: false);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
      _initScrollListener();
    });
  }

  @override
  void dispose() {
    notificationScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_f8f8f8,
      appBar: CommonAppBar(
        title: "Notifications",
        showMenu: false,
        showBack: true,
        showClearAllButton: true,
        onClearAllTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Clear All"),
              content: const Text("Are you sure you want to clear all notifications?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    notificationController.callClearAllAPI(context);
                  },
                  child: const Text("Clear", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                if (!notificationController.isLoading.value &&
                    notificationController.notificationList.isEmpty)
                  Expanded(
                    child: Center(
                      child: BlueLargeBoldText("No Notifications Found"),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: color_primary,
                      child: ListView.builder(
                        controller: notificationScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: notificationController.notificationList.length,
                        itemBuilder: (context, index) {
                          final item = notificationController.notificationList[index];
                          return NotificationCard(
                            item: item,
                            onTap: () {
                              if (item.readStatus == 'N') {
                                notificationController.callMarkAsReadAPI(context, item.id ?? 0);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),

                // Pagination Loading Indicator at the bottom
                if (notificationController.isPaginationLoading.value)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: const CircularProgressIndicator(color: color_primary),
                    ),
                  ),
              ],
            ),

            // Full-screen Loading Indicator for first load
            if (notificationController.isLoading.value)
              const Center(
                child: CircularProgressIndicator(color: color_primary),
              ),
          ],
        ),
      ),
    );
  }
}
