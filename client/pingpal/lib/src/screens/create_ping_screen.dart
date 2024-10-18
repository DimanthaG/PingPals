import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pingpal/src/models/event_model.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _discordServerController =
      TextEditingController();
  final TextEditingController _discordServerNameController =
      TextEditingController();
  final TextEditingController _googleMapsLinkController =
      TextEditingController();
  final TextEditingController _zoomRoomController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  int _capacity = 12;

  int _selectedLocationType = 0; // 0 for Discord, 1 for Google Maps, 2 for Zoom

  // Declare isDarkMode as a class variable
  late bool isDarkMode;

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        // Ensures the date picker adapts to the theme
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _selectTime({required bool isStartTime}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_selectedStartTime ?? TimeOfDay.now())
          : (_selectedEndTime ?? TimeOfDay.now()),
      builder: (context, child) {
        // Ensures the time picker adapts to the theme
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = pickedTime;
          _startTimeController.text = pickedTime.format(context);
        } else {
          _selectedEndTime = pickedTime;
          _endTimeController.text = pickedTime.format(context);
        }
      });
    }
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        title: _titleController.text,
        date: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        ),
        location: _selectedLocationType == 0
            ? '${_discordServerNameController.text}: ${_discordServerController.text}'
            : _selectedLocationType == 1
                ? _googleMapsLinkController.text
                : _zoomRoomController.text,
        description: _descriptionController.text,
      );
      // Handle event creation logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event "${event.title}" created!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
    final fillColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDarkMode ? Color(0xFF2A2A2A) : Colors.white;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Ping',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: const Color(0xFFFF8C00),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input with rounded edges and border
                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: TextFormField(
                    controller: _titleController,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Event Title',
                      hintStyle: TextStyle(
                        color: hintColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      filled: true,
                      fillColor: fillColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an event title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Event Description
                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Event Description',
                      labelStyle: TextStyle(
                        color: hintColor,
                      ),
                      hintStyle: TextStyle(
                        color: hintColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: fillColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an event description';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Event Location options with icons
                Text(
                  'Event Location',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLocationIconButton(
                        theme, Icons.discord, 0, 'Discord', isDarkMode),
                    _buildLocationIconButton(
                        theme, Icons.map, 1, 'Google Maps', isDarkMode),
                    _buildLocationIconButton(
                        theme, Icons.videocam, 2, 'Zoom', isDarkMode),
                  ],
                ),
                const SizedBox(height: 10),

                // Conditionally display the Discord Server Name input field
                if (_selectedLocationType == 0) ...[
                  _buildFullWidthCard(
                    theme,
                    cardColor,
                    child: TextFormField(
                      controller: _discordServerNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Discord Server Name',
                        hintStyle: TextStyle(
                          color: hintColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: fillColor,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: TextFormField(
                    controller: _selectedLocationType == 0
                        ? _discordServerController
                        : _selectedLocationType == 1
                            ? _googleMapsLinkController
                            : _zoomRoomController,
                    decoration: InputDecoration(
                      hintText: _selectedLocationType == 0
                          ? 'Enter Discord Server Link here...'
                          : _selectedLocationType == 1
                              ? 'Paste Google Maps Link...'
                              : 'Enter Zoom Room Code...',
                      hintStyle: TextStyle(
                        color: hintColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: fillColor,
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Time and Capacity
                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startTimeController,
                          decoration: InputDecoration(
                            labelText: 'Start Time',
                            labelStyle: TextStyle(color: hintColor),
                            hintStyle: TextStyle(
                              color: hintColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: theme.iconTheme.color,
                            ),
                            filled: true,
                            fillColor: fillColor,
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(isStartTime: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a start time';
                            }
                            return null;
                          },
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'to',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _endTimeController,
                          decoration: InputDecoration(
                            labelText: 'End Time',
                            labelStyle: TextStyle(color: hintColor),
                            hintStyle: TextStyle(
                              color: hintColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: theme.iconTheme.color,
                            ),
                            filled: true,
                            fillColor: fillColor,
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(isStartTime: false),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an end time';
                            }
                            return null;
                          },
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Capacity slider with value display
                Text(
                  'Capacity',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$_capacity',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Slider(
                        value: _capacity.toDouble(),
                        min: 1,
                        max: 100,
                        divisions: 99,
                        activeColor: theme.colorScheme.secondary,
                        inactiveColor:
                            theme.colorScheme.secondary.withOpacity(0.3),
                        label: '$_capacity',
                        onChanged: (double value) {
                          setState(() {
                            _capacity = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Invite Pals (Friends list)
                Text(
                  'Invite Pals',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView(
                      children: [
                        _buildFriendChip(
                            'Dimantha', theme, isDarkMode, dividerColor,
                            accepted: true),
                        _buildFriendChip(
                            'Nethma', theme, isDarkMode, dividerColor),
                        _buildFriendChip(
                            'Amantha', theme, isDarkMode, dividerColor,
                            accepted: true),
                        _buildFriendChip(
                            'Hakkam', theme, isDarkMode, dividerColor),
                        _buildFriendChip(
                            'Roosanda', theme, isDarkMode, dividerColor,
                            accepted: true),
                        _buildFriendChip(
                            'Sheveen', theme, isDarkMode, dividerColor),
                        _buildFriendChip(
                            'Adheeb', theme, isDarkMode, dividerColor),
                        _buildFriendChip(
                            'Thulana', theme, isDarkMode, dividerColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Ping button
                Center(
                  child: ElevatedButton(
                    onPressed: _createEvent,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                    ),
                    child: const Text(
                      'Ping!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendChip(
      String name, ThemeData theme, bool isDarkMode, Color dividerColor,
      {bool accepted = false}) {
    final chipColor = accepted
        ? theme.colorScheme.secondary.withOpacity(0.2)
        : (isDarkMode ? Color(0xFF2A2A2A) : theme.cardColor);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Text(
        name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildLocationIconButton(ThemeData theme, IconData icon, int index,
      String tooltip, bool isDarkMode) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      color: _selectedLocationType == index
          ? theme.colorScheme.secondary
          : (isDarkMode ? Colors.grey[400] : theme.iconTheme.color),
      onPressed: () {
        setState(() {
          _selectedLocationType = index;
        });
      },
    );
  }

  Widget _buildFullWidthCard(ThemeData theme, Color cardColor,
      {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          if (isDarkMode)
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
