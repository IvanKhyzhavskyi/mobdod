import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  final Function(Map<String, String>) onUserRegistered;

  // Додаємо параметр onUserRegistered до конструктора
  RegistrationScreen({required this.onUserRegistered});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Функція реєстрації
  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;
      final phone = _phoneController.text;

      setState(() {
        _isLoading = true;
      });

      try {
        // Викликаємо onUserRegistered для передачі даних на екран логіну
        widget.onUserRegistered({
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Реєстрація успішна!')),
        );

        // Повертаємося на екран логіну після реєстрації
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка реєстрації')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ім\'я'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Це поле не може бути порожнім';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Це поле не може бути порожнім';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Будь ласка, введіть коректну адресу електронної пошти';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Пароль'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Це поле не може бути порожнім';
                  }
                  if (value.length < 6) {
                    return 'Пароль повинен містити не менше 6 символів';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Телефон'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Це поле не може бути порожнім';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
