import 'package:flutter/material.dart';

void main() {
  runApp(const StudyMateApp());
}

class StudyTask {
  String title;
  String subject;
  String priority;
  DateTime dueDate;
  bool completed;

  StudyTask({
    required this.title,
    required this.subject,
    required this.priority,
    required this.dueDate,
    this.completed = false,
  });
}

class StudyEntry {
  String subject;
  String time;

  StudyEntry({required this.subject, required this.time});
}

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F5FC),
      ),
      home: const StudyHome(),
    );
  }
}

class StudyHome extends StatefulWidget {
  const StudyHome({super.key});

  @override
  State<StudyHome> createState() => _StudyHomeState();
}

class _StudyHomeState extends State<StudyHome> {
  int selectedIndex = 0;

  String studentName = 'Student';
  String email = '';
  String course = 'B.Tech CSE';

  final List<StudyTask> tasks = [];

  final List<StudyEntry> timetable = [
    StudyEntry(subject: 'Mathematics', time: '09:00 AM'),
    StudyEntry(subject: 'Computer Science', time: '11:00 AM'),
    StudyEntry(subject: 'Programming', time: '02:00 PM'),
  ];

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int get completedTasks => tasks.where((task) => task.completed).length;

  int get pendingTasks => tasks.length - completedTasks;

  int priorityCount(String priority) {
    return tasks
        .where((task) => task.priority == priority && !task.completed)
        .length;
  }

  Color priorityColor(String priority) {
    if (priority == 'High') return Colors.red;
    if (priority == 'Medium') return Colors.orange;
    return Colors.green;
  }

  void addTask() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();

    String priority = 'Medium';
    DateTime dueDate = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ['High', 'Medium', 'Low']
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        updateDialog(() {
                          priority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: Text('Due Date: ${formatDate(dueDate)}'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dueDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          updateDialog(() {
                            dueDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty &&
                        subjectController.text.trim().isNotEmpty) {
                      setState(() {
                        tasks.add(
                          StudyTask(
                            title: titleController.text.trim(),
                            subject: subjectController.text.trim(),
                            priority: priority,
                            dueDate: dueDate,
                          ),
                        );
                      });
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addTimetableEntry() {
    final subjectController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Timetable Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                hintText: '10:00 AM',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (subjectController.text.trim().isNotEmpty &&
                  timeController.text.trim().isNotEmpty) {
                setState(() {
                  timetable.add(
                    StudyEntry(
                      subject: subjectController.text.trim(),
                      time: timeController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void editProfile() {
    final nameController = TextEditingController(text: studentName);
    final emailController = TextEditingController(text: email);
    final courseController = TextEditingController(text: course);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Course'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                studentName = nameController.text.trim().isEmpty
                    ? 'Student'
                    : nameController.text.trim();
                email = emailController.text.trim();
                course = courseController.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hello, $studentName! 👋',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Welcome to StudyMate',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay Focused!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Plan your studies, manage your tasks and achieve your goals.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Your Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            summaryCard('Total Tasks', '${tasks.length}', Icons.assignment,
                Colors.blue),
            summaryCard('Completed', '$completedTasks', Icons.check_circle,
                Colors.green),
          ],
        ),
        Row(
          children: [
            summaryCard('Pending', '$pendingTasks', Icons.pending_actions,
                Colors.orange),
            summaryCard('Timetable', '${timetable.length}',
                Icons.calendar_month, Colors.deepPurple),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          'Pending Task Priorities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        priorityTile('High', priorityCount('High'), Colors.red),
        priorityTile('Medium', priorityCount('Medium'), Colors.orange),
        priorityTile('Low', priorityCount('Low'), Colors.green),
      ],
    );
  }

  Widget priorityTile(String title, int count, Color color) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          radius: 7,
          backgroundColor: color,
        ),
        title: Text('$title Priority'),
        trailing: Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget buildTasks() {
    return Column(
      children: [
        Expanded(
          child: tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks added yet.\nTap the button below to add a task.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (value) {
                            setState(() {
                              task.completed = value ?? false;
                            });
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Subject: ${task.subject}'),
                              Text('Due: ${formatDate(task.dueDate)}'),
                              Text(
                                'Priority: ${task.priority}',
                                style: TextStyle(
                                  color: priorityColor(task.priority),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: addTask,
              icon: const Icon(Icons.add),
              label: const Text('Add New Task'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTimetable() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: timetable.length,
            itemBuilder: (context, index) {
              final entry = timetable[index];

              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEDE7F6),
                    child: Icon(
                      Icons.menu_book,
                      color: Colors.deepPurple,
                    ),
                  ),
                  title: Text(
                    entry.subject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(entry.time),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        timetable.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: addTimetableEntry,
              icon: const Icon(Icons.add),
              label: const Text('Add Timetable Entry'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProgress() {
    final progress = tasks.isEmpty ? 0.0 : completedTasks / tasks.length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Your Progress',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Task Completion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.deepPurple.shade100,
                        color: Colors.deepPurple,
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('$completedTasks completed out of ${tasks.length} tasks'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        priorityTile('High Priority', priorityCount('High'), Colors.red),
        priorityTile('Medium Priority', priorityCount('Medium'), Colors.orange),
        priorityTile('Low Priority', priorityCount('Low'), Colors.green),
      ],
    );
  }

  Widget buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 10),
        const CircleAvatar(
          radius: 48,
          backgroundColor: Color(0xFFE5DDF8),
          child: Icon(
            Icons.person,
            size: 55,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            studentName,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Text(
            email.isEmpty ? 'Add your email address' : email,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: Colors.deepPurple),
                title: const Text('Name'),
                subtitle: Text(studentName),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.deepPurple),
                title: const Text('Email'),
                subtitle: Text(email.isEmpty ? 'Not added' : email),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.deepPurple),
                title: const Text('Course'),
                subtitle: Text(course),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: editProfile,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Important Notice',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'All information entered in this app is stored '
                'temporarily during the current app session only. '
                'Your profile details, tasks and timetable will be '
                'lost when you close or restart the app.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      buildTasks(),
      buildTimetable(),
      buildProgress(),
      buildProfile(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'StudyMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Timetable',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
