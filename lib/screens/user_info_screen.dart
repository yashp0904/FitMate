import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String? selectedGender;
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  String? selectedGoal;

  final List<String> goals = ['Lose Weight', 'Gain Muscle', 'Maintain'];

  void handleNext() {
    // This is where you'd save user info or pass it to next screen
    final gender = selectedGender;
    final age = ageController.text;
    final height = heightController.text;
    final weight = weightController.text;
    final goal = selectedGoal;

    if (gender != null && goal != null && age.isNotEmpty && height.isNotEmpty && weight.isNotEmpty) {
      // Just for now, print the result
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("User Info"),
          content: Text("Gender: $gender\nAge: $age\nHeight: $height\nWeight: $weight\nGoal: $goal"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Fitness Info')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('Select Gender'),
            Row(
              children: ['Male', 'Female', 'Other'].map((gender) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(gender),
                    value: gender,
                    groupValue: selectedGender,
                    onChanged: (value) => setState(() => selectedGender = value),
                  ),
                );
              }).toList(),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedGoal,
              hint: const Text('Select Your Goal'),
              items: goals.map((goal) {
                return DropdownMenuItem(
                  value: goal,
                  child: Text(goal),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedGoal = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleNext,
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}
