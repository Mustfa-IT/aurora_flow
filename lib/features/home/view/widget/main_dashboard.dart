import 'package:flutter/material.dart';
import 'package:task_app/core/common/app-design.dart';

// =============================================
// Main Dashboard Widget
// =============================================
// يعرض شاشة الترحيب والوقت والاقتباس التحفيزي مع خلفية بتدرج ألوان الشفق القطبي
class MainDashboard extends StatelessWidget {
  final String userName;
  final String timeString;
  final String greeting;

  const MainDashboard({
    required this.userName,
    required this.timeString,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true, // لإظهار مؤشر التمرير دائمًا
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // التمرير الأفقي
        controller: scrollController,
        child: Container(
          // نحدد عرضًا أكبر من عرض الشاشة لظهور التمرير
          width: MediaQuery.of(context).size.width + 450,
          // نجعل الخلفية شفافة حتى يظهر تدرج القسم الأيمن
          color: Colors.transparent,
          padding: AppDesign.mainPadding,
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              // الحاوية التي تحتوي على النصوص
              Container(
                width: 350, // عرض ثابت للحاوية بحيث لا تتجاوز النصوص هذا العرض
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 200),
                    // نص الترحيب بخط عريض ولون أبيض
                    Text(
                      '$greeting, $userName',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 8),
                    // عرض الوقت بخط كبير ولون أبيض مع تقليص الحجم إذا دعت الحاجة
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 90,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 24),
                    // قسم الاقتباس التحفيزي منسق داخل الحاوية الشفافة
                    _buildInspirationalQuote(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // عرض اقتباس تحفيزي بنص منسق
  Widget _buildInspirationalQuote() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 20,
          color: AppDesign.secondaryText,
          fontStyle: FontStyle.italic,
          height: 2,
        ),
        children: [
          TextSpan(
              text:
                  '"I am learning every day to allow the space between where I am'),
          TextSpan(
              text:
                  'and where I want to be to inspire me and not terrify me."\n'),
          TextSpan(
            text: 'Let’s go',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ],
      ),
    );
  }
}
