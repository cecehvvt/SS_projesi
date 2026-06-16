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
        return 'Bagis Ilani';
      case 'ihtiyac':
        return 'Ihtiyac Ilani';
      case 'takas':
        return 'Takas Ilani';
      default:
        return type;
    }
  }
}
