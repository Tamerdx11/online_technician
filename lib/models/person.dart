class PersonModel{
  String? name;
  String? uId;
  String? userImage;
  String? location;
  Map<String, dynamic>? chatList;
  Map<String, dynamic>? notificationList;
  Map<String, dynamic>? sentRequests;
  Map<String, dynamic>? receivedRequests;

  PersonModel({
    this.name,
    this.userImage,
    this.uId,
    this.location,
    this.chatList,
    this.sentRequests,
    this.receivedRequests,
    this.notificationList
  });

}