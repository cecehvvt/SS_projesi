import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/renkler.dart';
import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../utils/listing_taxonomy.dart';
import '../../widgets/listing_image.dart';

class IlanFormEkrani extends StatefulWidget {
  final String initialType;

  const IlanFormEkrani({super.key, required this.initialType});

  @override
  State<IlanFormEkrani> createState() => _IlanFormEkraniState();
}

class _IlanFormEkraniState extends State<IlanFormEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _service = const IlanService();
  final _picker = ImagePicker();

  late String _listingType = widget.initialType;
  String? _category = ListingTaxonomy.categories.first.name;
  String? _subCategory = ListingTaxonomy.categories.first.subCategories.first;
  String _city = ListingTaxonomy.cities.first;
  String _district =
      ListingTaxonomy.districtsByCity[ListingTaxonomy.cities.first]!.first;
  String? _condition;
  bool? _urgent;
  String _deliveryMethod = ListingTaxonomy.deliveryMethods.first;
  String _contactPreference = ListingTaxonomy.contactPreferences.first;
  final List<String> _imageDataUris = [];
  bool _saving = false;
  bool _picking = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.cream,
      appBar: AppBar(
        title: Text('${ListingTaxonomy.typeLabel(_listingType)} Oluştur'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(
              title: 'İlan tipi',
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'bagis',
                    icon: Icon(Icons.card_giftcard_outlined),
                    label: Text('Bağışlıyorum'),
                  ),
                  ButtonSegment(
                    value: 'ihtiyac',
                    icon: Icon(Icons.volunteer_activism_outlined),
                    label: Text('İhtiyacım Var'),
                  ),
                ],
                selected: {_listingType},
                onSelectionChanged: (value) =>
                    setState(() => _listingType = value.first),
              ),
            ),
            _section(
              title: 'Fotoğraflar',
              subtitle: 'En az 1, en fazla 5 fotoğraf ekleyin.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._imageDataUris.map(_selectedImage),
                      if (_imageDataUris.length < 5) _addPhotoButton(),
                    ],
                  ),
                  if (_picking)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
            ),
            _section(
              title: 'Temel bilgiler',
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    maxLength: 60,
                    decoration: const InputDecoration(labelText: 'Başlık *'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Başlık boş bırakılamaz.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    maxLength: 500,
                    decoration: const InputDecoration(labelText: 'Açıklama *'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Açıklama boş bırakılamaz.'
                        : null,
                  ),
                ],
              ),
            ),
            _section(
              title: 'Kategori',
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Kategori *'),
                    items: ListingTaxonomy.categories
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.name,
                            child: Text(
                              ListingTaxonomy.categoryLabel(item.name),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      final subCategories = _subCategoriesFor(value);
                      setState(() {
                        _category = value;
                        _subCategory = subCategories.first;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Kategori seçin.' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _subCategory,
                    decoration: const InputDecoration(
                      labelText: 'Alt kategori *',
                    ),
                    items: _subCategoriesFor(_category)
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(ListingTaxonomy.optionLabel(item)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _subCategory = value),
                    validator: (value) =>
                        value == null ? 'Alt kategori seçin.' : null,
                  ),
                ],
              ),
            ),
            _section(
              title: 'Konum ve teslim',
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _city,
                    decoration: const InputDecoration(labelText: 'Şehir *'),
                    items: ListingTaxonomy.cities
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(ListingTaxonomy.optionLabel(item)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      final districts =
                          ListingTaxonomy.districtsByCity[value] ??
                          const ['Merkez'];
                      setState(() {
                        _city = value;
                        _district = districts.first;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _district,
                    decoration: const InputDecoration(labelText: 'İlçe *'),
                    items:
                        (ListingTaxonomy.districtsByCity[_city] ??
                                const ['Merkez'])
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(ListingTaxonomy.optionLabel(item)),
                              ),
                            )
                            .toList(),
                    onChanged: (value) =>
                        setState(() => _district = value ?? _district),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _condition,
                    decoration: const InputDecoration(
                      labelText: 'Ürün durumu *',
                    ),
                    items: ListingTaxonomy.conditions
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(ListingTaxonomy.conditionLabel(item)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _condition = value),
                    validator: (value) =>
                        value == null ? 'Ürün durumunu seçin.' : null,
                  ),
                  if (_listingType == 'ihtiyac') ...[
                    const SizedBox(height: 12),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          icon: Icon(Icons.priority_high),
                          label: Text('Acil'),
                        ),
                        ButtonSegment(
                          value: false,
                          icon: Icon(Icons.schedule),
                          label: Text('Normal'),
                        ),
                      ],
                      selected: _urgent == null ? const {} : {_urgent!},
                      emptySelectionAllowed: true,
                      onSelectionChanged: (selection) => setState(
                        () => _urgent = selection.isEmpty
                            ? null
                            : selection.first,
                      ),
                    ),
                    if (_urgent == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Aciliyet durumunu seçin.',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _deliveryMethod,
                    decoration: const InputDecoration(
                      labelText: 'Teslim yöntemi *',
                    ),
                    items: ListingTaxonomy.deliveryMethods
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(ListingTaxonomy.optionLabel(item)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(
                      () => _deliveryMethod = value ?? _deliveryMethod,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _contactPreference,
                    decoration: const InputDecoration(
                      labelText: 'İletişim tercihi *',
                    ),
                    items: ListingTaxonomy.contactPreferences
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(ListingTaxonomy.optionLabel(item)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(
                      () => _contactPreference = value ?? _contactPreference,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(_saving ? 'Yayınlanıyor...' : 'İlanı Yayınla'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Renkler.paper,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Renkler.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Renkler.terracottaDark,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Renkler.inkSoft, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _selectedImage(String source) {
    return Stack(
      children: [
        ListingImage(
          source: source,
          width: 76,
          height: 76,
          borderRadius: BorderRadius.circular(16),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: IconButton(
            onPressed: () => setState(() => _imageDataUris.remove(source)),
            icon: const Icon(Icons.cancel, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _addPhotoButton() {
    return PopupMenuButton<ImageSource>(
      onSelected: _pickImage,
      itemBuilder: (context) => const [
        PopupMenuItem(value: ImageSource.gallery, child: Text('Galeriden seç')),
        PopupMenuItem(value: ImageSource.camera, child: Text('Kamera')),
      ],
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: Renkler.cream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Renkler.terracotta, width: 1.5),
        ),
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: Renkler.terracottaDark,
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_imageDataUris.length >= 5) return;
    setState(() => _picking = true);
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 65,
        maxWidth: 1200,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      final dataUri = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      setState(() => _imageDataUris.add(dataUri));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fotoğraf seçilemedi. Lütfen tekrar deneyin.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _save() async {
    if (_imageDataUris.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir fotoğraf ekleyin.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_listingType == 'ihtiyac' && _urgent == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Aciliyet durumunu seçin.')));
      return;
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final listing = AppListing(
        id: '',
        ownerId: 'user-1',
        ownerName: 'Vesta Kullanıcısı',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        listingType: _listingType,
        category: _category!,
        subCategory: _subCategory!,
        city: _city,
        district: _district,
        condition: _condition!,
        deliveryMethod: _deliveryMethod,
        contactPreference: _contactPreference,
        desiredSwapItem: null,
        imageUrls: List<String>.from(_imageDataUris),
        status: 'active',
        createdAt: now,
        updatedAt: now,
        urgent: _listingType == 'ihtiyac' ? _urgent! : false,
      );
      await _service.createListing(listing);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlan başarıyla oluşturuldu.')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/ana_sayfa',
        (route) => false,
      );
    } on IlanServiceException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İlan kaydedilemedi. Lütfen tekrar deneyin.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<String> _subCategoriesFor(String? category) {
    return ListingTaxonomy.categories
        .firstWhere(
          (item) => item.name == category,
          orElse: () => ListingTaxonomy.categories.first,
        )
        .subCategories;
  }
}
