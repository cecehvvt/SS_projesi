class AppListing {
  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String description;
  final String listingType;
  final String category;
  final String subCategory;
  final String city;
  final String district;
  final String condition;
  final String deliveryMethod;
  final String contactPreference;
  final String? desiredSwapItem;
  final List<String> imageUrls;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool favorite;

  const AppListing({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.description,
    required this.listingType,
    required this.category,
    required this.subCategory,
    required this.city,
    required this.district,
    required this.condition,
    required this.deliveryMethod,
    required this.contactPreference,
    this.desiredSwapItem,
    required this.imageUrls,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.favorite = false,
  });

  String get location => '$district, $city';

  String get firstImage => imageUrls.isEmpty ? '' : imageUrls.first;

  Map<String, dynamic> toJson() => {
    'ownerId': ownerId,
    'ownerName': ownerName,
    'title': title,
    'description': description,
    'listingType': listingType,
    'category': category,
    'subCategory': subCategory,
    'city': city,
    'district': district,
    'condition': condition,
    'deliveryMethod': deliveryMethod,
    'contactPreference': contactPreference,
    'desiredSwapItem': desiredSwapItem,
    'imageUrls': imageUrls,
    'status': status,
  };

  factory AppListing.fromJson(Map<String, dynamic> json) {
    return AppListing(
      id: json['id']?.toString() ?? '',
      ownerId: (json['ownerId'] ?? json['ilanSahibiId'] ?? '').toString(),
      ownerName:
          (json['ownerName'] ?? json['ilanSahibiAdSoyad'] ?? 'Vesta Kullanici')
              .toString(),
      title: (json['title'] ?? json['baslik'] ?? '').toString(),
      description: (json['description'] ?? json['aciklama'] ?? '').toString(),
      listingType: (json['listingType'] ?? json['ilanTuru'] ?? 'bagis')
          .toString(),
      category: (json['category'] ?? json['kategori'] ?? 'Diger').toString(),
      subCategory: (json['subCategory'] ?? '').toString(),
      city: (json['city'] ?? _cityFromLocation(json['konum']) ?? 'Istanbul')
          .toString(),
      district:
          (json['district'] ?? _districtFromLocation(json['konum']) ?? 'Merkez')
              .toString(),
      condition: (json['condition'] ?? json['urunDurumu'] ?? 'Iyi').toString(),
      deliveryMethod: (json['deliveryMethod'] ?? 'Elden teslim').toString(),
      contactPreference: (json['contactPreference'] ?? 'Uygulama ici mesaj')
          .toString(),
      desiredSwapItem: json['desiredSwapItem']?.toString(),
      imageUrls: List<String>.from(
        json['imageUrls'] ?? json['fotografUrls'] ?? const [],
      ),
      status:
          (json['status'] ?? ((json['aktif'] == false) ? 'deleted' : 'active'))
              .toString(),
      createdAt: _date(json['createdAt'] ?? json['olusturmaTarihi']),
      updatedAt: _date(json['updatedAt'] ?? json['olusturmaTarihi']),
      favorite:
          json['favorite'] as bool? ?? json['favorilendi'] as bool? ?? false,
    );
  }

  static DateTime _date(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  static String? _districtFromLocation(dynamic value) {
    if (value == null) return null;
    return value.toString().split(',').first.trim();
  }

  static String? _cityFromLocation(dynamic value) {
    if (value == null) return null;
    final parts = value.toString().split(',');
    return parts.length > 1 ? parts[1].trim() : null;
  }
}
