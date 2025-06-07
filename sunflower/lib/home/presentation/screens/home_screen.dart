import 'package:flutter/material.dart';
import 'package:sunflower/app/state/app_model_provider.dart';
import 'package:sunflower/core/global_widgets/gradient_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appModel = AppModelProvider.of(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Подсолнух',
        isDarkTheme: appModel.isDarkTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Исследование математической модели расположения семян в соцветии подсолнуха, основанной на спирали Фибоначчи.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              theme,
              'Математическая модель',
              'Модель соцветия подсолнуха размещает семена в точках первичной спирали роста:\n\n'
                  '√n exp(2πniδ), где n = 1, 2, 3, ..., δ = g², а g - золотое сечение (g = ½(√5 - 1)).\n\n'
                  'Угол расхождения между семенами равен 137.5°, что связано с золотым сечением и обеспечивает наиболее эффективную упаковку семян.',
            ),
            _buildSection(
              theme,
              'Эффективность упаковки',
              '• Эффективность упаковки η для спирали Фибоначчи ≈ 0.82\n'
                  '• Для шестиугольной решётки η ≈ 1.15\n'
                  '• При других углах расхождения эффективность значительно ниже\n\n'
                  'Оптимальный угол 137.5° обеспечивает равномерное распределение семян без плотных скоплений или разреженных областей.',
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, 'assets/resize.jpg'),
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/resize.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.auto_awesome,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              theme,
              'Программная реализация',
              'Алгоритм для визуализации расположения семян:\n\n'
                  'final goldenAngle = 137.5 * pi / 180; // Угол Фибоначчи в радианах\n'
                  'final points = <Offset>[];\n\n'
                  'for (int i = 0; i < nSeeds; i++) {\n'
                  '  final radius = sqrt(i) * 2;                  \t // Расстояние от центра\n'
                  '  final angle = i * goldenAngle;        \t// Угол поворота\n'
                  '  final x = radius * cos(angle);        \t// Декартова координата x\n'
                  '  final y = radius * sin(angle);       \t// Декартова координата y\n'
                  '  points.add(Offset(x, y));            \t// Добавление точки\n'
                  '}',
              isCode: true,
            ),

            // Блок с разными углами расхождения
            _buildSection(
              theme,
              'Сравнение углов расхождения',
              'Эффективность упаковки семян сильно зависит от выбранного угла расхождения:',
            ),
            _buildAngleComparisonCard(
              context,
              angle: '21/55 (≈137.45°)',
              description:
                  'Центр равномерно покрыт, но дальше семена концентрируются на 55-парастихах. '
                  'Соседние семена на спицах становятся сколь угодно близкими, η ≈ 0',
              imagePath: 'assets/sunflower_1.jpg',
              efficiency: 'η ≈ 0',
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 16),
            _buildAngleComparisonCard(
              context,
              angle: '(155 + √13)/414 (≈137.51°)',
              description:
                  'Семена накапливаются сначала на 13-парастихах, затем на 47-парастихах. '
                  'Семена никогда не приближаются сколь угодно близко, но η мала',
              imagePath: 'assets/sunflower_2.jpg',
              efficiency: 'η < 0.56',
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 16),
            _buildAngleComparisonCard(
              context,
              angle: 'Золотой угол (≈137.5°)',
              description:
                  'Семена равномерно покрывают весь диск без близких соседей. '
                  'Наибольшая эффективность упаковки среди спиральных моделей',
              imagePath: 'assets/sunflower_3.jpg',
              efficiency: 'η ≈ 0.8169',
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 24),
            Text(
              'Формула эффективности: η = (5 - 4 cos(6πg²))/π, где g - золотое сечение',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),

            _buildSection(
              theme,
              'Применение в природе и архитектуре',
              '1. Природа:\n'
                  '   • Сосновые шишки и ананасы: семена расположены по спиралям Фибоначчи (обычно 8 и 13 или 5 и 8)\n'
                  '   • Расположение листьев на стебле (филлотаксис): углы, кратные 137.5°, минимизируют затенение\n\n'
                  '2. Архитектура:\n'
                  '   • Парфенон в Афинах: пропорции фасада соответствуют золотому сечению\n'
                  '   • Здание Сиднейской оперы: использует спиральные формы для устойчивости и эстетики',
            ),
            const SizedBox(height: 20),
            Divider(color: theme.dividerColor),
            const SizedBox(height: 20),
            _buildSection(
              theme,
              'Выводы',
              '1. Угол 137.5° обеспечивает оптимальную упаковку семян в подсолнухе\n'
                  '2. Аналогичные паттерны встречаются в других природных объектах и искусственных структурах\n'
                  '3. Разработанное приложение может быть использовано для образовательных целей и исследований в области биоматематики',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content,
      {bool isCode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: isCode
                ? theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'RobotoMono',
                    height: 1.5,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAngleComparisonCard(
    BuildContext context, {
    required String angle,
    required String description,
    required String imagePath,
    required String efficiency,
    required double screenWidth,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  angle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(efficiency),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, imagePath),
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Изображение не найдено',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
