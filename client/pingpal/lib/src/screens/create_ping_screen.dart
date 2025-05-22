import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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

  late bool isDarkMode;
  String? jwtToken;
  String? userId;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadJwtToken();
  }

  // Load JWT and extract the userId from the JWT token.
  Future<void> _loadJwtToken() async {
    jwtToken = await _storage.read(key: 'jwtToken');
    if (jwtToken != null) {
      userId = _extractUserIdFromJwt(jwtToken!);
    }
  }

  // Function to extract userId (Google User's sub field) from the JWT.
  String _extractUserIdFromJwt(String jwtToken) {
    final parts = jwtToken.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT');
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> payloadMap = json.decode(payload);
    return payloadMap['sub']; // Google's userId (sub) claim
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
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

  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date for the event.')),
        );
        return;
      }

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID is not available. Please log in.')),
        );
        return;
      }

      // Combine the selected date and time into ISO 8601 format with a 'T'
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final startDateTime =
          '${formattedDate}T${_startTimeController.text}:00'; // Correctly formatted with 'T'
      final endDateTime =
          '${formattedDate}T${_endTimeController.text}:00'; // Correctly formatted with 'T'

      final event = {
        "title": _titleController.text,
        "description": _descriptionController.text,
        "date": formattedDate, // Correctly formatted date
        "startTime": startDateTime, // ISO 8601 format with 'T'
        "endTime": endDateTime, // ISO 8601 format with 'T'
        "location": {
          "platform": _selectedLocationType == 0
              ? "Discord"
              : _selectedLocationType == 1
                  ? "Google Maps"
                  : "Zoom",
          "link": _selectedLocationType == 0
              ? _discordServerController.text
              : _selectedLocationType == 1
                  ? _googleMapsLinkController.text
                  : _zoomRoomController.text,
          "details": _selectedLocationType == 0
              ? _discordServerNameController.text
              : null
        },
        "capacity": _capacity,
        "open": true,
        "creator": userId,
      };

      try {
        if (jwtToken == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('JWT token not found. Please log in again.')),
          );
          print('JWT Token is null.');
          return;
        }

        print('JWT Token: $jwtToken');
        print('Event Data: ${jsonEncode(event)}');

        final response = await http.post(
          Uri.parse('https://pingpals-backend.onrender.com/addEvent'), // Ensure backend URL is correct
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: jsonEncode(event),
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event "${event["title"]}" created!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to create event: ${response.body} (Code: ${response.statusCode})')),
          );
        }
      } catch (e) {
        print('Error creating event: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
        );
      }
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
                      hintStyle: TextStyle(color: hintColor),
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
                      labelStyle: TextStyle(color: hintColor),
                      hintStyle: TextStyle(color: hintColor),
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
                // Date Picker Input
                _buildFullWidthCard(
                  theme,
                  cardColor,
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Event Date',
                      hintText: 'YYYY-MM-DD',
                      hintStyle: TextStyle(color: hintColor),
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: fillColor,
                    ),
                    readOnly: true,
                    onTap: _selectDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                    style:
                        theme.textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLocationSection(theme, textColor, hintColor, fillColor),
                const SizedBox(height: 20),
                _buildTimeAndCapacitySection(theme, textColor, hintColor),
                const SizedBox(height: 20),
                _buildInvitePalsSection(theme, cardColor, dividerColor),
                const SizedBox(height: 20),
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

  Widget _buildLocationSection(
      ThemeData theme, Color textColor, Color? hintColor, Color fillColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (_selectedLocationType == 0)
          _buildFullWidthCard(
            theme,
            fillColor,
            child: TextFormField(
              controller: _discordServerNameController,
              decoration: InputDecoration(
                hintText: 'Enter Discord Server Name',
                hintStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: fillColor,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
            ),
          ),
        const SizedBox(height: 10),
        _buildFullWidthCard(
          theme,
          fillColor,
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
              hintStyle: TextStyle(color: hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: fillColor,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAndCapacitySection(
      ThemeData theme, Color textColor, Color? hintColor) {
    return Column(
      children: [
        _buildFullWidthCard(
          theme,
          theme.cardColor,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _startTimeController,
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    labelStyle: TextStyle(color: hintColor),
                    hintStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.access_time),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(isStartTime: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a start time';
                    }
                    return null;
                  },
                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
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
                    hintStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.access_time),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(isStartTime: false),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an end time';
                    }
                    return null;
                  },
                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
          theme.cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$_capacity',
                  style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Slider(
                value: _capacity.toDouble(),
                min: 1,
                max: 100,
                divisions: 99,
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.3),
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
      ],
    );
  }

  Widget _buildInvitePalsSection(
      ThemeData theme, Color cardColor, Color dividerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invite Pals',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
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
                _buildFriendChip('Dimantha', theme, isDarkMode, dividerColor,
                    accepted: true),
                _buildFriendChip('Nethma', theme, isDarkMode, dividerColor),
                _buildFriendChip('Amantha', theme, isDarkMode, dividerColor,
                    accepted: true),
                _buildFriendChip('Hakkam', theme, isDarkMode, dividerColor),
                _buildFriendChip('Roosanda', theme, isDarkMode, dividerColor,
                    accepted: true),
                _buildFriendChip('Sheveen', theme, isDarkMode, dividerColor),
                _buildFriendChip('Adheeb', theme, isDarkMode, dividerColor),
                _buildFriendChip('Thulana', theme, isDarkMode, dividerColor),
              ],
            ),
          ),
        ),
      ],
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
}
