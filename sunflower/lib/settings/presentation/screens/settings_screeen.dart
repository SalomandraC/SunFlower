import 'package:flutter/material.dart';
import 'package:sunflower/app/state/app_model_provider.dart';
import 'package:sunflower/core/global_widgets/gradient_appbar.dart';
import 'package:sunflower/settings/presentation/components/small_switch_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool biometricEnabled = false;

  final Map<String, String> languageOptions = {
    'ru': 'Русский',
    'en': 'English',
  };

  @override
  Widget build(BuildContext context) {
    final appModel = AppModelProvider.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: _getLocalizedTitle(appModel.languageCode),
        isDarkTheme: appModel.isDarkTheme,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(
              theme, _getLocalizedString('about_app', appModel.languageCode)),
          _buildSettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(
                  _getLocalizedString('app_version', appModel.languageCode),
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  "1.0.0",
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(
                  _getLocalizedString('help', appModel.languageCode),
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpScreen(
                        languageCode: appModel.languageCode,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildQrCodeSection(context, appModel.languageCode),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection(BuildContext context, String languageCode) {
    final isRussian = languageCode == 'ru';
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildSectionHeader(theme,
            isRussian ? 'Скачать мобильное приложение' : 'Download mobile App'),
        _buildSettingsCard(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/frame.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () => _launchDownloadUrl(context, languageCode),
                child: Text(
                  isRussian ? 'Скачать приложение' : 'Download the app',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchDownloadUrl(
      BuildContext context, String languageCode) async {
    const url = 'https://github.com/SalomandraC/SunFlower';
    final uri = Uri.parse(url);
    try {
      if (!await canLaunchUrl(uri)) {
        _showUrlError(context, languageCode);
        return;
      }

      await launchUrl(
        uri,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } catch (e) {
      _showUrlError(context, languageCode);
      debugPrint('Error launching URL: $e');
    }
  }

  void _showUrlError(BuildContext context, String languageCode) {
    final isRussian = languageCode == 'ru';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isRussian
            ? 'Не удалось открыть ссылку'
            : 'Could not open the link'),
      ),
    );
  }

  String _getLocalizedTitle(String languageCode) {
    return languageCode == 'ru' ? 'Настройки' : 'Settings';
  }

  String _getLocalizedString(String key, String languageCode) {
    final ruTranslations = {
      'basic_settings': 'Основные',
      'dark_theme': 'Тема',
      'language': 'Язык',
      'choose_language': 'Выберите язык интерфейса',
      'notifications': 'Уведомления',
      'biometric_auth': 'Биометрическая аутентификация',
      'about_app': 'О приложении',
      'app_version': 'Версия приложения',
      'help': 'Помощь',
    };

    final enTranslations = {
      'basic_settings': 'Basic',
      'dark_theme': 'Theme',
      'language': 'Language',
      'choose_language': 'Choose interface language',
      'notifications': 'Notifications',
      'biometric_auth': 'Biometric authentication',
      'about_app': 'About app',
      'app_version': 'App version',
      'help': 'Help',
    };

    return languageCode == 'ru'
        ? ruTranslations[key] ?? key
        : enTranslations[key] ?? key;
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}

class HelpScreen extends StatelessWidget {
  final String languageCode;

  const HelpScreen({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRussian = languageCode == 'ru';

    final List<HelpResource> resources = [
      HelpResource(
        title: isRussian
            ? 'Эффективность упаковки в подсолнухе'
            : 'Sunflower Packing Efficiency',
        url:
            'https://www.researchgate.net/publication/242991835_Packing_efficiency_in_sunflower_heads',
        description: isRussian
            ? 'Исследование расположения семечек в подсолнухе'
            : 'Research on sunflower seed arrangement',
      ),
      HelpResource(
        title: isRussian
            ? 'Руководство по математике подсолнуха'
            : 'Sunflower Math Guide',
        assetPath: 'assets/sunflower_math.pdf',
        description: isRussian
            ? 'Подробное руководство по математическим моделям'
            : 'Detailed math models guide',
        isPdf: true,
      ),
    ];

    return Scaffold(
      appBar: GradientAppBar(
        title: _getLocalizedTitle(),
        isDarkTheme: theme.brightness == Brightness.dark,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(resource.isPdf ? Icons.picture_as_pdf : Icons.link),
              title: Text(resource.title, style: theme.textTheme.bodyMedium),
              subtitle:
                  Text(resource.description, style: theme.textTheme.bodySmall),
              trailing: const Icon(Icons.open_in_new),
              onTap: () {
                if (resource.isPdf) {
                  _openPdf(context, resource);
                } else {
                  _launchUrl(resource.url!, context);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openPdf(BuildContext context, HelpResource resource) async {
    if (resource.assetPath != null) {
      try {
        // Для локального файла из assets
        final file = await _getLocalFile(resource.assetPath!);
        if (file == null) {
          _showError(context,
              isRussian: languageCode == 'ru', message: 'Файл не найден');
          return;
        }

        // Открываем PDF во внешнем приложении
        await OpenFile.open(file.path);
      } catch (e) {
        _showError(context,
            isRussian: languageCode == 'ru', message: 'Ошибка открытия файла');
        debugPrint('Error opening PDF: $e');
      }
    }
  }

  Future<File?> _getLocalFile(String assetPath) async {
    try {
      final dir = await getTemporaryDirectory();
      final filename = assetPath.split('/').last;
      final file = File('${dir.path}/$filename');

      if (!await file.exists()) {
        final data = await rootBundle.load(assetPath);
        await file.writeAsBytes(data.buffer.asUint8List());
      }

      return file;
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      return null;
    }
  }

  String _getLocalizedTitle() {
    return languageCode == 'ru' ? 'Помощь' : 'Help';
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      if (!await canLaunchUrl(uri)) {
        _showError(context, isRussian: languageCode == 'ru');
        return;
      }

      await launchUrl(
        uri,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } catch (e) {
      _showError(context, isRussian: languageCode == 'ru');
      debugPrint('Error launching URL: $e');
    }
  }

  void _showError(BuildContext context,
      {required bool isRussian, String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ??
            (isRussian ? 'Не удалось открыть ссылку' : 'Could not launch URL')),
      ),
    );
  }
}

class HelpResource {
  final String title;
  final String? url;
  final String? assetPath;
  final String description;
  final bool isPdf;

  const HelpResource({
    required this.title,
    this.url,
    this.assetPath,
    required this.description,
    this.isPdf = false,
  });
}
