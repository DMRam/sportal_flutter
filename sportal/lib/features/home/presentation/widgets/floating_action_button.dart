import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/data/dummy_data.dart';

class SportalFloatingActionButton extends StatefulWidget {
  final AppTheme theme;
  final VoidCallback? onPressed;
  final bool showEventDialog;
  final IconData? icon;
  final Function(Map<String, dynamic>)? onCreateEvent;

  const SportalFloatingActionButton({
    super.key,
    required this.theme,
    this.onPressed,
    this.showEventDialog = false,
    this.icon,
    this.onCreateEvent,
  });

  @override
  State<SportalFloatingActionButton> createState() =>
      _SportalFloatingActionButtonState();
}

class _SportalFloatingActionButtonState
    extends State<SportalFloatingActionButton> {
  

  bool _isLoading = false;
  int _currentStep = 0;
  String? _selectedSportId;
  List<String> _selectedParticipants = [];
  String _eventName = '';
  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  String _location = '';
  int _maxParticipants = 2;
  String _description = '';
  final List<Map<String, dynamic>> sports = availableSports;


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed:
          _isLoading
              ? null
              : () async {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                } else if (widget.showEventDialog) {
                  setState(() {
                    _isLoading = true;
                    _currentStep = 0;
                    _selectedSportId = null;
                    _selectedParticipants = [];
                  });
                  await _showEventCreationDialog(context);
                  setState(() => _isLoading = false);
                }
              },
      backgroundColor: widget.theme.primaryColor,
      elevation: 4.0,
      highlightElevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child:
          _isLoading
              ? CircularProgressIndicator(
                color: widget.theme.backgroundColor,
                strokeWidth: 3,
              )
              : Icon(widget.icon ?? Icons.add, size: 28),
    );
  }

  Future<void> _showEventCreationDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              backgroundColor: widget.theme.cardColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with step indicator - unchanged
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getStepTitle(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: widget.theme.primaryTextColor,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: widget.theme.secondaryTextColor,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStepIndicator(),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Content area - pass setStateDialog instead of setState
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildStepContent(
                          context,
                          formKey,
                          _eventName,
                          _eventDate,
                          _eventTime,
                          _location,
                          _maxParticipants,
                          _description,
                          setStateDialog, // Changed to setStateDialog
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Navigation buttons - pass setStateDialog
                      _buildNavigationButtons(
                        context,
                        formKey,
                        _eventName,
                        _eventDate,
                        _eventTime,
                        _location,
                        _maxParticipants,
                        _description,
                        setStateDialog, // Changed to setStateDialog
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null && widget.onCreateEvent != null) {
        widget.onCreateEvent!(result);
      }
    });
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Choose Sport';
      case 1:
        return 'Select Opponents';
      case 2:
        return 'Event Details';
      default:
        return 'Create Challenge';
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      _currentStep >= index
                          ? widget.theme.primaryColor
                          : Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color:
                          _currentStep >= index
                              ? widget.theme.buttonTextColor
                              : widget.theme.secondaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getStepLabel(index),
                style: TextStyle(
                  color:
                      _currentStep == index
                          ? widget.theme.primaryColor
                          : widget.theme.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _getStepLabel(int index) {
    switch (index) {
      case 0:
        return 'Sport';
      case 1:
        return 'Opponents';
      case 2:
        return 'Details';
      default:
        return '';
    }
  }

  Widget _buildStepContent(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String eventName,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String location,
    int maxParticipants,
    String description,
    StateSetter setState,
  ) {
    switch (_currentStep) {
      case 0:
        return _buildSportSelectionStep(setState);
      case 1:
        return _buildParticipantSelectionStep(setState); // Pass setState here
      case 2:
        return _buildEventDetailsStep(
          formKey,
          eventName,
          eventDate,
          eventTime,
          location,
          maxParticipants,
          description,
          setState,
        );
      default:
        return Container();
    }
  }

  Widget _buildSportSelectionStep([StateSetter? setStateDialog]) {
    return Column(
      children:
          sports.map((sport) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color:
                    _selectedSportId == sport['id']
                        ? widget.theme.primaryColor.withOpacity(0.1)
                        : widget.theme.cardColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setStateDialog!(() {
                      // Use the provided setStateDialog
                      _selectedSportId = sport['id'];
                      _selectedParticipants = [];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            _selectedSportId == sport['id']
                                ? widget.theme.primaryColor
                                : Colors.grey.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          sport['icon'],
                          size: 32,
                          color: widget.theme.primaryColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sport['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: widget.theme.primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${sport['participants'].length} available players',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.theme.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_selectedSportId == sport['id'])
                          Icon(
                            Icons.check_circle,
                            color: widget.theme.primaryColor,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  void _toggleParticipantSelection(String participantId) {
    if (_selectedParticipants.contains(participantId)) {
      _selectedParticipants.remove(participantId);
    } else {
      _selectedParticipants.add(participantId);
    }
  }

  Widget _buildParticipantSelectionStep([StateSetter? setStateDialog]) {
    if (_selectedSportId == null) return Container();

    final sport = sports.firstWhere(
      (sport) => sport['id'] == _selectedSportId,
    );
    final participants = sport['participants'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select your opponents (${_selectedParticipants.length} selected)',
          style: TextStyle(fontSize: 16, color: widget.theme.primaryTextColor),
        ),
        const SizedBox(height: 16),
        ...participants.map<Widget>((participant) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color:
                  _selectedParticipants.contains(participant['id'])
                      ? widget.theme.primaryColor.withOpacity(0.1)
                      : widget.theme.cardColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (setStateDialog != null) {
                    setStateDialog(() {
                      _toggleParticipantSelection(participant['id']);
                    });
                  } else {
                    setState(() {
                      _toggleParticipantSelection(participant['id']);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _selectedParticipants.contains(participant['id'])
                              ? widget.theme.primaryColor
                              : Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.theme.primaryColor.withOpacity(
                          0.2,
                        ),
                        child: Text(
                          participant['avatar'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participant['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: widget.theme.primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getSkillLevelColor(
                                      participant['skillLevel'],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    participant['skillLevel'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: _selectedParticipants.contains(
                          participant['id'],
                        ),
                        onChanged: (value) {
                          if (setStateDialog != null) {
                            setStateDialog(() {
                              _toggleParticipantSelection(participant['id']);
                            });
                          } else {
                            setState(() {
                              _toggleParticipantSelection(participant['id']);
                            });
                          }
                        },
                        activeColor: widget.theme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getSkillLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEventDetailsStep(
    GlobalKey<FormState> formKey,
    String eventName,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String location,
    int maxParticipants,
    String description,
    StateSetter setState,
  ) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Event Name
          TextFormField(
            decoration: _buildInputDecoration(
              context,
              label: 'Challenge Name',
              hint: 'e.g. Weekend Football Match',
              icon: Icons.emoji_events,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onChanged: (value) => setState(() => _eventName = value),
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
          ),
          const SizedBox(height: 20),

          // Date and Time Pickers
          Row(
            children: [
              Expanded(
                child: _buildDateTimePicker(
                  context,
                  label:
                      _eventDate == null
                          ? 'Select Date'
                          : DateFormat(
                            'MM/dd/yy',
                          ).format(_eventDate!), // Shorter date format
                  icon: Icons.calendar_today,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selectedDate != null) {
                      setState(() => _eventDate = selectedDate);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDateTimePicker(
                  context,
                  label:
                      _eventTime == null
                          ? 'Select Time'
                          : _eventTime!.format(context),
                  icon: Icons.access_time,
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() => _eventTime = selectedTime);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Location
          TextFormField(
            decoration: _buildInputDecoration(
              context,
              label: 'Location',
              hint: 'e.g. Central Park, Field #3',
              icon: Icons.location_on,
            ),
            onChanged: (value) => setState(() => _location = value),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Please enter a location'
                        : null,
          ),
          const SizedBox(height: 20),

          // Description
          TextFormField(
            decoration: _buildInputDecoration(
              context,
              label: 'Description (Optional)',
              icon: Icons.description,
            ),
            onChanged: (value) => setState(() => _description = value),
          ),
          const SizedBox(height: 20),

          // Max Participants
          TextFormField(
            decoration: _buildInputDecoration(
              context,
              label: 'Max Participants',
              icon: Icons.people,
            ),
            onChanged:
                (value) =>
                    setState(() => _maxParticipants = int.tryParse(value) ?? 2),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context, {
    required String label,
    String? hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: widget.theme.backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: Icon(icon, color: widget.theme.primaryColor),
      labelStyle: TextStyle(color: widget.theme.secondaryTextColor),
      hintStyle: TextStyle(
        color: widget.theme.secondaryTextColor.withOpacity(0.6),
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(color: widget.theme.primaryTextColor, fontSize: 16);
  }

  Widget _buildDateTimePicker(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ), // Reduced padding
        decoration: BoxDecoration(
          color: widget.theme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(minWidth: 100), // Add minimum width
        child: Row(
          mainAxisSize: MainAxisSize.min, // Use min to avoid overflow
          children: [
            Icon(
              icon,
              color: widget.theme.primaryColor,
              size: 20,
            ), // Smaller icon
            const SizedBox(width: 8),
            Flexible(
              // Use Flexible to allow text to wrap
              child: Text(
                label,
                style: TextStyle(
                  color: widget.theme.primaryTextColor, // Fixed text color
                  fontSize: 14, // Smaller font size
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String eventName,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String location,
    int maxParticipants,
    String description,
    StateSetter setStateDialog, // Renamed parameter to be clear
  ) {
    return Row(
      children: [
        if (_currentStep > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setStateDialog(() => _currentStep--); // Use setStateDialog
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: widget.theme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: widget.theme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: ElevatedButton(
            onPressed:
                () => _handleNextButton(
                  context,
                  formKey,
                  eventName,
                  eventDate,
                  eventTime,
                  location,
                  maxParticipants,
                  description,
                  setStateDialog,
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.theme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentStep == 2 ? 'Create Challenge' : 'Continue',
              style: TextStyle(
                color: widget.theme.buttonTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNextButton(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String eventName,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String location,
    int maxParticipants,
    String description,
    StateSetter setStateDialog, // Renamed parameter
  ) {
    // Step 0 validation (Sport selection)
    if (_currentStep == 0 && _selectedSportId == null) {
      _showErrorSnackbar(context, 'Please select a sport');
      return;
    }

    // Step 1 validation (Participant selection)
    if (_currentStep == 1 && _selectedParticipants.isEmpty) {
      _showErrorSnackbar(context, 'Please select at least one opponent');
      return;
    }

    // Step 2 validation (Form validation)
    if (_currentStep == 2) {
      if (formKey.currentState?.validate() ?? false) {
        if (eventDate == null || eventTime == null) {
          _showErrorSnackbar(context, 'Please select both date and time');
          return;
        }

        _createEventAndClose(
          context,
          eventName,
          eventDate!,
          eventTime!,
          location,
          maxParticipants,
          description,
        );
      }
      return;
    }

    // Move to next step if not on last step
    setStateDialog(() => _currentStep++);
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _createEventAndClose(
    BuildContext context,
    String eventName,
    DateTime eventDate,
    TimeOfDay eventTime,
    String location,
    int maxParticipants,
    String description,
  ) {
    if (_selectedSportId == null) {
      _showErrorSnackbar(context, 'Please select a sport');
      return;
    }

    final selectedSport = sports.firstWhere(
      (sport) => sport['id'] == _selectedSportId,
    );

    final selectedOpponents =
        selectedSport['participants']
            .where((p) => _selectedParticipants.contains(p['id']))
            .toList();

    final eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );

    Navigator.of(context).pop({
      'sport': selectedSport['name'],
      'sportId': _selectedSportId,
      'eventName': _eventName,
      'eventDateTime': eventDateTime,
      'location': _location,
      'maxParticipants': _maxParticipants,
      'description': _description,
      'opponents': selectedOpponents,
    });
  }
}

// Custom Checkbox to match the theme
class Checkbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;

  const Checkbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: value ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: value ? activeColor ?? Colors.blue : Colors.grey,
          width: 2,
        ),
      ),
      child:
          value ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }
}
