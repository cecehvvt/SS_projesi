import 'package:flutter/material.dart';

import '../../utils/listing_taxonomy.dart';

enum FiltreTuru { ihtiyac, bagis }

class ListingFilters {
  final String? category;
  final String? condition;
  final bool? urgent;

  const ListingFilters({this.category, this.condition, this.urgent});

  bool get active => category != null || condition != null || urgent != null;
}

class FiltreEkrani extends StatefulWidget {
  final FiltreTuru tur;
  final ListingFilters initialFilters;

  const FiltreEkrani({
    super.key,
    this.tur = FiltreTuru.bagis,
    this.initialFilters = const ListingFilters(),
  });

  const FiltreEkrani.ihtiyac({
    super.key,
    this.initialFilters = const ListingFilters(),
  }) : tur = FiltreTuru.ihtiyac;

  const FiltreEkrani.bagis({
    super.key,
    this.initialFilters = const ListingFilters(),
  }) : tur = FiltreTuru.bagis;

  @override
  State<FiltreEkrani> createState() => _FiltreEkraniState();
}

class _FiltreEkraniState extends State<FiltreEkrani> {
  late String? _category = widget.initialFilters.category;
  late String? _condition = widget.initialFilters.condition;
  late bool? _urgent = widget.initialFilters.urgent;

  bool get _isNeed => widget.tur == FiltreTuru.ihtiyac;

  @override
  Widget build(BuildContext context) {
    final color = _isNeed ? const Color(0xFFD46A3A) : const Color(0xFF2E7D32);
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  Expanded(
                    child: Text(
                      _isNeed ? 'İhtiyaç Filtreleri' : 'Bağış Filtreleri',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _category = null;
                      _condition = null;
                      _urgent = null;
                    }),
                    child: Text('Temizle', style: TextStyle(color: color)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _choiceSection(
                    title: _isNeed ? 'İhtiyaç Kategorisi' : 'Ürün Türü',
                    selected: _category,
                    options: ListingTaxonomy.categories
                        .map((category) => category.name)
                        .toList(),
                    labelFor: ListingTaxonomy.categoryLabel,
                    color: color,
                    onSelected: (value) => setState(
                      () => _category = _category == value ? null : value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _choiceSection(
                    title: 'Ürünün Durumu',
                    selected: _condition,
                    options: ListingTaxonomy.conditions,
                    labelFor: ListingTaxonomy.conditionLabel,
                    color: color,
                    onSelected: (value) => setState(
                      () => _condition = _condition == value ? null : value,
                    ),
                  ),
                  if (_isNeed) ...[
                    const SizedBox(height: 24),
                    _choiceSection(
                      title: 'Aciliyet Durumu',
                      selected: _urgent == null
                          ? null
                          : (_urgent! ? 'urgent' : 'normal'),
                      options: const ['urgent', 'normal'],
                      labelFor: (value) =>
                          value == 'urgent' ? 'Acil' : 'Normal',
                      color: color,
                      onSelected: (value) => setState(() {
                        final selected = value == 'urgent';
                        _urgent = _urgent == selected ? null : selected;
                      }),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: color,
                ),
                onPressed: () => Navigator.pop(
                  context,
                  ListingFilters(
                    category: _category,
                    condition: _condition,
                    urgent: _isNeed ? _urgent : null,
                  ),
                ),
                icon: const Icon(Icons.filter_list),
                label: const Text('Filtreleri Uygula'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceSection({
    required String title,
    required String? selected,
    required List<String> options,
    required Color color,
    required ValueChanged<String> onSelected,
    String Function(String value)? labelFor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return ChoiceChip(
              label: Text(labelFor?.call(option) ?? option),
              selected: isSelected,
              selectedColor: color.withValues(alpha: 0.16),
              labelStyle: TextStyle(
                color: isSelected ? color : Colors.black87,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
              side: BorderSide(color: isSelected ? color : Colors.black12),
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
