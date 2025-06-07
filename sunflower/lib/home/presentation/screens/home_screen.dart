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
        title: 'Математика подсолнуха',
        isDarkTheme: appModel.isDarkTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Спирали Фибоначчи в соцветиях подсолнуха — это не просто красивая случайность, а проявление фундаментальных математических закономерностей, '
              'которые природа оттачивала миллионы лет эволюции. Удивительно, но растения "знают" математику лучше многих инженеров — их семена упакованы '
              'с максимальной эффективностью, которую человечество смогло объяснить только с помощью сложных вычислений.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              theme,
              'Золотое сечение в каждом семечке',
              'В основе модели лежит золотое сечение (φ ≈ 1.618) — иррациональное число, которое античные математики считали божественной пропорцией. '
                  'Когда каждое новое семя появляется в центре соцветия, оно смещается на угол 360°/φ² ≈ 137.5° относительно предыдущего. Этот "золотой угол" '
                  'максимально увеличивает расстояние между соседними семенами, предотвращая их наложение.\n\n'
                  'Математически положение n-го семечка описывается формулой:\n\n'
                  'r(n) = √n exp 2πniδ |n = 1, 2, 3, ..., \n   где δ = g², \n   g - золотое сечение, \n\n'
                  'где r — расстояние от центра, δ — угол поворота. Такая спиральная структура обеспечивает оптимальное использование пространства — '
                  'семена, получают равный доступ к солнечному свету и питательным веществам.',
            ),
            _buildSection(
              theme,
              'Эффективность природной упаковки',
              'Ученые измеряют эффективность упаковки η (эта) — показатель того, насколько плотно можно разместить объекты без перекрытий. '
                  'У подсолнуха η ≈ 0.82, что близко к теоретическому максимуму для спиральных структур. Для сравнения:\n\n'
                  '• Шестиугольная решетка (как в пчелиных сотах): η ≈ 1.15\n'
                  '• Квадратная решетка: η ≈ 0.79\n'
                  '• Случайное распределение: η ≈ 0.55\n\n'
                  'Природа выбрала именно спиральную организацию не случайно — она позволяет постепенно добавлять новые семена без перестройки всей структуры, '
                  'что критически важно для растущего растения. Каждое новое семя просто "знает" куда поместиться благодаря фиксированному углу расхождения.',
            ),
            Center(
              child: GestureDetector(
                onTap: () =>
                    _showFullScreenImage(context, 'assets/sunflower.png'),
                child: Hero(
                  tag: 'sunflower-pattern',
                  child: Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/sunflower.png',
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
            ),
            const SizedBox(height: 20),
            _buildSection(
              theme,
              'Как программа решает математическую задачу',
              'Программная реализация модели показывает, как простое правило приводит к сложной структуре:\n\n'
                  'final goldenAngle = 137.5 * pi / 180; // Угол Фибоначчи в радианах\n'
                  'final points = <Offset>[];\n\n'
                  'for (int i = 0; i < nSeeds; i++) {\n'
                  '  final radius = sqrt(i) * 2;                  \t // Расстояние от центра\n'
                  '  final angle = i * goldenAngle;        \t// Угол поворота\n'
                  '  final x = radius * cos(angle);        \t// Декартова координата x\n'
                  '  final y = radius * sin(angle);       \t// Декартова координата y\n'
                  '  points.add(Offset(x, y));            \t// Добавление точки\n'
                  '} \n\n'
                  'Этот код генерирует идеальную филлотаксисную решетку — ту самую, что используют подсолнухи, сосновые шишки и кактусы. '
                  'Интересно, что последовательность Фибоначчи (1, 1, 2, 3, 5, 8, 13...) проявляется в количестве спиралей — обычно их 34 и 55, '
                  'реже 89 и 144 — все это числа Фибоначчи.',
              isCode: true,
            ),
            _buildSection(
              theme,
              'Эксперименты с природными алгоритмами',
              'Что если немного изменить угол? Мы можем смоделировать альтернативные сценарии:',
            ),
            _buildAngleComparisonCard(
              context,
              angle: '137.45° (21/55)',
              description:
                  'Здесь проявляются свойства рациональных чисел. Поскольку 21/55 — дробь, спирали со временем "синхронизируются", '
                  'образуя четкие радиальные лучи. Вблизи центра упаковка хорошая, но на периферии семена выстраиваются в линии, '
                  'оставляя пустоты — как спицы в колесе. Эффективность падает до нуля на больших расстояниях.',
              imagePath: 'assets/sunflower_1.jpg',
              efficiency: 'η → 0',
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 16),
            _buildAngleComparisonCard(
              context,
              angle: '137.54° ((155+√13)/414)',
              description:
                  'Этот "почти золотой" угол демонстрирует фрактальную природу филлотаксиса. Сначала проявляются 13 спиралей, '
                  'затем 47, потом 154 — словно матрешка из паттернов. Эффективность лучше, но не идеальна (η ≈ 0.56). '
                  'Интересно, что √13 в формуле добавляет иррациональности, предотвращая полную синхронизацию.',
              imagePath: 'assets/sunflower_2.jpg',
              efficiency: 'η ≈ 0.56',
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 16),
            _buildAngleComparisonCard(
              context,
              angle: '137.508° (Золотой угол)',
              description:
                  'Лучший вариант по упаковке. Иррациональность φ² гарантирует, что ни одно семя никогда не окажется '
                  'точно над другим, как бы далеко ни рос цветок. Спирали плавно "убегают" друг от друга, создавая гипнотический двойной узор '
                  'Здесь η достигает максимума ≈ 0.8169.',
              imagePath: 'assets/sunflower_3.jpg',
              efficiency: 'η ≈ 0.8169',
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 24),
            Text(
              'Формула эффективности: η = (5 - 4cos(6πφ²))/π ≈ 0.8169\n'
              'где φ = (√5 + 1)/2 — золотое сечение',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            _buildSection(
              theme,
              'От цветов до галактик',
              'Этот паттерн — не просто курьез ботаники. Он встречается в:\n\n'
                  '🌿 Листьях (филлотаксис) — углы 137.5° минимизируют затенение\n'
                  '🍍 Плодах ананаса — обычно 8 и 13 спиралей\n'
                  '🌪️ Спиральных галактиках — золотой угол в распределении рукавов\n'
                  '🏛️ Архитектуре — от Парфенона до небоскребов Нормана Фостера\n\n'
                  'В 2023 году физики ETH Zurich обнаружили, что аналогичные структуры самопроизвольно образуются в квантовых системах при определенных условиях — '
                  'возможно, это универсальный принцип организации материи.',
            ),
            const SizedBox(height: 20),
            Divider(color: theme.dividerColor),
            const SizedBox(height: 20),
            _buildSection(
              theme,
              'Почему это важно?',
              '1. 🌻 Биомиметика: инженеры копируют эти паттерны в солнечных батареях и композитных материалах\n'
                  '2. 🧮 Математика: задача упаковки имеет приложения от криптографии до нанотехнологий\n'
                  '3. 🎨 Искусство: от Дали до современных генеративных художников\n\n'
                  'Как заметил математик Иэн Стюарт: "Природа — не инженер, она слепой часовщик, но ее "метод тыка" нашел решения, '
                  'которые превосходят наши самые изощренные расчеты". Подсолнух — живое доказательство того, что красота и эффективность '
                  'идут рука об руку в мире математических закономерностей.',
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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: isCode
                ? theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'RobotoMono',
                    height: 1.6,
                    fontSize: 14,
                  )
                : theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
          ),
        ),
        const SizedBox(height: 24),
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
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showFullScreenImage(context, imagePath),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      angle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(efficiency),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Hero(
                  tag: imagePath,
                  child: Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
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
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 40,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Паттерн подсолнуха',
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
              minScale: 0.1,
              maxScale: 5.0,
              child: Hero(
                tag: imagePath,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
