import 'package:flutter/material.dart';
import 'package:task_app/features/home/view/widget/app-design.dart';

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
    return Container(
      // نجعل الخلفية شفافة حتى يظهر تدرج القسم الأيمن
      color: Colors.transparent,
      padding: AppDesign.mainPadding,
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نص الترحيب بخط عريض ولون أبيض
          Text(
            '$greeting, $userName',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          // عرض الوقت بخط كبير ولون أبيض
          Text(
            timeString,
            style: TextStyle(
              fontSize: 90,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          _buildInspirationalQuote(),
        ],
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
                  '"I am learning every day to allow the space between where I am\n'),
          TextSpan(
              text:
                  'and where I want to be to inspire me and not terrify me."\n\n'),
          TextSpan(
            text: 'Lets go',
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ],
      ),
    );
  }
}