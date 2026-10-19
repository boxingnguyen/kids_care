import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/providers/notifications_provider.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Giữ stream sự kiện geofence chạy khi bố/mẹ ở màn hình chính
    // (để bắn thông báo local), không rebuild màn hình khi có sự kiện.
    ref.listen(notificationsProvider, (_, _) {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Map Setup Card
            _buildMenuCard(
              context: context,
              title: 'Thiết lập bản đồ',
              description: 'Quản lý vùng an toàn và theo dõi vị trí',
              icon: Icons.map,
              onTap: () => context.go('/map'),
            ),
            const SizedBox(height: 16),
            // Notifications Card
            _buildMenuCard(
              context: context,
              title: 'Thông báo',
              description: 'Xem thông báo từ con yêu',
              icon: Icons.notifications,
              onTap: () => context.go('/parent'),
            ),
            const SizedBox(height: 16),
            // Todo Card
            _buildMenuCard(
              context: context,
              title: 'Danh sách việc cần làm',
              description: 'Quản lý công việc hàng ngày',
              icon: Icons.checklist,
              onTap: () => context.go('/parent-todo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: AppTheme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
