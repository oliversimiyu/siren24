import 'package:flutter/material.dart';
import 'package:siren24/services/user_storage.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);
  static String id = 'registration';

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  height: height / 2,
                  color: Color(0Xff4C6EE5),
                ),
                Container(
                  height: height / 2,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height / 2 - 150,
                      ),
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          height: 50,
                          width: 340,
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  'G',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Connect with Google',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          height: 50,
                          width: 340,
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  'f',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Connect with Facebook',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0.25 * height,
              right: 20,
              left: 20,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                elevation: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  height: 480,
                  width: 343,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(height: 2),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Create your account',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Name Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 45,
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              suffix: IconButton(
                                  onPressed: () {
                                    _nameController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.grey,
                                  )),
                              contentPadding: EdgeInsets.all(10),
                              focusColor: Colors.black,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Email Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 45,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email (optional)',
                              suffix: IconButton(
                                  onPressed: () {
                                    _emailController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.grey,
                                  )),
                              contentPadding: EdgeInsets.all(10),
                              focusColor: Colors.black,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Phone Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 45,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              suffix: IconButton(
                                  onPressed: () {
                                    _phoneController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.grey,
                                  )),
                              contentPadding: EdgeInsets.all(10),
                              focusColor: Colors.black,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () async {
                          if (_phoneController.text.isNotEmpty &&
                              _nameController.text.isNotEmpty) {
                            // Save user data to storage
                            bool registrationSuccess =
                                await UserStorageService.registerUser(
                              phone: _phoneController.text,
                              name: _nameController.text,
                              email: _emailController.text.isNotEmpty
                                  ? _emailController.text
                                  : null,
                            );

                            if (registrationSuccess) {
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Registration successful! Please login with your credentials.'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // Navigate back to login page after a short delay
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.pop(context);
                              });
                            } else {
                              // Show error message if user already exists
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'User with this phone number already exists!'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please fill in all required fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0Xff4C6EE5),
                            ),
                            height: 50,
                            width: 340,
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              color: Color(0Xff4C6EE5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
