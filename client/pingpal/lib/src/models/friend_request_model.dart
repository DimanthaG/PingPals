class FriendRequest {
  final String id;
  final String sender;
  final String receiver;
  final String status;
  final DateTime issuedTime;

  FriendRequest({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.status,
    required this.issuedTime,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['_id'],
      sender: json['sender'],
      receiver: json['receiver'],
      status: json['status'],
      issuedTime: DateTime.parse(json['issuedTime']),
    );
  }
}
