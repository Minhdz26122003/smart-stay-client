// lib/core/widgets/app_network_image.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  String _formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    try {
      final baseUri = Uri.parse(AppConfig.baseUrl);
      final host = baseUri.host;
      if (host.isNotEmpty) {
        if (url.contains('storage.smartstay.local')) {
          return url.replaceAll('storage.smartstay.local', host);
        } else if (url.contains('localhost')) {
          return url.replaceAll('localhost', host);
        } else if (url.contains('127.0.0.1')) {
          return url.replaceAll('127.0.0.1', host);
        }
      }
    } catch (e) {
      debugPrint('Error formatting image URL: $e');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final formattedUrl = _formatImageUrl(imageUrl);

    if (formattedUrl.isEmpty) {
      return _buildPlaceholder(cs);
    }

    return Image.network(
      formattedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image load error ($formattedUrl): $error');
        return errorWidget ?? _buildPlaceholder(cs);
      },
    );
  }

  Widget _buildPlaceholder(ColorScheme cs) {
    return Container(
      width: width,
      height: height,
      color: cs.primaryContainer.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 32,
          color: cs.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
