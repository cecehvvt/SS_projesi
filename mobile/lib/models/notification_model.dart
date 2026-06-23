import 'app_listing.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.read,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id']?.toString() ?? '',
        title: json['baslik']?.toString() ?? 'Bildirim',
        message: json['mesaj']?.toString() ?? '',
        createdAt:
            DateTime.tryParse(json['olusturmaZamani']?.toString() ?? '') ??
            DateTime.now(),
        read: json['okundu'] as bool? ?? false,
      );
}

class SwapRequest {
  final String id;
  final String requesterName;
  final String status;
  final AppListing listing;
  final DateTime updatedAt;

  const SwapRequest({
    required this.id,
    required this.requesterName,
    required this.status,
    required this.listing,
    required this.updatedAt,
  });

  bool get pending => status == 'pending';

  factory SwapRequest.fromJson(Map<String, dynamic> json) => SwapRequest(
    id: json['id']?.toString() ?? '',
    requesterName: json['requesterName']?.toString() ?? 'Bir kullanıcı',
    status: json['status']?.toString() ?? 'pending',
    listing: AppListing.fromJson(
      Map<String, dynamic>.from(json['listing'] as Map),
    ),
    updatedAt:
        DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
        DateTime.now(),
  );
}
