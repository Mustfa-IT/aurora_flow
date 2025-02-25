import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_app/core/common/arrow-popup-menu-shape.dart';
import 'package:task_app/features/home/view/widget/hoverIcon-button.dart';

/// الصفحة الرئيسية لتعديل الحساب
class AccountEditPage extends StatefulWidget {
  const AccountEditPage({Key? key}) : super(key: key);

  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage>
    with TickerProviderStateMixin {
  // متغير العد التنازلي المستخدم لتعطيل زر تغيير كلمة المرور مؤقتاً
  int countdown = 0;
  // تايمر لتحديث قيمة العد التنازلي
  Timer? _timer;
  // متحكم نص لاسم المستخدم مع قيمة افتراضية "Existing Username"
  final TextEditingController _usernameController =
      TextEditingController(text: "Existing Username");
  // متحكم نص لحقل البريد الإلكتروني
  final TextEditingController _emailController = TextEditingController();
  // متغير لتحديد عرض حقل البريد الإلكتروني
  bool _showEmailField = false;

  // مفتاح للحصول على موقع أيقونة تعديل الصورة (يستخدم لتحديد موقعها على الشاشة)
  final GlobalKey _editIconKey = GlobalKey();

  // متحكمات الرسوم المتحركة للبطاقتين (Edit Account و My Account)
  late AnimationController _leftCardController;
  late Animation<Offset> _leftCardAnimation;
  late AnimationController _rightCardController;
  late Animation<Offset> _rightCardAnimation;

  @override
  void initState() {
    super.initState();
    // تهيئة متحكم الرسوم المتحركة للبطاقة اليسرى (Edit Account)
    _leftCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _leftCardAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _leftCardController,
      curve: Curves.easeOut,
    ));
    // تهيئة متحكم الرسوم المتحركة للبطاقة اليمنى (My Account)
    _rightCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _rightCardAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _rightCardController,
      curve: Curves.easeOut,
    ));

    // بدء حركة الانزلاق للبطاقتين بعد بناء الواجهة لضمان ظهور الرسوم المتحركة بسلاسة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _leftCardController.forward();
      _rightCardController.forward();
    });
  }

  @override
  void dispose() {
    // إيقاف التايمر وتحرير الموارد لتجنب تسرب الذاكرة
    _timer?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _leftCardController.dispose();
    _rightCardController.dispose();
    super.dispose();
  }

  /// دالة بدء العد التنازلي لمدة 60 ثانية وتعطيل زر تغيير كلمة المرور مؤقتاً.
  /// ملاحظة للمبرمج الخلفي: 
  /// هنا يمكن ربط وظيفة إرسال معلومات البريد الإلكتروني عبر استدعاء API من الـ backend.
  void startCountdown() {
    if (countdown > 0) return;
    setState(() {
      countdown = 60;
      _showEmailField = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
    // عرض رسالة تأكيد إرسال المعلومات عبر بريد إلكتروني
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information Sent'),
          content: const Text(
            "The information has been sent to your email, please check it.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// دالة عرض خيارات الصورة عند الضغط على أيقونة التعديل.
  /// توضح هذه الدالة كيفية الحصول على موقع الأيقونة وعرض قائمة منسدلة مخصصة.
  /// ملاحظة للمبرمج الخلفي: يمكن ربط إجراءات حذف أو تحديث الصورة بعمليات API خاصة بإدارة الصور في الـ backend.
  Future<void> _showImageOptions() async {
    final RenderBox renderBox =
        _editIconKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height,
      offset.dx + size.width,
      offset.dy,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      shape: const ArrowPopupMenuShape(), // الشكل المخصص مع النتوء
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'delete',
          child: InkWell(
            onTap: () {
              // عند النقر على زر حذف الصورة، يتم إغلاق القائمة مع القيمة 'delete'
              Navigator.pop(context, 'delete');
            },
            child: Row(
              children: const [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text("Delete Image",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'update',
          child: InkWell(
            onTap: () {
              // عند النقر على زر تحديث الصورة، يتم إغلاق القائمة مع القيمة 'update'
              Navigator.pop(context, 'update');
            },
            child: Row(
              children: const [
                Icon(Icons.image, color: Colors.blue),
                SizedBox(width: 8),
                Text("Update Image",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );

    // التحقق من القيمة المحددة وتنفيذ الإجراء المناسب
    if (selected != null) {
      if (selected == 'delete') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image deleted"),
            backgroundColor: Colors.indigoAccent,
          ),
        );
      } else if (selected == 'update') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Update image clicked"),
            backgroundColor: Colors.indigoAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // بناء واجهة الصفحة الرئيسية مع دعم التصميم المتجاوب
    return Scaffold(
      // الخلفية عبارة عن صورة (يمكن تغييرها حسب الحاجة)
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // لون الأيقونات
          size: 40, // حجم الأيقونات
        ),
        title: const Text(
          "Your Profile",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 27, 46, 55),
              Color.fromARGB(255, 27, 46, 55)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // التحقق من حجم الشاشة لتحديد تصميم العرض المناسب (للأجهزة الصغيرة والكبيرة)
            if (constraints.maxWidth < 800) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: kToolbarHeight + 32, left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    // بطاقة تعديل الحساب مع حركة انزلاق من اليسار
                    SlideTransition(
                      position: _leftCardAnimation,
                      child: buildEditAccountCard(),
                    ),
                    const SizedBox(height: 24),
                    // بطاقة عرض معلومات الحساب مع حركة انزلاق من اليمين
                    SlideTransition(
                      position: _rightCardAnimation,
                      child: buildMyAccountCard(),
                    ),
                  ],
                ),
              );
            } else {
              // تخطيط لشاشات الويب أو الشاشات الأكبر
              return Padding(
                padding: const EdgeInsets.only(
                    top: kToolbarHeight + 32, left: 32, right: 32, bottom: 32),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SlideTransition(
                            position: _leftCardAnimation,
                            child: buildEditAccountCard(),
                          ),
                        ),
                        Container(
                          width: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.blue,
                        ),
                        Expanded(
                          child: SlideTransition(
                            position: _rightCardAnimation,
                            child: buildMyAccountCard(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// دالة بناء بطاقة "Edit Account" التي تحتوي على:
  /// - تعديل صورة الحساب مع أيقونة لتحديد الخيارات (حذف أو تحديث الصورة)
  /// - حقل لتحديث اسم المستخدم مع زر تأكيد (يمكن ربطه بوظيفة تحديث اسم المستخدم في الـ backend)
  /// - قسم لتحديث البريد الإلكتروني وإرسال طلب لتغيير كلمة المرور
  Widget buildEditAccountCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFEDE7F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Edit Account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 70),
          // عرض صورة الحساب مع أيقونة تعديل تظهر القائمة عند الضغط عليها
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Hero(
                tag: 'avatar',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.indigoAccent, width: 4),
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        "https://www.w3schools.com/howto/img_avatar.png"),
                  ),
                ),
              ),
              // أيقونة التعديل التي عند الضغط عليها تعرض خيارات الصورة
              InkWell(
                key: _editIconKey,
                onTap: _showImageOptions,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.6),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // حقل لتحديث اسم المستخدم مع أيقونة حفظ
          // ملاحظة للمبرمج الخلفي: عند الضغط على أيقونة الحفظ، يجب ربط الوظيفة لتحديث اسم المستخدم في قاعدة البيانات عبر API
          TextField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.indigo),
            decoration: InputDecoration(
              labelText: "Update Username",
              labelStyle: const TextStyle(
                  color: Colors.indigo, fontWeight: FontWeight.w600),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.indigo, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              suffixIcon: HoverIconButton(
                tooltip: 'Save new name',
                onPressed: () {
                  // هنا يمكن إضافة منطق ربط الـ backend لتحديث اسم المستخدم
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username updated"),
                      backgroundColor: Colors.indigoAccent,
                    ),
                  );
                },
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
          ),

          const SizedBox(height: 24),
          // قسم البريد الإلكتروني يظهر بسلاسة مع AnimatedSwitcher
          AnimatedSwitcher(
            duration: const Duration(
                milliseconds: 1500), // مدة الانتقال (يمكن تعديلها حسب الحاجة)
            switchInCurve: Curves.easeIn, // منحنى ظهور الحقل
            switchOutCurve: Curves.easeOut, // منحنى اختفاء الحقل
            child: _showEmailField
                ? Column(
                    key: const ValueKey("emailField"),
                    children: [
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.indigo),
                        decoration: InputDecoration(
                          labelText: "Enter Email Address",
                          labelStyle: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.indigo, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffixIcon: HoverIconButton(
                            tooltip: 'Cancel',
                            onPressed: () {
                              setState(() {
                                _showEmailField = false;
                              });
                            },
                            child: const Icon(Icons.cancel_sharp,
                                color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          // عند الضغط على زر "Send" يتم إخفاء حقل البريد وبدء العد التنازلي
                          // ملاحظة للمبرمج الخلفي: هنا يجب استدعاء دالة API لإرسال رمز التأكيد أو تعليمات تغيير كلمة المرور إلى البريد الإلكتروني
                          setState(() {
                            _showEmailField = false;
                          });
                          startCountdown();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text("Send"),
                      ),
                    ],
                  )
                : const SizedBox(key: ValueKey("empty")),
          ),
          const SizedBox(height: 12),
          // زر "Update Password" مع نص العد التنازلي لتحديد وقت التعطيل
          ElevatedButton(
            onPressed: countdown > 0
                ? null
                : () {
                    // عند الضغط على الزر يتم إظهار حقل البريد الإلكتروني
                    setState(() {
                      _showEmailField = true;
                    });
                  },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: countdown > 0
                ? Text("Please wait $countdown sec", style: TextStyle(color: Colors.red),)
                : const Text("Update Password"),
          ),
        ],
      ),
    );
  }

  /// دالة بناء بطاقة "My Account" التي تعرض معلومات الحساب مثل:
  /// - صورة الحساب (مع حركة انتقالية باستخدام Hero)
  /// - الاسم والبريد الإلكتروني
  /// ملاحظة للمبرمج الخلفي: يمكن جلب بيانات المستخدم الحقيقية من الـ backend واستبدال القيم الثابتة هنا.
  Widget buildMyAccountCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFE3F2FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Your Account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 70),
          // عرض صورة الحساب باستخدام Hero لتأثير الحركة عند الانتقال بين الشاشات
          const Hero(
            tag: 'avatar',
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  "https://www.w3schools.com/howto/img_avatar.png"),
            ),
          ),
          const SizedBox(height: 40),
          // عرض اسم المستخدم مع عنوان توضيحي
          const Text(
            "Your Name",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.indigoAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Name",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // خط فاصل أنيق بين الأقسام
          const Divider(
            color: Colors.indigoAccent,
            thickness: 1.0,
            indent: 40,
            endIndent: 40,
          ),
          const SizedBox(height: 16),
          // عرض عنوان البريد الإلكتروني
          const Text(
            "Your Email Address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.indigoAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "email@example.com",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/*
===================================================================================================
شرح وتوضيح للمبرمجين (Frontend و Backend):

1. **الهيكل العام للصفحة:**
   - الصفحة مقسمة إلى بطاقتين رئيسيتين:
     - بطاقة "Edit Account": لتمكين المستخدم من تعديل بيانات حسابه (الصورة، الاسم، وكلمة المرور).
     - بطاقة "My Account": لعرض بيانات الحساب الحالية.
   - يتم استخدام تأثيرات رسوم متحركة (SlideTransition و Hero) لجعل الانتقالات سلسة وجذابة.

2. **الرسوم المتحركة والتحكم في الواجهة:**
   - تم إعداد AnimationControllers للبطاقتين لتوفير تأثير انزلاقي عند ظهورها.
   - يتم بدء الرسوم المتحركة بعد بناء الواجهة باستخدام WidgetsBinding.instance.addPostFrameCallback.

3. **عمليات التحديث والتفاعل:**
   - **تحديث اسم المستخدم:**
     - يتم تعديل اسم المستخدم عبر حقل نصي مع أيقونة حفظ.
     - **للمبرمج الخلفي:** عند الضغط على زر الحفظ، يجب ربط دالة API لتحديث اسم المستخدم في قاعدة البيانات.
   - **تحديث كلمة المرور:**
     - يتم إظهار حقل إدخال البريد الإلكتروني عند الضغط على زر "Update Password".
     - عند الضغط على زر "Send"، يتم بدء عد تنازلي لمدة 60 ثانية لتعطيل الزر.
     - **للمبرمج الخلفي:** يجب ربط الدالة التي ترسل البريد الإلكتروني برمز التحقق أو تعليمات تغيير كلمة المرور عن طريق استدعاء API.
   - **تعديل صورة الحساب:**
     - عند الضغط على أيقونة تعديل الصورة، يتم عرض قائمة خيارات (حذف أو تحديث الصورة).
     - **للمبرمج الخلفي:** هنا يمكن ربط وظائف حذف أو تحديث الصورة مع الخادم (مثلاً رفع الصورة إلى السيرفر أو حذفها من قاعدة البيانات).

4. **نصائح للربط مع الـ Backend:**
   - تأكد من استبدال القيم الثابتة مثل "Existing Username" و "email@example.com" بالقيم الحقيقية التي يتم جلبها من الخادم.
   - عند استدعاء أي دوال تتعلق بتحديث البيانات (مثل تغيير الاسم أو إرسال البريد الإلكتروني)، يجب تنفيذ استدعاءات API المناسبة والتعامل مع استجابة الخادم.
   - استخدم نمط إدارة الحالة المناسب (مثل Provider, Bloc, Riverpod) لربط التحديثات في واجهة المستخدم مع بيانات الخادم بشكل سلس.
   - تأكد من معالجة الأخطاء وإظهار رسائل مناسبة للمستخدم في حال فشل الاتصال بالـ backend.

5. **المحافظة على الكود والصيانة:**
   - التعليقات المضافة توضح وظيفة كل جزء من الكود، مما يساعد في الصيانة والتطوير المستقبلي.
   - يجب الحفاظ على فصل واجهة المستخدم (Frontend) عن منطق الأعمال والاتصال بالـ backend.
   - ينصح باستخدام طبقات (Layers) متعددة، بحيث يكون الـ frontend مسؤولاً عن العرض والتفاعل، بينما تتعامل طبقة الخدمة مع الاتصالات والعمليات على الخادم.

هذه الملاحظات تساعد كلا من مطوري الـ frontend والـ backend على فهم الكود وربطه بسهولة مع الخادم لضمان عمل التطبيق بسلاسة.
===================================================================================================
*/