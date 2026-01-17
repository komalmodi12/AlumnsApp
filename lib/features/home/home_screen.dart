import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F6FF),
        elevation: 0,
        leadingWidth: 200,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
            Image.asset('assets/images/AluLogo.png', height: 28),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C3FCA),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 500,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),

                const Center(
                  child: Icon(
                    Icons.message,
                    color: Color(0xFF5C3FCA),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            elevation: 4,
            color: const Color(0xFFDACEF2),
            child: SizedBox(
              height: 200,
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/images/alu1.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 80),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "M.S Dhoni",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Add Intro Line",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recommended",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Show All",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 380, // fix height for horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 100, // large number for infinite feel
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  color: const Color(0xFFDACEF2), // custom card color
                  child: SizedBox(
                    width: 320, // card width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/dhoni_logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          "M.S. Dhoni #$index",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Subtitle
                        const Text(
                          "Add Intro Line",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

         

          const SizedBox(height: 16.0),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5C3FCA),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Camera",
          ),
        ],
      ),
    );
  }
}
