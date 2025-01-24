import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard {
  static Widget gradientCardSample(
      String category,
      String description,
      String amount,
      String date,
      BuildContext context,
      VoidCallback onDelete,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00B4FC),
            Color(0xFF005BC5),
            Color(0xFF012677),
            Color(0xFF001449),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Main card content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Text(
                        category,
                        style: GoogleFonts.blackOpsOne(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        category,
                        style: GoogleFonts.blackOpsOne(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '₹$amount',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: GoogleFonts.tinos(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
              // const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.tinos(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 30,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Delete Expense'),
                      content: const Text(
                          'Are you sure you want to delete this expense?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            onDelete();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            onDelete();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
