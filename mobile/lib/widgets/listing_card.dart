import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/renkler.dart';
import '../models/app_listing.dart';
import '../utils/listing_taxonomy.dart';
import 'listing_image.dart';

class ListingCard extends StatelessWidget {
  final AppListing listing;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Renkler.paper,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Renkler.line),
          boxShadow: [
            BoxShadow(
              color: Renkler.ink.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListingImage(
                      source: listing.firstImage,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                  ),
                  Positioned(top: 8, left: 8, child: _Tag(listing: listing)),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                      color: Renkler.paper.withValues(alpha: 0.94),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onFavoriteTap,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            listing.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 19,
                            color: listing.favorite
                                ? Renkler.terracotta
                                : Renkler.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 12, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fraunces(
                      color: Renkler.ink,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ListingTaxonomy.categoryLabel(listing.category)} / '
                    '${ListingTaxonomy.optionLabel(listing.subCategory)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Renkler.inkSoft,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Renkler.inkSoft,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          ListingTaxonomy.locationLabel(listing.location),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Renkler.inkSoft,
                            fontSize: 11,
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
    );
  }
}

class _Tag extends StatelessWidget {
  final AppListing listing;

  const _Tag({required this.listing});

  @override
  Widget build(BuildContext context) {
    final isDonation = listing.listingType == 'bagis';
    final background = isDonation ? Renkler.olive : Renkler.terracotta;
    final text = switch (listing.listingType) {
      'bagis' => 'BAĞIŞ',
      'takas' => 'TAKAS',
      _ => 'İHTİYAÇ',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Renkler.paper,
          fontSize: 9,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
