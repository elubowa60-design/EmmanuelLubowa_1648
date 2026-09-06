import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

// ==================== USER MODELS ====================

enum UserRole {
  @JsonValue('farmer')
  farmer,
  @JsonValue('agent')
  agent,
  @JsonValue('admin')
  admin,
}

@JsonSerializable()
class User {
  final String id;
  final String phone;
  final String? email;
  @JsonKey(name: 'full_name')
  final String fullName;
  final UserRole role;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    this.email,
    required this.fullName,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'token_type')
  final String tokenType;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

// ==================== FARMER MODELS ====================

@JsonSerializable()
class Farmer {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String location;
  final String district;
  final String crops;
  @JsonKey(name: 'farm_size_acres')
  final double? farmSizeAcres;
  @JsonKey(name: 'agent_id')
  final String? agentId;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  final String? bio;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Farmer({
    required this.id,
    required this.userId,
    required this.location,
    required this.district,
    required this.crops,
    this.farmSizeAcres,
    this.agentId,
    this.profilePicture,
    this.bio,
    required this.createdAt,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) => _$FarmerFromJson(json);
  Map<String, dynamic> toJson() => _$FarmerToJson(this);
}

// ==================== PEST REPORT MODELS ====================

enum PestSeverity {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
}

enum PestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('treated')
  treated,
  @JsonValue('closed')
  closed,
}

@JsonSerializable()
class PestReport {
  final String id;
  @JsonKey(name: 'farmer_id')
  final String farmerId;
  @JsonKey(name: 'agent_id')
  final String? agentId;
  final String crop;
  @JsonKey(name: 'pest_name')
  final String pestName;
  final double confidence;
  final String description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final String treatment;
  final PestSeverity severity;
  final PestStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'treated_at')
  final DateTime? treatedAt;

  PestReport({
    required this.id,
    required this.farmerId,
    this.agentId,
    required this.crop,
    required this.pestName,
    required this.confidence,
    required this.description,
    this.imageUrl,
    required this.treatment,
    required this.severity,
    required this.status,
    required this.createdAt,
    this.treatedAt,
  });

  factory PestReport.fromJson(Map<String, dynamic> json) =>
      _$PestReportFromJson(json);
  Map<String, dynamic> toJson() => _$PestReportToJson(this);
}

// ==================== CROP PRICE MODELS ====================

@JsonSerializable()
class CropPrice {
  final String id;
  @JsonKey(name: 'crop_name')
  final String cropName;
  final double price;
  final String location;
  final String unit;
  final DateTime timestamp;

  CropPrice({
    required this.id,
    required this.cropName,
    required this.price,
    required this.location,
    required this.unit,
    required this.timestamp,
  });

  factory CropPrice.fromJson(Map<String, dynamic> json) =>
      _$CropPriceFromJson(json);
  Map<String, dynamic> toJson() => _$CropPriceToJson(this);
}

// ==================== AGENT MODELS ====================

@JsonSerializable()
class Agent {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String location;
  final String district;
  @JsonKey(name: 'farmers_count')
  final int farmersCount;
  final double balance;
  @JsonKey(name: 'total_earned')
  final double totalEarned;
  @JsonKey(name: 'id_verified')
  final bool idVerified;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Agent({
    required this.id,
    required this.userId,
    required this.location,
    required this.district,
    required this.farmersCount,
    required this.balance,
    required this.totalEarned,
    required this.idVerified,
    required this.createdAt,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);
  Map<String, dynamic> toJson() => _$AgentToJson(this);
}

// ==================== WEATHER ALERT ====================

@JsonSerializable()
class WeatherAlert {
  final String id;
  final String condition;  // "rain", "drought", "frost"
  final String message;
  final DateTime timestamp;
  @JsonKey(name: 'is_read')
  final bool isRead;

  WeatherAlert({
    required this.id,
    required this.condition,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlertFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherAlertToJson(this);
}

// ==================== API ERROR RESPONSE ====================

@JsonSerializable()
class ApiError {
  final String detail;
  final int? statusCode;

  ApiError({
    required this.detail,
    this.statusCode,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

// ==================== REQUEST MODELS ====================

@JsonSerializable()
class RegisterRequest {
  final String phone;
  final String? email;
  final String password;
  @JsonKey(name: 'full_name')
  final String fullName;
  final UserRole role;

  RegisterRequest({
    required this.phone,
    this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String phone;
  final String password;

  LoginRequest({
    required this.phone,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class PestReportRequest {
  final String crop;
  @JsonKey(name: 'pest_name')
  final String pestName;
  final String description;
  @JsonKey(name: 'image_base64')
  final String? imageBase64;

  PestReportRequest({
    required this.crop,
    required this.pestName,
    required this.description,
    this.imageBase64,
  });

  factory PestReportRequest.fromJson(Map<String, dynamic> json) =>
      _$PestReportRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PestReportRequestToJson(this);
}

@JsonSerializable()
class FarmerProfileRequest {
  final String location;
  final String district;
  final String crops;
  @JsonKey(name: 'farm_size_acres')
  final double? farmSizeAcres;

  FarmerProfileRequest({
    required this.location,
    required this.district,
    required this.crops,
    this.farmSizeAcres,
  });

  factory FarmerProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$FarmerProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FarmerProfileRequestToJson(this);
}
