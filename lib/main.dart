import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SubizApp());
}

class SubizApp extends StatelessWidget {
  const SubizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subiz - Đăng nhập',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFF249FE6),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066B3),
          brightness: Brightness.light,
        ),
      ),
      home: const SubizLoginScreen(),
    );
  }
}

class SubizLoginScreen extends StatefulWidget {
  const SubizLoginScreen({super.key});

  @override
  State<SubizLoginScreen> createState() => _SubizLoginScreenState();
}

class _SubizLoginScreenState extends State<SubizLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showToast('Vui lòng nhập Email', isError: true);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showToast('Email không đúng định dạng', isError: true);
      return;
    }

    if (password.isEmpty) {
      _showToast('Vui lòng nhập mật khẩu', isError: true);
      return;
    }

    if (password.length < 6) {
      _showToast('Mật khẩu tối thiểu 6 ký tự', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate authentication call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    _showSuccessDialog(email);
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xE6D32F2F)
            : const Color(0xF20288D1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F5FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF0288D1),
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Đăng nhập thành công!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F3E68),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chào mừng bạn trở lại, $email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066B3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'TIẾP TỤC',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final resetController = TextEditingController(text: _emailController.text);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Quên mật khẩu?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3E68),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nhập địa chỉ email đăng ký để nhận liên kết đặt lại mật khẩu.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: resetController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Nhập email của bạn',
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0066B3)),
                  filled: true,
                  fillColor: const Color(0xFFF3F7FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066B3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final target = resetController.text.trim();
                    Navigator.of(ctx).pop();
                    if (target.isNotEmpty) {
                      _showToast('Đã gửi email khôi phục tới $target');
                    }
                  },
                  child: const Text(
                    'GỬI LIÊN KẾT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegisterDialog() {
    final nameController = TextEditingController();
    final regEmailController = TextEditingController();
    final regPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isRegLoading = false;
    bool isRegPassVisible = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Đăng ký tài khoản',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3E68),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tạo tài khoản Subiz để trải nghiệm dịch vụ chăm sóc khách hàng.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Họ và tên',
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF0066B3)),
                      filled: true,
                      fillColor: const Color(0xFFF3F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: regEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Địa chỉ Email',
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0066B3)),
                      filled: true,
                      fillColor: const Color(0xFFF3F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: regPasswordController,
                    obscureText: !isRegPassVisible,
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu (tối thiểu 6 ký tự)',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0066B3)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isRegPassVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setModalState(() {
                            isRegPassVisible = !isRegPassVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !isRegPassVisible,
                    decoration: InputDecoration(
                      hintText: 'Xác nhận lại mật khẩu',
                      prefixIcon: const Icon(Icons.lock_reset_rounded, color: Color(0xFF0066B3)),
                      filled: true,
                      fillColor: const Color(0xFFF3F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066B3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isRegLoading
                          ? null
                          : () async {
                              final name = nameController.text.trim();
                              final email = regEmailController.text.trim();
                              final pass = regPasswordController.text.trim();
                              final confirmPass = confirmPasswordController.text.trim();

                              if (name.isEmpty) {
                                _showToast('Vui lòng nhập họ và tên', isError: true);
                                return;
                              }
                              if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                                _showToast('Vui lòng nhập email hợp lệ', isError: true);
                                return;
                              }
                              if (pass.length < 6) {
                                _showToast('Mật khẩu tối thiểu 6 ký tự', isError: true);
                                return;
                              }
                              if (pass != confirmPass) {
                                _showToast('Mật khẩu xác nhận không trùng khớp', isError: true);
                                return;
                              }

                              setModalState(() => isRegLoading = true);
                              await Future.delayed(const Duration(milliseconds: 1000));

                              if (!ctx.mounted) return;
                              Navigator.of(ctx).pop();
                              if (!mounted) return;
                              _emailController.text = email;
                              _passwordController.text = pass;
                              _showToast('Đăng ký thành công tài khoản $name!');
                            },
                      child: isRegLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'ĐĂNG KÝ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // 1. Background Image with Blue Tint
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF38B8F6), Color(0xFF0282CC)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2. Cyan / Sky Blue Multi-Stop Gradient Overlay
            // Matching the vibrant blue tone from the mockup
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xE02CB5F6), // Top bright cyan
                      Color(0xD11E9CE0),
                      Color(0xCC0C7BBF),
                      Color(0xD9056DA8), // Bottom deeper blue
                    ],
                    stops: [0.0, 0.40, 0.70, 1.0],
                  ),
                ),
              ),
            ),

            // 3. Subtle vignette / light contrast enhancement
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.0, -0.2),
                    radius: 1.1,
                    colors: [
                      Colors.transparent,
                      Color(0x1F000000),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Main Content (Scrollable for any screen size / keyboard handling)
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: SlideTransition(
                        position: _slideIn,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.05),

                              // --- SUBIZ LOGO & WELCOME TEXT ---
                              const SubizLogoWidget(),

                              SizedBox(height: size.height * 0.12),

                              // --- EMAIL INPUT ---
                              _buildCapsuleTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 16),

                              // --- PASSWORD INPUT ---
                              _buildCapsuleTextField(
                                controller: _passwordController,
                                hintText: 'Mật khẩu',
                                icon: Icons.lock_outline_rounded,
                                obscureText: !_isPasswordVisible,
                                isPassword: true,
                                onToggleVisibility: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),

                              const SizedBox(height: 24),

                              // --- LOGIN BUTTON ---
                              _buildLoginButton(),

                              const SizedBox(height: 16),

                              // --- FORGOT PASSWORD LINK ---
                              GestureDetector(
                                onTap: _showForgotPasswordDialog,
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    'Quên mật khẩu?',
                                    style: TextStyle(
                                      color: Color(0xF2FFFFFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xD9FFFFFF),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // --- DIVIDER WITH "HOẶC" ---
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 0.8,
                                      color: const Color(0x40FFFFFF),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text(
                                      'HOẶC',
                                      style: TextStyle(
                                        color: Color(0xB3FFFFFF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 0.8,
                                      color: const Color(0x40FFFFFF),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // --- REGISTER BUTTON (OUTLINE STYLE) ---
                              _buildRegisterButton(),

                              const SizedBox(height: 16),

                              // --- REGISTER LINK TEXT ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Chưa có tài khoản? ',
                                    style: TextStyle(
                                      color: Color(0xEBFFFFFF),
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _showRegisterDialog,
                                    behavior: HitTestBehavior.opaque,
                                    child: const Text(
                                      'Đăng ký ngay',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: size.height * 0.05),
                            ],
                          ),
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

  /// Builds a pill / capsule shaped input field matching the design
  Widget _buildCapsuleTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        // Translucent deep blue background matching the screenshot
        color: const Color(0x80035E99),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0x24FFFFFF),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 18),

          // Left Icon
          Icon(
            icon,
            size: 20,
            color: const Color(0xD9FFFFFF),
          ),

          const SizedBox(width: 12),

          // Vertical Divider Separator `|`
          Container(
            width: 1.0,
            height: 18,
            color: const Color(0x66FFFFFF),
          ),

          const SizedBox(width: 14),

          // Input Text Field
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xADFFFFFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 2),
                isDense: true,
              ),
            ),
          ),

          // Optional password visibility toggle icon
          if (isPassword)
            IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xA6FFFFFF),
              ),
              onPressed: onToggleVisibility,
              splashRadius: 18,
            )
          else
            const SizedBox(width: 16),
        ],
      ),
    );
  }

  /// Builds the solid vibrant blue LOGIN button matching the screenshot
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        // Solid royal blue color matching the screenshot
        color: const Color(0xFF0063AA),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59003E6D),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          splashColor: const Color(0x2EFFFFFF),
          highlightColor: const Color(0x14FFFFFF),
          onTap: _isLoading ? null : _handleLogin,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// Builds an outline button for Register
  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0x2E004D80),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xB3FFFFFF),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          splashColor: const Color(0x2EFFFFFF),
          highlightColor: const Color(0x14FFFFFF),
          onTap: _showRegisterDialog,
          child: const Center(
            child: Text(
              'ĐĂNG KÝ TÀI KHOẢN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Subiz Logo & "WELCOME TO SUBIZ" Title Widget
class SubizLogoWidget extends StatelessWidget {
  const SubizLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Subiz icon + 'subiz' text
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Speech bubble icon with +
            CustomPaint(
              size: const Size(44, 40),
              painter: const SubizBubblePainter(),
            ),

            const SizedBox(width: 8),

            // 'subiz' text
            const Text(
              'subiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
                height: 1.0,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Tiêu đề phụ 'CHÀO MỪNG ĐẾN VỚI SUBIZ'
        const Text(
          'CHÀO MỪNG ĐẾN VỚI SUBIZ',
          style: TextStyle(
            color: Color(0xEBFFFFFF),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}

/// Custom Painter for the Subiz speech bubble with a cyan '+' icon inside
class SubizBubblePainter extends CustomPainter {
  const SubizBubblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the white speech bubble body
    final bubblePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.84),
      Radius.circular(size.height * 0.42),
    );
    path.addRRect(bubbleRect);

    // Speech tail pointing to bottom left
    final tailPath = Path();
    tailPath.moveTo(size.width * 0.28, size.height * 0.78);
    tailPath.lineTo(size.width * 0.16, size.height);
    tailPath.lineTo(size.width * 0.44, size.height * 0.82);
    tailPath.close();
    path.addPath(tailPath, Offset.zero);

    canvas.drawPath(path, bubblePaint);

    // 2. Draw the cyan '+' symbol inside the speech bubble
    final plusPaint = Paint()
      ..color = const Color(0xFF23A3E8)
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final centerX = size.width * 0.50;
    final centerY = size.height * 0.42;
    const halfLen = 6.8;

    // Horizontal bar
    canvas.drawLine(
      Offset(centerX - halfLen, centerY),
      Offset(centerX + halfLen, centerY),
      plusPaint,
    );

    // Vertical bar
    canvas.drawLine(
      Offset(centerX, centerY - halfLen),
      Offset(centerX, centerY + halfLen),
      plusPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
