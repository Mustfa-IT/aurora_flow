import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/utils/get_image_from_pocket_base.dart';
import 'package:task_app/core/widgets/avatar_picker.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/home/view/widget/hoverIcon_button.dart';
import 'package:task_app/core/config/config.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage>
    with TickerProviderStateMixin {
  int _passwordResetCountdown = 0;
  Timer? _countdownTimer;
  var user;

  late final TextEditingController _usernameController;

  bool _showEmailMessage = false;

  late AnimationController _editCardController;
  late Animation<Offset> _editCardSlideAnimation;
  late AnimationController _accountCardController;
  late Animation<Offset> _accountCardSlideAnimation;

  late final Future<Uint8List> _avatarImageFuture;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthBloc>().state.user!;
    // Initialize the future to fetch the avatar image.
    _avatarImageFuture =
        getImageFromPocketBase(user.collectionId, user.id, user.avatar)
            .then((value) => value ?? Uint8List(0));

    _usernameController = TextEditingController(text: user.name);
    _editCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _editCardSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, -2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _editCardController,
        curve: Curves.easeOut,
      ),
    );

    _accountCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _accountCardSlideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _accountCardController,
        curve: Curves.easeOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editCardController.forward();
      _accountCardController.forward();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _usernameController.dispose();
    _editCardController.dispose();
    _accountCardController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    if (_passwordResetCountdown > 0) return;
    setState(() {
      _passwordResetCountdown = 60;
      _showEmailMessage = false;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_passwordResetCountdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _passwordResetCountdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSessionActive) {
          setState(() {
            user = state.user!;
          });
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 40,
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
              if (constraints.maxWidth < 800) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: kToolbarHeight + 32,
                      left: 16,
                      right: 16,
                      bottom: 16),
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _editCardSlideAnimation,
                        child: _buildEditAccountCard(),
                      ),
                      const SizedBox(height: 24),
                      SlideTransition(
                        position: _accountCardSlideAnimation,
                        child: _buildMyAccountCard(),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: kToolbarHeight + 32,
                      left: 32,
                      right: 32,
                      bottom: 32),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SlideTransition(
                              position: _editCardSlideAnimation,
                              child: _buildEditAccountCard(),
                            ),
                          ),
                          Container(
                            width: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.blue,
                          ),
                          Expanded(
                            child: SlideTransition(
                              position: _accountCardSlideAnimation,
                              child: _buildMyAccountCard(),
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
      ),
    );
  }

  Widget _buildEditAccountCard() {
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
          FutureBuilder<Uint8List>(
            future: _avatarImageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return AvatarPicker(
                  defaultImage: Uint8List(0),
                  onImageSelected: (img) {
                    if (img != null) {
                      context.read<AuthBloc>().add(
                            AuthUpdateAvatarRequested(
                              image: img,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error updating avatar"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                );
              }
              return AvatarPicker(
                defaultImage: snapshot.data!,
                onImageSelected: (img) {
                  context.read<AuthBloc>().add(
                        AuthUpdateAvatarRequested(
                          image: img ?? Uint8List(0),
                        ),
                      );
                },
              );
            },
          ),
          const SizedBox(height: 24),
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
                  context.read<AuthBloc>().add(
                        AuthUpdateUsernameRequested(
                          name: _usernameController.text,
                        ),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username updated"),
                      backgroundColor: Colors.indigoAccent,
                    ),
                  );
                },
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: _showEmailMessage
                ? Column(
                    key: const ValueKey("emailMessage"),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          "The information has been sent to your email, please check it.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showEmailMessage = false;
                          });
                          _startCountdown();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.blue,
                          shape: const CircleBorder(),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 24,
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(key: ValueKey("empty")),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _passwordResetCountdown > 0
                ? null
                : () {
                    context.read<AuthBloc>().add(
                          AuthPasswordResetRequested(
                              email:
                                  context.read<AuthBloc>().state.user!.email),
                        );
                    setState(() {
                      _showEmailMessage = true;
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
            child: _passwordResetCountdown > 0
                ? Text(
                    "Please wait $_passwordResetCountdown sec",
                    style: const TextStyle(color: Colors.red),
                  )
                : const Text("Update Password"),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAccountCard() {
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
          Hero(
            tag: 'profileImage',
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  '${Config.pocketBaseUrl}/api/files/${user.collectionId}/${user.id}/${user.avatar}'),
            ),
          ),
          const SizedBox(height: 40),
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
          Text(
            user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Divider(
            color: Colors.indigoAccent,
            thickness: 1.0,
            indent: 40,
            endIndent: 40,
          ),
          const SizedBox(height: 16),
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
          Text(
            user.email,
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
