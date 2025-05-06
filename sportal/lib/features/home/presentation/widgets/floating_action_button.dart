import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // This will now work after adding the dependency
import 'package:sportal/core/app_theme.dart';

class SportalFloatingActionButton extends StatelessWidget {
  final AppTheme theme;
  final VoidCallback? onPressed;
  final bool showEventDialog;
  final IconData? icon;

  const SportalFloatingActionButton({
    super.key,
    required this.theme,
    this.onPressed,
    this.showEventDialog = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else if (showEventDialog) {
          _showEventCreationDialog(context);
        }
      },
      backgroundColor: theme.primaryColor,
      elevation: 4.0,
      highlightElevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Icon(icon ?? Icons.add),
    );
  }

  Future<void> _showEventCreationDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String? eventType;
    String eventName = '';
    DateTime? eventDate;
    TimeOfDay? eventTime;
    String location = '';
    int maxParticipants = 10;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Sportal Event'),
              scrollable: true,
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Event Type Dropdown
                    DropdownButtonFormField<String>(
                      items:
                          <String>[
                            'Match',
                            'Challenge',
                            'Tournament',
                            'League',
                            'Training',
                            'Friendly Game',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          eventType = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Event Type',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null
                                  ? 'Please select an event type'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    // Event Name TextField
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        hintText: 'e.g. Weekend Football Match',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an event name';
                        }
                        if (value.length < 5) {
                          return 'Name too short (min 5 chars)';
                        }
                        return null;
                      },
                      onChanged: (value) => eventName = value,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    ),
                    const SizedBox(height: 16),
                    // Date and Time Pickers
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              eventDate == null
                                  ? 'Select Date'
                                  : DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(eventDate!),
                            ),
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(
                                  const Duration(days: 1),
                                ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  eventDate = selectedDate;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              eventTime == null
                                  ? 'Select Time'
                                  : eventTime!.format(context),
                            ),
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  eventTime = selectedTime;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Location Input
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'e.g. Central Park, Field #3',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      onChanged: (value) => location = value,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter a location'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    // Max Participants
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Max Participants',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.people),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: maxParticipants.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter max participants';
                        }
                        final num = int.tryParse(value);
                        if (num == null || num < 2) {
                          return 'Minimum 2 participants';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        maxParticipants = int.tryParse(value) ?? 10;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (eventDate == null || eventTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select both date and time'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final eventDateTime = DateTime(
                        eventDate!.year,
                        eventDate!.month,
                        eventDate!.day,
                        eventTime!.hour,
                        eventTime!.minute,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$eventType "$eventName" created successfully!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  child: const Text('Create Event'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
