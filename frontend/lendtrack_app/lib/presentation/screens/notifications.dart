import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'Chisomo Banda - Overdue', 'message': 'Loan payment is 5 days overdue!', 'time': '2 min ago', 'type': 'overdue'},
      {'title': 'Repayment Received', 'message': 'MK 460,000 received from Thandiwe Phiri', 'time': '1 hour ago', 'type': 'success'},
      {'title': 'Reminder: Payment Due', 'message': 'Chisomo Banda\'s payment is due in 3 days', 'time': 'Yesterday', 'type': 'reminder'},
      {'title': 'New Loan Application', 'message': 'Mary Mwale applied for MK 500,000', 'time': '2 days ago', 'type': 'info'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: notification['type'] == 'overdue' 
                    ? Colors.red.shade50 
                    : notification['type'] == 'success' 
                      ? Colors.green.shade50 
                      : Colors.blue.shade50,
                child: Icon(
                  notification['type'] == 'overdue' ? Icons.warning_amber_rounded :
                  notification['type'] == 'success' ? Icons.check_circle_outline :
                  Icons.info_outline,
                  color: notification['type'] == 'overdue' ? Colors.red :
                         notification['type'] == 'success' ? Colors.green :
                         Colors.blue,
                ),
              ),
              title: Text(notification['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['message']!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  const SizedBox(height: 2),
                  Text(notification['time']!, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
              trailing: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
            ),
          );
        },
      ),
    );
  }
}
