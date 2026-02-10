# Building and Validating Complex Forms - Quick Start (10 Minutes)

Get your first validated form working in 10 minutes.

---

## Step 1: Add Form Dependency (1 minute)

Form validation is built into Flutter—no external package needed!

```dart
// forms_validation_quick_start_example.dart
import 'package:flutter/material.dart';
```

---

## Step 2: Create Form Key & State (1 minute)

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## Step 3: Build Form UI (3 minutes)

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Login Form")),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                if (!value.contains("@")) {
                  return "Enter a valid email";
                }
                return null;
              },
              onSaved: (value) => email = value ?? "",
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
              onSaved: (value) => password = value ?? "",
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

## Step 4: Implement Submit Logic (2 minutes)

```dart
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    // Form is valid, do something
    print("Email: $email");
    print("Password: $password");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login successful!")),
    );
  }
}
```

---

## Step 5: Test Your Form! (3 minutes)

Run the app:
```bash
flutter run
```

**Test scenarios:**
1. ✅ Click Login with empty fields → See errors
2. ✅ Enter invalid email → See email error
3. ✅ Enter valid email, short password → See password error
4. ✅ Enter both correctly → Form submits

---

## Complete Example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Form")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!value.contains("@")) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                onSaved: (value) => email = value ?? "",
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
                onSaved: (value) => password = value ?? "",
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Email: $email, Password: $password");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful!")),
      );
    }
  }
}
```

---

## Key Concepts

| Concept | Meaning | Example |
|---------|---------|---------|
| **Form** | Container for fields | `Form(key: _formKey, child: ...)` |
| **GlobalKey** | Unique identifier for form | `GlobalKey<FormState>()` |
| **TextFormField** | Input field with validation | `TextFormField(validator: ...)` |
| **Validator** | Function checking input | `(value) => value!.isEmpty ? "error" : null` |
| **validate()** | Runs all validators | `_formKey.currentState!.validate()` |
| **save()** | Saves field values | `_formKey.currentState!.save()` |

---

## Common Validators

```dart
// Required field
validator: (value) => value?.isEmpty ?? true ? "Required" : null,

// Email
validator: (value) => !value!.contains("@") ? "Invalid email" : null,

// Min length
validator: (value) => value!.length < 6 ? "Min 6 chars" : null,

// Match another field (password confirmation)
validator: (value) => value != password ? "Must match" : null,
```

---

## Common Issues

**Issue**: Errors don't show
**Fix**: Use `TextFormField`, not `TextField`

**Issue**: validator not called
**Fix**: Wrap fields in `Form` with `key`

**Issue**: Form data not saved
**Fix**: Call `save()` after `validate()`

**Issue**: Button always enabled
**Fix**: Check validation result and conditionally enable

---

## Next Steps

1. ✅ Try this example
2. Add more fields
3. Review [CODE_EXAMPLES](FORMS_VALIDATION_CODE_EXAMPLES.md)
4. Follow [IMPLEMENTATION_CHECKLIST](FORMS_VALIDATION_IMPLEMENTATION_CHECKLIST.md)

---

**Time to working form**: 10 minutes ⏱️

**Status**: Ready to use ✅
