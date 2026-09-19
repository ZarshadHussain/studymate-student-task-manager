import 'package:flutter/material.dart';

void main() {
  runApp(const StudyMateApp());
}

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TaskHomePage(),
    );
  }
}

class Task {
  String title;
  String subject;
  bool isCompleted;

  Task({required this.title, required this.subject, this.isCompleted = false});
}

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final List<Task> tasks = [
    Task(title: 'Complete Flutter Assignment', subject: 'Programming'),
    Task(title: 'Prepare OSI Model Notes', subject: 'Networking'),
    Task(title: 'Practice Sorting Algorithms', subject: 'Data Structures'),
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  void addTask() {
    if (titleController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      tasks.add(
        Task(
          title: titleController.text.trim(),
          subject: subjectController.text.trim(),
        ),
      );
    });

    titleController.clear();
    subjectController.clear();
    Navigator.pop(context);
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  prefixIcon: Icon(Icons.task_alt),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.book),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: addTask, child: const Text('Add Task')),
          ],
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => tasks.where((task) => !task.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'StudyMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Student! 👋',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Stay organized and achieve your goals.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Tasks',
                    tasks.length.toString(),
                    Icons.assignment,
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Completed',
                    completedTasks.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Pending',
                    pendingTasks.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'My Tasks',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            if (tasks.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('No tasks available. Add a new task!'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          setState(() {
                            task.isCompleted = value ?? false;
                          });
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(task.subject),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
