import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PYM app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),     
    PatientsList(),    
    UserProfile(),   
    Benefits(),      
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PYM app'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Beneficios',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade100,
            ),
            child: const Center(
              child: Text(
                'Bienvenido a PYM app\nTu salud en buenas manos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nuestras Especialidades',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSpecialtiesList(),
          const SizedBox(height: 24),
          const Text(
            'Doctores Destacados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDoctorsList(),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesList() {
    final specialties = [
      {'name': 'Cardiología', 'icon': Icons.favorite},
      {'name': 'Pediatría', 'icon': Icons.child_care},
      {'name': 'Neurología', 'icon': Icons.psychology},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: specialties.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 16),
            child: Container(
              width: 110,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    specialties[index]['icon'] as IconData,
                    size: 32,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialties[index]['name'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorsList() {
    final doctors = [
      {'name': 'Dr. Juan Pérez', 'specialty': 'Cardiología'},
      {'name': 'Dra. María García', 'specialty': 'Pediatría'},
      {'name': 'Dr. Carlos López', 'specialty': 'Neurología'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(doctors[index]['name'] as String),
            subtitle: Text(doctors[index]['specialty'] as String),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente: Detalles del doctor')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          const Text(
            'Dr. Francisco Polo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Cardiología',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildProfileItem(Icons.phone, 'Teléfono', '+56 9 41166845'),
          _buildProfileItem(Icons.email, 'Email', 'fco.polo@pym.com'),
          _buildProfileItem(Icons.location_on, 'Dirección', 'Vicuña Mackenna 2289'),
          _buildProfileItem(Icons.work, 'Experiencia', '40 años'),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }
}

class Benefits extends StatelessWidget {
  const Benefits({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        BenefitCard(
          title: 'Seguro Médico',
          description: 'Cobertura completa para ti y tu familia',
          icon: Icons.health_and_safety,
        ),
        BenefitCard(
          title: 'Horario Flexible',
          description: 'Organiza tu tiempo de manera efectiva',
          icon: Icons.schedule,
        ),
        BenefitCard(
          title: 'Desarrollo Profesional',
          description: 'Acceso a cursos y certificaciones',
          icon: Icons.school,
        ),
        BenefitCard(
          title: 'Bonos por Desempeño',
          description: 'Reconocimiento a tu esfuerzo',
          icon: Icons.monetization_on,
        ),
      ],
    );
  }
}

class BenefitCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const BenefitCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientsList extends StatelessWidget {
  const PatientsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('Paciente ${index + 1}'),
            subtitle: Text('Próxima cita: ${_getRandomDate(index)}'),
            trailing: IconButton(
              icon: const Icon(Icons.medical_services),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Próximamente: Historial médico'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getRandomDate(int index) {
    final now = DateTime.now();
    final random = now.add(Duration(days: index * 2));
    return '${random.day}/${random.month}/${random.year}';
  }
}