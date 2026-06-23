import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  final _service = const NotificationService();
  late Future<(List<SwapRequest>, List<AppNotification>)> _future = _load();

  Future<(List<SwapRequest>, List<AppNotification>)> _load() async {
    final results = await Future.wait([
      _service.getIncomingSwaps(),
      _service.getNotifications(),
    ]);
    return (
      results[0] as List<SwapRequest>,
      results[1] as List<AppNotification>,
    );
  }

  void _reload() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: FutureBuilder<(List<SwapRequest>, List<AppNotification>)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ListView(
              children: [
                const SizedBox(height: 120),
                const Icon(Icons.error_outline, size: 46, color: Colors.grey),
                const SizedBox(height: 12),
                const Center(child: Text('Bildirimler yüklenemedi.')),
                Center(
                  child: TextButton(
                    onPressed: _reload,
                    child: const Text('Tekrar dene'),
                  ),
                ),
              ],
            );
          }
          final swaps = snapshot.data?.$1 ?? const <SwapRequest>[];
          final notifications = snapshot.data?.$2 ?? const <AppNotification>[];
          if (swaps.isEmpty && notifications.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Icon(Icons.notifications_none, size: 52, color: Colors.grey),
                SizedBox(height: 12),
                Center(child: Text('Henüz bildirimin yok.')),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.all(14),
            children: [
              ...swaps.map(_swapCard),
              ...notifications.map(_notificationCard),
            ],
          );
        },
      ),
    );
  }

  Widget _swapCard(SwapRequest request) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.swap_horiz, color: Color(0xFF2E7D32)),
                SizedBox(width: 8),
                Text(
                  'Takas isteği',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${request.requesterName}, "${request.listing.title}" ilanı için takas yapmak istiyor.',
            ),
            const SizedBox(height: 10),
            if (request.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Reddet',
                    onPressed: () => _respond(request, false),
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    tooltip: 'Onayla',
                    onPressed: () => _respond(request, true),
                    icon: const Icon(Icons.check),
                  ),
                ],
              )
            else
              Text(
                request.status == 'accepted' ? 'Onaylandı' : 'Reddedildi',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: request.status == 'accepted'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(AppNotification notification) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.notifications_outlined)),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(notification.message),
      ),
    );
  }

  Future<void> _respond(SwapRequest request, bool accepted) async {
    try {
      await _service.respond(request.id, accepted);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accepted ? 'Takas isteği onaylandı.' : 'Takas isteği reddedildi.',
          ),
        ),
      );
      _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
