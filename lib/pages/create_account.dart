import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  var isLoading = false.obs;
  var birthday = Rx<DateTime?>(null);
  var gender = 'male'.obs;

  void createAccount(String firstName, String lastName, String email,
      String password, String imageUrl) async {
    isLoading.value = true;
    await Future.delayed(
        Duration(seconds: 2)); // Simulate account creation delay

    // Simulate successful account creation
    isLoading.value = false;

    // Handle navigation or show success message here
    Get.back(); // Navigate back
  }
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  static const routeName = '/create-account';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _fNameController = TextEditingController();
    final TextEditingController _lNameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _imageUrlController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image URL Text Field
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    hintText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fNameController,
                        decoration: InputDecoration(
                          hintText: 'First name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lNameController,
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.birthday.value ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        controller.birthday.value = pickedDate;
                      }
                    },
                    child: Text(
                      controller.birthday.value == null
                          ? 'Pick a Birthday'
                          : 'Birthday: ${controller.birthday.value!.toLocal()}'
                              .split(' ')[0],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  return DropdownButton<String>(
                    value: controller.gender.value,
                    onChanged: (String? newValue) {
                      controller.gender.value = newValue!;
                    },
                    items: <String>['male', 'female', 'other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.createAccount(
                                _fNameController.text,
                                _lNameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _imageUrlController.text,
                              );
                            }
                          },
                          child: const Text('Create Account'),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
