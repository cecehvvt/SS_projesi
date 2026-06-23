class ListingCategory {
  final String name;
  final List<String> subCategories;

  const ListingCategory(this.name, this.subCategories);
}

class ListingTaxonomy {
  ListingTaxonomy._();

  static const listingTypes = ['bagis', 'ihtiyac', 'takas'];

  static const conditions = [
    'Yeni / Acilmamis',
    'Az kullanilmis',
    'Iyi',
    'Onarim gerekebilir',
  ];

  static String conditionLabel(String condition) {
    switch (condition) {
      case 'Yeni / Acilmamis':
        return 'Yeni / Kullanılmamış';
      case 'Az kullanilmis':
        return 'Az kullanılmış';
      case 'Iyi':
        return 'İyi';
      case 'Onarim gerekebilir':
        return 'Onarım gerekebilir';
      default:
        return condition;
    }
  }

  static String categoryLabel(String category) {
    switch (category) {
      case 'Kadin':
        return 'Kadın';
      case 'Cocuk & Bebek':
        return 'Çocuk & Bebek';
      case 'Ev & Yasam':
        return 'Ev & Yaşam';
      case 'Kitap & Kirtasiye':
        return 'Kitap & Kırtasiye';
      case 'Diger':
        return 'Diğer';
      default:
        return category;
    }
  }

  static String optionLabel(String value) {
    const labels = {
      'Ayakkabi': 'Ayakkabı',
      'Kucuk Ev Elektronigi': 'Küçük Ev Elektroniği',
      'Ev Esyalari': 'Ev Eşyaları',
      'Mutfak Gerecleri': 'Mutfak Gereçleri',
      'Kirtasiye': 'Kırtasiye',
      'Uygulama ici mesaj': 'Uygulama içi mesaj',
      'Telefonu sonra paylas': 'Telefonu sonra paylaş',
      'Istanbul': 'İstanbul',
      'Izmir': 'İzmir',
      'Diger': 'Diğer',
      'Uskudar': 'Üsküdar',
      'Kadikoy': 'Kadıköy',
      'Beyoglu': 'Beyoğlu',
      'Besiktas': 'Beşiktaş',
      'Cankaya': 'Çankaya',
      'Kecioren': 'Keçiören',
      'Karsiyaka': 'Karşıyaka',
      'Nilufer': 'Nilüfer',
      'Yildirim': 'Yıldırım',
    };
    return labels[value] ?? value;
  }

  static String locationLabel(String location) {
    return location
        .split(RegExp(r'\s*/\s*|\s*,\s*'))
        .map(optionLabel)
        .join(' / ');
  }

  static const deliveryMethods = ['Elden teslim', 'Kargo', 'Fark etmez'];

  static const contactPreferences = [
    'Uygulama ici mesaj',
    'Telefonu sonra paylas',
  ];

  static const cities = ['Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Diger'];

  static const districtsByCity = {
    'Istanbul': ['Uskudar', 'Kadikoy', 'Beyoglu', 'Besiktas', 'Diger'],
    'Ankara': ['Cankaya', 'Kecioren', 'Yenimahalle', 'Diger'],
    'Izmir': ['Konak', 'Bornova', 'Karsiyaka', 'Diger'],
    'Bursa': ['Osmangazi', 'Nilufer', 'Yildirim', 'Diger'],
    'Diger': ['Merkez'],
  };

  static const categories = [
    ListingCategory('Kadin', ['Giyim', 'Ayakkabi', 'Aksesuar']),
    ListingCategory('Erkek', ['Giyim', 'Ayakkabi', 'Aksesuar']),
    ListingCategory('Cocuk & Bebek', ['Giyim', 'Ayakkabi', 'Oyuncak']),
    ListingCategory('Elektronik', [
      'Telefon & Aksesuar',
      'Bilgisayar & Tablet',
      'Kucuk Ev Elektronigi',
    ]),
    ListingCategory('Ev & Yasam', [
      'Ev Esyalari',
      'Mutfak Gerecleri',
      'Dekorasyon',
    ]),
    ListingCategory('Kitap & Kirtasiye', ['Kitap', 'Kirtasiye']),
    ListingCategory('Diger', ['Diger']),
  ];

  static String typeLabel(String type) {
    switch (type) {
      case 'bagis':
        return 'Bağış İlanı';
      case 'ihtiyac':
        return 'İhtiyaç İlanı';
      case 'takas':
        return 'Takas İlanı';
      default:
        return type;
    }
  }
}
