import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 255, 81, 0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 81, 0),
          primary: const Color.fromARGB(255, 255, 81, 0),
        ),
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
    );
  }
}

// Splash Screen dengan animasi
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 81, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animasi
            ScaleTransition(
              scale: _animation,
              child: Hero(
                tag: 'profileLogo',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: const Color.fromARGB(255, 255, 81, 0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Teks animasi
            FadeTransition(
              opacity: _animation,
              child: Text(
                "Profile App",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: Text(
                "Memuat profil pengguna...",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
            SizedBox(height: 40),
            FadeTransition(
              opacity: _animation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Data statis untuk informasi akademik
  final String programStudi = "SISTEM INFORMASI";
  final String kampus = "Universitas Ahmad Dahlan";

  @override
  void initState() {
    super.initState();
    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchData() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/users/1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data;
          isLoading = false;
        });
        // Start animation after data is loaded
        _animationController.forward();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text("Profil Mahasiswa"), elevation: 0),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [_buildHeader(), _buildInfoSection()],
                  ),
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 81, 0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 81, 0).withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Hero(
            tag: 'profileLogo',
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Text(
                userData['name'] != null &&
                        userData['name'].toString().isNotEmpty
                    ? userData['name'].toString().substring(0, 1)
                    : "?",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 81, 0),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
            child: Text(
              userData['name'] ?? "Bintang Deprian",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
            child: Text(
              programStudi,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          SizedBox(height: 3),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
            child: Text(
              kampus,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Informasi Kontak",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 81, 0),
                  ),
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                _buildInfoItem(
                  Icons.email_outlined,
                  "Email",
                  userData['email'] ?? "Email tidak tersedia",
                ),
                _buildInfoItem(
                  Icons.phone_outlined,
                  "Telepon",
                  userData['phone'] ?? "Nomor telepon tidak tersedia",
                ),
                _buildInfoItem(
                  Icons.web_outlined,
                  "Website",
                  userData['website'] ?? "Website tidak tersedia",
                ),
                SizedBox(height: 20),
                Text(
                  "Alamat",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 71, 0),
                  ),
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                if (userData['address'] != null) ...[
                  _buildInfoItem(
                    Icons.location_on_outlined,
                    "Jalan",
                    userData['address']['street'] ?? "Tidak tersedia",
                  ),
                  _buildInfoItem(
                    Icons.apartment_outlined,
                    "Suite",
                    userData['address']['suite'] ?? "Tidak tersedia",
                  ),
                  _buildInfoItem(
                    Icons.location_city_outlined,
                    "Kota",
                    userData['address']['city'] ?? "Tidak tersedia",
                  ),
                  _buildInfoItem(
                    Icons.markunread_mailbox_outlined,
                    "Kode Pos",
                    userData['address']['zipcode'] ?? "Tidak tersedia",
                  ),
                ] else
                  Text("Alamat tidak tersedia"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 255, 81, 0), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
