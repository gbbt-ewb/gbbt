import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  Map<String, dynamic>? journey;

  int currentStepIndex = 0;

  final Map<String, dynamic> answers = {};

  final Map<String, TextEditingController> controllers = {};

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadJourney();
  }

  Future<void> loadJourney() async {
    final raw =
        await rootBundle.loadString('lib/journeys/gbbt_onboarding.json');

    setState(() {
      journey = jsonDecode(raw);
    });
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController getController(String fieldId) {
    if (!controllers.containsKey(fieldId)) {
      controllers[fieldId] = TextEditingController();
    }

    return controllers[fieldId]!;
  }

  List<dynamic> get steps => journey!['steps'];

  void nextStep() {
    if (currentStepIndex < steps.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void previousStep() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  Future<void> selectDate(String fieldId) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ),
    );

    if (pickedDate == null) return;

    final formatted =
        '${pickedDate.month}/${pickedDate.day}/${pickedDate.year}';

    setState(() {
      answers[fieldId] = formatted;
      getController(fieldId).text = formatted;
    });
  }

  Widget buildField(Map<String, dynamic> field) {
    final fieldId = field["fieldId"];
    final type = field["type"];

    if (field.containsKey("visibleWhen")) {
      final visibleWhen = field["visibleWhen"];

      if (answers[visibleWhen["field"]] !=
          visibleWhen["equals"]) {
        return const SizedBox();
      }
    }

    IconData icon = Icons.edit;

    switch (fieldId) {
      case "fullName":
        icon = Icons.person;
        break;

      case "phoneNumber":
        icon = Icons.phone;
        break;

      case "emailAddress":
        icon = Icons.email;
        break;

      case "dateOfBirth":
        icon = Icons.calendar_today;
        break;

      case "gender":
        icon = Icons.diversity_3;
        break;
    }

    switch (type) {
      case "text":
      case "email":
      case "phone":
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: getController(fieldId),
            keyboardType: type == "email"
                ? TextInputType.emailAddress
                : type == "phone"
                    ? TextInputType.phone
                    : TextInputType.text,
            inputFormatters: type == "phone"
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
            decoration: InputDecoration(
              labelText: field["label"],
              hintText: type == "phone"
                  ? "9123456789"
                  : field["hint"],
              prefixText:
                  type == "phone" ? "+63 " : null,
              prefixStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return '${field["label"]} is required';
              }

              if (fieldId == "fullName" &&
                  value.trim().length < 3) {
                return 'Minimum 3 characters';
              }

              if (type == "email") {
                if (!value.contains('@') ||
                    !value.contains('.')) {
                  return 'Enter a valid email';
                }
              }

              if (type == "phone") {
                if (value.length != 10) {
                  return 'Must be exactly 10 digits';
                }
              }

              return null;
            },
            onChanged: (value) {
              if (type == "phone") {
                answers[fieldId] = "+63 $value";
              } else {
                answers[fieldId] = value;
              }
            },
          ),
        );

      case "date":
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: getController(fieldId),
            readOnly: true,
            onTap: () => selectDate(fieldId),
            decoration: InputDecoration(
              labelText: field["label"],
              hintText: field["hint"],
              prefixIcon:
                  const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Date of Birth is required';
              }
              return null;
            },
          ),
        );

      case "dropdown":
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field["label"],
              prefixIcon:
                  const Icon(Icons.diversity_3),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty) {
                return '${field["label"]} is required';
              }

              return null;
            },
            items: (field["options"] as List)
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e.toString(),
                    child: Text(e.toString()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                answers[fieldId] = value;
              });
            },
          ),
        );

      default:
        return const SizedBox();
    }
  }
  
  Widget buildFormStep(
      Map<String, dynamic> step) {
    final fields = step['fields'] as List;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: fields
                  .map<Widget>(
                    (field) =>
                        buildField(field),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context)
                    .unfocus();

                if (_formKey.currentState!
                    .validate()) {
                  nextStep();
                }
              },
              child: const Text(
                'Continue',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTermsStep(Map<String, dynamic> step) {
    bool accepted = answers['termsAccepted'] == true;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  step['content'],
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
            CheckboxListTile(
              value: accepted,
              onChanged: (value) {
                setLocalState(() {
                  accepted = value ?? false;
                });

                answers['termsAccepted'] = accepted;
              },
              title: const Text('I Agree'),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: accepted ? nextStep : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildReviewStep() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: answers.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString()),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: nextStep,
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  Widget buildSuccessStep(Map<String, dynamic> step) {
    final fullName = answers['fullName'] ?? 'Bestie';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.celebration,
            color: Colors.pink,
            size: 120,
          ),
          const SizedBox(height: 20),
          Text(
            step['title'] ?? 'Welcome!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your account has been created, $fullName 🌈',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  Widget buildCurrentStep(Map<String, dynamic> step) {
  switch (step["screenType"]) {
    case "form":
      return buildFormStep(step);

    case "terms":
      return buildTermsStep(step);

    case "account-selection":
      return buildAccountSelectionStep(step);

    case "review":
      return buildReviewStep();

    case "success":
      return buildSuccessStep(step);

    default:
      return const Center(
        child: Text("Unsupported step type"),
      );
  }
}

  Widget buildAccountSelectionStep(
      Map<String, dynamic> step) {
    final accounts = step["accounts"] as List;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: RadioListTile<String>(
                  value: account["value"],
                  groupValue: answers["selectedAccount"],
                  title: Text(
                    account["label"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(account["tagline"]),
                      const SizedBox(height: 8),

                      ...(account["features"]
                              as List)
                          .map(
                        (feature) => Padding(
                          padding:
                              const EdgeInsets.only(
                                  bottom: 4),
                          child: Text(
                            "• $feature",
                          ),
                        ),
                      ),
                    ],
                  ),
                  onChanged: (value) {
                    setState(() {
                      answers["selectedAccount"] =
                          value;
                    });
                  },
                ),
              );
            },
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                answers["selectedAccount"] ==
                        null
                    ? null
                    : nextStep,
            child: const Text(
              "Continue",
            ),
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final step = steps[currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(journey!['journeyName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentStepIndex + 1) / steps.length,
              minHeight: 8,
            ),

            const SizedBox(height: 16),

            Text(
              'Step ${currentStepIndex + 1} of ${steps.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
              ),
              child: const Icon(
                Icons.account_balance,
                color: Colors.white,
                size: 45,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              step['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (step['subtitle'] != null) ...[
              const SizedBox(height: 8),
              Text(
                step['subtitle'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],

            const SizedBox(height: 24),

            Expanded(
              child: buildCurrentStep(step),
            ),

            if (currentStepIndex > 0 &&
                step['screenType'] != 'success')
              TextButton(
                onPressed: previousStep,
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}