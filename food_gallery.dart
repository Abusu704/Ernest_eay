import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String description;
  final String image;

  const FoodItem({
    required this.name,
    required this.description,
    required this.image,
  });
}

/// Dishes shown to travellers. Images are bundled in lib/assets/images/.
/// No prices are shown: the live menu and prices are still to be confirmed
/// with the venue (see VenueInfo.unverifiedItems).
const List<FoodItem> kFoodItems = [
  FoodItem(
    name: 'Jollof Rice',
    description:
        "Ghana's celebrated spiced tomato rice, cooked in a rich pepper-and-tomato base.",
    image: 'lib/assets/images/jollof.jpeg',
  ),
  FoodItem(
    name: 'Banku & Tilapia',
    description:
        'Soft fermented corn-and-cassava dough served with grilled tilapia and hot pepper sauce.',
    image: 'lib/assets/images/banku.jpg',
  ),
  FoodItem(
    name: 'Waakye',
    description:
        'Rice and beans cooked together, served with sides such as stew, gari and egg.',
    image: 'lib/assets/images/waakye.jpg',
  ),
  FoodItem(
    name: 'Kelewele',
    description:
        'Spicy fried plantain cubes seasoned with ginger, pepper and warm spices.',
    image: 'lib/assets/images/kelewele.jpg',
  ),
];

class FoodGallery extends StatelessWidget {
  const FoodGallery({super.key});

  void _open(BuildContext context, FoodItem item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black87,
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: InteractiveViewer(
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(item.description),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('What we serve', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kFoodItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final item = kFoodItems[i];
                  return GestureDetector(
                    onTap: () => _open(context, item),
                    child: SizedBox(
                      width: 210,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 140,
                              width: 210,
                              child: Image.asset(
                                item.image,
                                fit: BoxFit.cover,
                                cacheWidth: 600,
                                errorBuilder: (_, __, ___) => const ColoredBox(
                                  color: Color(0xFF8B3A2B),
                                  child: Icon(Icons.restaurant, size: 48),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(item.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Expanded(
                            child: Text(
                              item.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Tap a dish to enlarge. Current menu & prices to be confirmed with the venue.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}