import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/src/widgets/animated_background.dart';
import 'package:pingpal/src/widgets/custom_app_bar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with NavBarPadding {
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
          Uri.parse(
              'https://pingpals-backend.onrender.com/addEvent'), // Ensure backend URL is correct
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
    final fillColor =
        Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6);
    final cardColor =
        Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6);
    final hintColor = Colors.white54;
    final textColor = Colors.white;
    final dividerColor = Colors.grey[700]!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16.0,
            left: 16.0,
            right: 16.0,
            bottom: NavBarPadding.getNavBarHeight(context) + 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C00).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.add_alert,
                        size: 28,
                        color: Color(0xFFFF8C00),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Create Ping',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFFFF8C00),
                      ),
                    ),
                  ],
                ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFullWidthCard(
                      theme,
                      cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Event Details',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFFFF8C00),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _titleController,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Event Title',
                              hintStyle: TextStyle(color: hintColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.3),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an event title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textColor,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Event Description',
                              labelStyle:
                                  TextStyle(color: hintColor, fontSize: 16),
                              hintStyle: TextStyle(color: hintColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.3),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an event description';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Date Picker Input
                    _buildSectionHeader('Date & Time', theme, isDarkMode),
                    const SizedBox(height: 16),
                    _buildFullWidthCard(
                      theme,
                      cardColor,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Event Date',
                              labelStyle:
                                  TextStyle(color: hintColor, fontSize: 16),
                              hintText: 'YYYY-MM-DD',
                              hintStyle: TextStyle(color: hintColor),
                              suffixIcon: Icon(Icons.calendar_today,
                                  color: const Color(0xFFFF8C00)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.3),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                            readOnly: true,
                            onTap: _selectDate,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date';
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: textColor, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _startTimeController,
                                  decoration: InputDecoration(
                                    labelText: 'Start Time',
                                    labelStyle: TextStyle(
                                        color: hintColor, fontSize: 16),
                                    hintStyle: TextStyle(color: hintColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: Icon(Icons.access_time,
                                        color: const Color(0xFFFF8C00)),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.3),
                                    contentPadding: const EdgeInsets.all(15),
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
                                      color: textColor, fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'to',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _endTimeController,
                                  decoration: InputDecoration(
                                    labelText: 'End Time',
                                    labelStyle: TextStyle(
                                        color: hintColor, fontSize: 16),
                                    hintStyle: TextStyle(color: hintColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: Icon(Icons.access_time,
                                        color: const Color(0xFFFF8C00)),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.3),
                                    contentPadding: const EdgeInsets.all(15),
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
                                      color: textColor, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Location', theme, isDarkMode),
                    const SizedBox(height: 16),
                    _buildLocationSection(
                        theme, textColor, hintColor, fillColor),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Capacity', theme, isDarkMode),
                    const SizedBox(height: 16),
                    _buildCapacitySection(theme, textColor, fillColor),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Invite Pals', theme, isDarkMode),
                    const SizedBox(height: 16),
                    _buildInvitePalsSection(theme, cardColor, dividerColor),
                    const SizedBox(height: 32),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C00),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8C00).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        width: 200,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _createEvent,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Ping!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFFF8C00).withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              title == 'Date & Time'
                  ? Icons.access_time
                  : title == 'Location'
                      ? Icons.location_on
                      : title == 'Capacity'
                          ? Icons.people
                          : Icons.person_add,
              size: 22,
              color: const Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
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
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }

  Widget _buildLocationSection(
      ThemeData theme, Color textColor, Color? hintColor, Color fillColor) {
    return _buildFullWidthCard(
      theme,
      fillColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLocationIconButton(
                  theme, Icons.discord, 0, 'Discord', isDarkMode),
              _buildLocationIconButton(
                  theme, Icons.map, 1, 'Google Maps', isDarkMode),
              _buildLocationIconButton(
                  theme, Icons.videocam, 2, 'Zoom', isDarkMode),
            ],
          ),
          const SizedBox(height: 20),
          if (_selectedLocationType == 0)
            Column(
              children: [
                TextFormField(
                  controller: _discordServerNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Discord Server Name',
                    hintStyle: TextStyle(color: hintColor, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          TextFormField(
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
              hintStyle: TextStyle(color: hintColor, fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              contentPadding: const EdgeInsets.all(15),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacitySection(
      ThemeData theme, Color textColor, Color fillColor) {
    return _buildFullWidthCard(
      theme,
      fillColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Participants Limit:',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_capacity',
                  style: TextStyle(
                    color: const Color(0xFFFF8C00),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _capacity.toDouble(),
              min: 1,
              max: 100,
              divisions: 99,
              activeColor: const Color(0xFFFF8C00),
              inactiveColor: const Color(0xFFFF8C00).withOpacity(0.3),
              label: '$_capacity',
              onChanged: (double value) {
                setState(() {
                  _capacity = value.toInt();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitePalsSection(
      ThemeData theme, Color cardColor, Color dividerColor) {
    return _buildFullWidthCard(
      theme,
      cardColor,
      child: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search for friends...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildFriendChip(
      String name, ThemeData theme, bool isDarkMode, Color dividerColor,
      {bool accepted = false}) {
    final chipColor = accepted
        ? const Color(0xFFFF8C00).withOpacity(0.2)
        : Colors.grey[800]?.withOpacity(0.4) ?? Colors.black.withOpacity(0.4);
    final textColor = Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accepted
              ? const Color(0xFFFF8C00).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          Icon(
            accepted ? Icons.check_circle : Icons.add_circle_outline,
            color: accepted ? const Color(0xFFFF8C00) : Colors.white54,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationIconButton(ThemeData theme, IconData icon, int index,
      String tooltip, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedLocationType == index
            ? const Color(0xFFFF8C00).withOpacity(0.2)
            : Colors.grey[800]?.withOpacity(0.2) ??
                Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedLocationType == index
              ? const Color(0xFFFF8C00).withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(
              tooltip,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
        iconSize: 24,
        color: _selectedLocationType == index
            ? const Color(0xFFFF8C00)
            : Colors.white54,
        onPressed: () {
          setState(() {
            _selectedLocationType = index;
          });
        },
      ),
    );
  }
}
