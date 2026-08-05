import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'dashboard_screen.dart';

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
    final raw = await rootBundle.loadString('lib/journeys/gbbt_onboarding.json');
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
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );

    if (pickedDate == null) return;

    final formatted = '${pickedDate.month}/${pickedDate.day}/${pickedDate.year}';

    setState(() {
      answers[fieldId] = formatted;
      getController(fieldId).text = formatted;
    });
  }

  Widget buildField(Map<String, dynamic> field, bool isLgbtMode) {
    final fieldId = field["fieldId"];
    final type = field["type"];

    if (field.containsKey("visibleWhen")) {
      final visibleWhen = field["visibleWhen"];
      if (answers[visibleWhen["field"]] != visibleWhen["equals"]) {
        return const SizedBox();
      }
    }

    IconData icon = Icons.edit_note_rounded;

    switch (fieldId) {
      case "fullName":
        icon = Icons.badge_outlined;
        break;
      case "phoneNumber":
        icon = Icons.phone_outlined;
        break;
      case "emailAddress":
        icon = Icons.email_outlined;
        break;
      case "dateOfBirth":
        icon = Icons.cake_outlined;
        break;
      case "gender":
        icon = Icons.diversity_3_outlined;
        break;
    }

    switch (type) {
      case "text":
      case "email":
      case "phone":
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field["label"],
                style: isLgbtMode
                    ? GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)
                    : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: getController(fieldId),
                keyboardType: type == "email"
                    ? TextInputType.emailAddress
                    : type == "phone"
                        ? TextInputType.phone
                        : TextInputType.text,
                inputFormatters: type == "phone"
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                decoration: InputDecoration(
                  hintText: type == "phone" ? "09171234567" : field["hint"],
                  prefixIcon: Icon(icon, color: isLgbtMode ? AppColors.hotPink : Colors.black, size: 22),
                  prefixText: type == "phone" ? "+63 " : null,
                  prefixStyle: isLgbtMode
                      ? GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.ink)
                      : GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '${field["label"]} is required';
                  }
                  if (fieldId == "fullName" && value.trim().length < 3) {
                    return 'Minimum 3 characters required';
                  }
                  if (type == "email") {
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email address';
                    }
                  }
                  if (type == "phone") {
                    if (value.length != 10 && value.length != 11) {
                      return 'Enter a valid 10 or 11 digit number';
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
            ],
          ),
        );

      case "date":
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field["label"],
                style: isLgbtMode
                    ? GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)
                    : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: getController(fieldId),
                readOnly: true,
                onTap: () => selectDate(fieldId),
                decoration: InputDecoration(
                  hintText: field["hint"] ?? "MM/DD/YYYY",
                  prefixIcon: Icon(Icons.cake_outlined, color: isLgbtMode ? AppColors.neonGold : Colors.black, size: 22),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date of Birth is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      case "dropdown":
        final options = (field["options"] as List).cast<String>();
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field["label"],
                style: isLgbtMode
                    ? GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)
                    : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: answers[fieldId],
                decoration: InputDecoration(
                  hintText: field["hint"] ?? "Select ${field["label"]}",
                  prefixIcon: Icon(icon, color: isLgbtMode ? AppColors.electricPurple : Colors.black, size: 22),
                ),
                items: options
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(
                          option,
                          style: isLgbtMode ? GoogleFonts.fredoka(fontSize: 14) : GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    answers[fieldId] = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select ${field["label"]}';
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      default:
        return const SizedBox();
    }
  }

  Widget buildFormStep(Map<String, dynamic> step, bool isLgbtMode) {
    final fields = step["fields"] as List;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: fields.map<Widget>((field) => buildField(field, isLgbtMode)).toList(),
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: isLgbtMode ? 'Continue ✨' : 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                nextStep();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTermsStep(Map<String, dynamic> step, bool isLgbtMode) {
    bool accepted = answers['termsAccepted'] == true;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isLgbtMode ? 22 : 12),
                  border: Border.all(color: isLgbtMode ? AppColors.line : const Color(0xFFCBD5E1), width: 1.5),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    step['content'],
                    style: GoogleFonts.inter(fontSize: 13.5, height: 1.55, color: isLgbtMode ? AppColors.ink : Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isLgbtMode ? 18 : 12),
                border: Border.all(
                  color: accepted
                      ? (isLgbtMode ? AppColors.hotPink : Colors.black)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(isLgbtMode ? 18 : 12),
                child: CheckboxListTile(
                  value: accepted,
                  activeColor: isLgbtMode ? AppColors.hotPink : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onChanged: (value) {
                    setLocalState(() {
                      accepted = value ?? false;
                    });
                    answers['termsAccepted'] = accepted;
                  },
                  title: Text(
                    isLgbtMode ? 'I Agree to the Terms & Conditions 💖' : 'I Agree to the Terms & Conditions',
                    style: isLgbtMode
                        ? GoogleFonts.fredoka(fontWeight: FontWeight.w600, color: AppColors.ink)
                        : GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: isLgbtMode ? 'Continue 🚀' : 'Continue',
              icon: Icons.check_circle_rounded,
              onPressed: accepted ? nextStep : null,
            ),
          ],
        );
      },
    );
  }

  Widget buildAccountSelectionStep(Map<String, dynamic> step, bool isLgbtMode) {
    final accounts = step["accounts"] as List;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              final isSelected = answers["selectedAccount"] == account["value"];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isLgbtMode ? AppColors.hotPink.withOpacity(0.08) : const Color(0xFFF1F5F9))
                      : Colors.white,
                  borderRadius: BorderRadius.circular(isLgbtMode ? 22 : 12),
                  border: Border.all(
                    color: isSelected
                        ? (isLgbtMode ? AppColors.hotPink : Colors.black)
                        : const Color(0xFFCBD5E1),
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: isSelected && isLgbtMode ? AppShadow.soft : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(isLgbtMode ? 22 : 12),
                  child: RadioListTile<String>(
                    value: account["value"],
                    groupValue: answers["selectedAccount"],
                    activeColor: isLgbtMode ? AppColors.hotPink : Colors.black,
                    title: Text(
                      account["label"],
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.ink,
                            )
                          : GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          account["tagline"],
                          style: GoogleFonts.inter(
                            color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...(account["features"] as List).map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 16,
                                  color: isLgbtMode ? AppColors.hotPink : Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    feature.toString(),
                                    style: isLgbtMode
                                        ? GoogleFonts.fredoka(fontSize: 13, color: AppColors.ink)
                                        : GoogleFonts.inter(fontSize: 13, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onChanged: (value) {
                      setState(() {
                        answers["selectedAccount"] = value;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: isLgbtMode ? 'Continue 👑' : 'Continue',
          icon: Icons.star_rounded,
          onPressed: answers["selectedAccount"] == null ? null : nextStep,
        ),
      ],
    );
  }

  Widget buildReviewStep(bool isLgbtMode) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isLgbtMode ? 24 : 12),
              border: Border.all(color: isLgbtMode ? AppColors.line : const Color(0xFFCBD5E1), width: 1.5),
            ),
            child: ListView(
              children: answers.entries.map((entry) {
                if (entry.key == 'termsAccepted') return const SizedBox();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLgbtMode ? AppColors.cream : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(isLgbtMode ? 16 : 8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(fontWeight: FontWeight.w600, color: AppColors.inkMuted, fontSize: 13)
                            : GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 13),
                      ),
                      Text(
                        entry.value.toString(),
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.hotPink, fontSize: 15)
                            : GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(
          label: isLgbtMode ? 'Submit & Slay! 💅' : 'Create Account',
          icon: Icons.rocket_launch_rounded,
          onPressed: () {
            if (isLgbtMode) FunAudioPlayer.playPopupFanfare();
            nextStep();
          },
        ),
      ],
    );
  }

  Widget buildSuccessStep(Map<String, dynamic> step, bool isLgbtMode) {
    final name = answers['fullName']?.toString() ?? 'Bestie';
    final nameParts = name.trim().split(RegExp(r'\s+'));
    final phone = answers['phoneNumber']?.toString() ?? '09171234567';
    final email = answers['emailAddress']?.toString() ?? 'user@fabulous.com';
    final dob = answers['dateOfBirth']?.toString() ?? '10/24/2000';
    final gender = answers['gender']?.toString() ?? 'Non-Binary';

    DateTime dobDate;
    try {
      final parts = dob.split('/');
      dobDate = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
    } catch (_) {
      dobDate = DateTime(2000, 1, 1);
    }

    final newUser = UserModel(
      firstName: nameParts.first,
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      email: email,
      phone: phone,
      dateOfBirth: dobDate,
      gender: gender,
      taxBracket: taxBrackets.first,
      savings: 10000,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: isLgbtMode ? electricRainbowGradient : null,
              color: isLgbtMode ? null : Colors.black,
              shape: BoxShape.circle,
              boxShadow: isLgbtMode ? AppShadow.neonGlow : null,
            ),
            child: const Center(
              child: Text('🥳', style: TextStyle(fontSize: 54)),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            step['title'] ?? 'Welcome to GBBT!',
            textAlign: TextAlign.center,
            style: isLgbtMode
                ? GoogleFonts.fredoka(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  )
                : GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
          ),
          const SizedBox(height: 10),

          Text(
            'Your account has been created, ${newUser.firstName}! ₱1,000 Starter Bonus added to your vault!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 36),

          GradientButton(
            label: isLgbtMode ? 'Enter GBBT Vault ✨' : 'Enter Dashboard',
            icon: Icons.key_rounded,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => DashboardScreen(user: newUser)),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCurrentStep(Map<String, dynamic> step, bool isLgbtMode) {
    switch (step["screenType"]) {
      case "form":
        return buildFormStep(step, isLgbtMode);
      case "terms":
        return buildTermsStep(step, isLgbtMode);
      case "account-selection":
        return buildAccountSelectionStep(step, isLgbtMode);
      case "review":
        return buildReviewStep(isLgbtMode);
      case "success":
        return buildSuccessStep(step, isLgbtMode);
      default:
        return const Center(child: Text("Unsupported step type"));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.hotPink),
        ),
      );
    }

    final step = steps[currentStepIndex];

    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Scaffold(
          body: BonggaBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    // Top Header Row
                    Row(
                      children: [
                        if (currentStepIndex > 0 && step['screenType'] != 'success')
                          IconButton(
                            onPressed: previousStep,
                            icon: Icon(Icons.arrow_back_ios_new, size: 18, color: isLgbtMode ? AppColors.ink : Colors.black),
                            style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                          )
                        else
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close_rounded, size: 20, color: isLgbtMode ? AppColors.ink : Colors.black),
                            style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RainbowShimmerText(text: journey!['journeyName'], fontSize: 20),
                        ),
                        InteractiveSticker(
                          text: 'STEP ${currentStepIndex + 1}/${steps.length}',
                          backgroundColor: isLgbtMode ? AppColors.neonGold : const Color(0xFFF1F5F9),
                          textColor: Colors.black,
                          rotateAngle: isLgbtMode ? 0.04 : 0.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: (currentStepIndex + 1) / steps.length,
                        minHeight: 10,
                        backgroundColor: isLgbtMode ? AppColors.line : const Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation<Color>(isLgbtMode ? AppColors.hotPink : Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Step Content Card
                    Expanded(
                      child: BonggaCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          children: [
                            if (step['screenType'] != 'success') ...[
                              const RainbowMark(size: 64),
                              const SizedBox(height: 12),
                              Text(
                                step['title'],
                                textAlign: TextAlign.center,
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      )
                                    : GoogleFonts.inter(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                              ),
                              if (step['subtitle'] != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  step['subtitle'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                            ],
                            Expanded(
                              child: buildCurrentStep(step, isLgbtMode),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}