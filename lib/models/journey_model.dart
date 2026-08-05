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

  @override
  void initState() {
    super.initState();
    loadJourney();
  }

  Future<void> loadJourney() async {
    final raw = await rootBundle.loadString(
      'assets/journeys/gbbt_onboarding.json',
    );

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

  List<dynamic> get steps => journey!["steps"];

  TextEditingController getController(String id) {
    if (!controllers.containsKey(id)) {
      controllers[id] = TextEditingController();
    }

    return controllers[id]!;
  }

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
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    final value =
        '${date.month}/${date.day}/${date.year}';

    answers[fieldId] = value;
    getController(fieldId).text = value;
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

    switch (type) {
      case "text":
      case "email":
      case "phone":
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: getController(fieldId),
            keyboardType: type == "email"
                ? TextInputType.emailAddress
                : type == "phone"
                    ? TextInputType.phone
                    : TextInputType.text,
            decoration: InputDecoration(
              labelText: field["label"],
              hintText: field["hint"],
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              answers[fieldId] = value;
            },
          ),
        );

      case "date":
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: getController(fieldId),
            readOnly: true,
            onTap: () => selectDate(fieldId),
            decoration: InputDecoration(
              labelText: field["label"],
              hintText: field["hint"],
              border: const OutlineInputBorder(),
            ),
          ),
        );

      case "dropdown":
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field["label"],
              border: const OutlineInputBorder(),
            ),
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

  Widget buildFormStep(Map<String, dynamic> step) {
    final fields = step["fields"] as List;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children:
                fields.map<Widget>((field) {
              return buildField(field);
            }).toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              for (final field in fields) {
                if (field["required"] == true) {
                  final value =
                      answers[field["fieldId"]];

                  if (value == null ||
                      value.toString().trim().isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          '${field["label"]} is required',
                        ),
                      ),
                    );
                    return;
                  }
                }
              }

              nextStep();
            },
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }

  Widget buildTermsStep(Map<String, dynamic> step) {
    bool accepted =
        answers["termsAccepted"] == true;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  step["content"],
                  style: const TextStyle(
                    height: 1.5,
                  ),
                ),
              ),
            ),
            CheckboxListTile(
              value: accepted,
              title: const Text("I Agree"),
              onChanged: (value) {
                setLocalState(() {
                  accepted = value ?? false;
                });

                answers["termsAccepted"] =
                    accepted;
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    accepted ? nextStep : null,
                child: const Text("Continue"),
              ),
            )
          ],
        );
      },
    );
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
                margin:
                    const EdgeInsets.only(bottom: 16),
                child: RadioListTile<String>(
                  value: account["value"],
                  groupValue:
                      answers["selectedAccount"],
                  title: Text(
                    account["label"],
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        account["tagline"],
                      ),
                      const SizedBox(height: 8),
                      ...(account["features"]
                              as List)
                          .map(
                        (feature) => Text(
                          "• $feature",
                        ),
                      ),
                    ],
                  ),
                  onChanged: (value) {
                    setState(() {
                      answers[
                          "selectedAccount"] = value;
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
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }

  Widget buildReviewStep() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: answers.entries
                .map(
                  (entry) => ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      entry.value.toString(),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: nextStep,
            child: const Text("Submit"),
          ),
        ),
      ],
    );
  }

  Widget buildSuccessStep(
      Map<String, dynamic> step) {
    final name =
        answers["fullName"] ?? "Bestie";

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.celebration,
            size: 120,
            color: Colors.pink,
          ),
          const SizedBox(height: 20),
          Text(
            step["title"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Your account has been created, $name 🌈",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Finish"),
          )
        ],
      ),
    );
  }

  Widget buildCurrentStep(
      Map<String, dynamic> step) {
    switch (step["screenType"]) {
      case "form":
        return buildFormStep(step);

      case "terms":
        return buildTermsStep(step);

      case "account-selection":
        return buildAccountSelectionStep(
            step);

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
        title: Text(
          journey!["journeyName"],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value:
                  (currentStepIndex + 1) /
                  steps.length,
            ),

            const SizedBox(height: 10),

            Text(
              "Step ${currentStepIndex + 1} of ${steps.length}",
            ),

            const SizedBox(height: 20),

            Text(
              step["title"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (step["subtitle"] != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: 6),
                child: Text(
                  step["subtitle"],
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 20),

            Expanded(
              child: buildCurrentStep(step),
            ),

            if (currentStepIndex > 0 &&
                step["screenType"] !=
                    "success")
              TextButton(
                onPressed: previousStep,
                child: const Text("Back"),
              ),
          ],
        ),
      ),
    );
  }
}