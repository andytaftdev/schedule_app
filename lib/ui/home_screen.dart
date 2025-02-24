import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String? priority;
  bool isLoading = false;
  String generatedSchedule = '';
  String errorMessage = '';

  void addTask() {
    if (taskController.text.isNotEmpty &&
        priority != null &&
        durationController.text.isNotEmpty) {
      final duration = int.tryParse(durationController.text);
      if (duration == null || duration <= 0) {
        setState(() {
          errorMessage = 'Durasi harus berupa angka positif.';
        });
        return;
      }

      setState(() {
        tasks.add({
          "name": taskController.text,
          "priority": priority,
          "minutes": duration,
        });
        errorMessage = ''; // Clear any previous error message
      });
      taskController.clear();
      durationController.clear();
      priority = null;
    } else {
      setState(() {
        errorMessage = 'Harap isi semua field.';
      });
    }
  }

  Future<void> _generateSchedule() async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Clear any previous error message
    });
    try {
      final schedule = ;
      setState(() {
        generatedSchedule = schedule;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal menghasilkan jadwal: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule App',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 32,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Tugas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: 'Durasi (menit)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Deadline',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Prioritas',
                        border: OutlineInputBorder(),
                      ),
                      value: priority,
                      items: ['Rendah', 'Sedang', 'Tinggi'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          priority = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih prioritas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Tambah Tugas'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Task List Section
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Text(
                  'Belum ada tugas.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        task['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Prioritas: ${task['priority']}, Durasi: ${task['minutes']} menit',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Generate Schedule Button
            if (tasks.isNotEmpty)
              ElevatedButton(
                onPressed: isLoading ? null : _generateSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : const Text('Generate Schedule'),
              ),

            const SizedBox(height: 16),

            // Generated Schedule Section
            if (generatedSchedule.isNotEmpty)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jadwal yang Dihasilkan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(generatedSchedule),
                    ],
                  ),
                ),
              ),

            // Error Message
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}