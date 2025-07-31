# 🌍 Culture Quest – African Cultural Heritage & Artisan Discovery App

Culture Quest is a comprehensive Flutter application designed to preserve and share African cultural heritage, connecting urban youth with their traditional roots through digital storytelling, artisan showcases, and cultural events. The app features a robust NestJS backend with PostgreSQL database for scalable cultural content management.

**Link to the Demo Video:** [Coming Soon]  
**Link to the APK Download:** [Coming Soon]

## 🚀 Features

### 🔐 Authentication Flow
- **Email/Password Registration** with secure validation
- **JWT-based Authentication** with role-based access control
- **Password Reset** via email
- **Secure Logout** with token management
- **Multi-language Support** for diverse African communities

### 🏠 Home Page
- **Cultural Content Discovery** with search functionality
- **Featured Events** showcase with rich media
- **Story Exploration** with audio/video support
- **Artisan Directory** with location-based search
- **Interactive Content Cards** with images and descriptions

### 📖 Cultural Stories
- **Multi-format Storytelling** (text, audio, video)
- **Language and Dialect Tracking** for cultural preservation
- **Verification System** for content authenticity
- **Analytics Tracking** (views, downloads, shares)
- **Related Stories** recommendations
- **Cultural Context** and historical period tagging

### 🎭 Cultural Events
- **Event Management** with detailed scheduling
- **Location-based Search** with coordinates
- **Session Handling** for multi-day events
- **Attendance Tracking** and interest marking
- **Cultural Significance** documentation
- **Artisan Integration** for event participation

### 🛠️ Artisan Profiles
- **Detailed Artisan Information** with verification status
- **Location-based Discovery** with radius search
- **Craft Categorization** and specialty tracking
- **Gallery Management** with image/video support
- **Contact Information** with preferred contact methods
- **Working Hours** and availability tracking
- **Craft Showcase** with pricing and materials

### 🔍 Content Moderation
- **Community-driven Content Review** system
- **Moderation Status Tracking** with timestamps
- **Moderator Assignment** and verification
- **Content Quality Control** for cultural authenticity

### 📊 Analytics & Insights
- **Usage Statistics** and content performance metrics
- **Trend Analysis** for cultural content engagement
- **User Behavior Tracking** for personalized experiences
- **Content Performance** monitoring

## 🧱 Tech Stack

| Category | Frontend | Backend |
|----------|----------|---------|
| **UI Framework** | Flutter | - |
| **Backend Framework** | - | NestJS (Node.js) |
| **Database** | - | PostgreSQL |
| **ORM** | - | Prisma |
| **Authentication** | HTTP + SharedPreferences | JWT + bcrypt |
| **State Management** | Provider | - |
| **Maps** | Google Maps Flutter | - |
| **Storage** | Local + Network Images | File System |
| **Navigation** | Named Routes + BottomNavigationBar | - |
| **Testing** | flutter_test | Jest |
| **Documentation** | - | Swagger/OpenAPI |

## 📂 Project Structure

### Frontend (Flutter App)
```
App/
├── lib/
│   ├── models/           # Data models (User, Event, Story, Artisan)
│   ├── screens/          # UI screens (12 main screens)
│   ├── services/         # API service layer
│   └── main.dart         # App entry point
├── assets/
│   └── images/           # Rich cultural imagery
└── pubspec.yaml          # Dependencies
```

### Backend (NestJS API)
```
culturequest-api/
├── src/
│   ├── modules/          # Feature modules
│   │   ├── auth/         # Authentication
│   │   ├── users/        # User management
│   │   ├── artisans/     # Artisan profiles
│   │   ├── stories/      # Cultural stories
│   │   ├── events/       # Cultural events
│   │   ├── analytics/    # Analytics
│   │   └── moderation/   # Content moderation
│   ├── prisma/           # Database schema
│   └── main.ts          # API entry point
└── prisma/
    └── schema.prisma     # Database schema
```

## 🗄️ Database Schema

### Core Entities
- **User**: Authentication, preferences, favorites, activity tracking
- **Artisan**: Profile, location, crafts, verification, contact info
- **Story**: Multi-format content, cultural metadata, verification
- **Event**: Event details, sessions, location, capacity tracking
- **ContentModeration**: Community content management
- **Analytics**: Usage metrics and performance tracking

## 🔌 API Integration

### Authentication Endpoints
```http
POST /api/auth/register    # User registration
POST /api/auth/login       # User login
POST /api/auth/forgot-password  # Password reset
```

### Content Endpoints
```http
GET /api/events            # Cultural events
GET /api/stories           # Cultural stories
GET /api/artisans          # Artisan profiles
GET /api/analytics         # Usage analytics
```

### Flutter Integration Example
```dart
Future<void> login() async {
  final response = await http.post(
    Uri.parse('https://culture-quest-app-backend.onrender.com/api/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': 'user@example.com',
      'password': 'password'
    }),
  );
  
  if (response.statusCode == 200) {
    final token = jsonDecode(response.body)['access_token'];
    // Store token securely
  }
}
```

## ✅ Navigation Flow

```
[Get Started Screen]
    ↓
[Welcome Screen]
    ↓
[Authentication (Login/Register)]
    ↓
[Home Screen (Main Dashboard)]
    ↓
[Bottom Navigation Tabs]:
    - Home (Featured Content)
    - Events (Cultural Events)
    - Stories (Cultural Narratives)
    - Artisans (Local Craftspeople)
    - Profile (User Management)
```

## 🧪 Testing

### Frontend Testing
```bash
# Run Flutter tests
flutter test

# Run with coverage
flutter test --coverage
```

### Backend Testing
```bash
# Run NestJS tests
npm run test

# Run with coverage
npm run test:cov
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.1.0 or later)
- Node.js (v18 or later)
- PostgreSQL (v14 or later)
- Android Studio / VS Code

### Frontend Setup
```bash
# Clone the repository
git clone https://github.com/Lisky-pixel/culture_quest_v1
cd culture-quest-v1/App

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Backend Setup
```bash
# Navigate to API directory
cd culturequest-api

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your database and JWT settings

# Generate Prisma client
npm run prisma:generate

# Run database migrations
npm run prisma:migrate

# Seed initial data
npm run prisma:seed

# Start development server
npm run start:dev
```

## 🔒 Security Features

### Authentication Security
- **JWT Tokens** with configurable expiration
- **bcrypt Password Hashing** for secure storage
- **Role-based Access Control** (Admin, User, Moderator)
- **Input Validation** using class-validator
- **CORS Configuration** for secure cross-origin requests

### Content Security
```typescript
// Example JWT Guard implementation
@UseGuards(JwtAuthGuard)
@Controller('protected')
export class ProtectedController {
  // Protected endpoints
}
```

## 🌍 Cultural Features

### Multi-language Support
- **Language Preferences** for diverse African communities
- **Dialect Tracking** for cultural authenticity
- **Regional Content** filtering and discovery

### Cultural Preservation
- **Verification System** for content authenticity
- **Cultural Context** documentation
- **Historical Period** tagging
- **Traditional Knowledge** preservation

### Community Engagement
- **Content Moderation** by community members
- **User Feedback** system for continuous improvement
- **Analytics** for understanding cultural content engagement

## 📱 Key Screens

### Home Screen
- **Search Functionality** across events and stories
- **Featured Content** with rich media cards
- **Quick Navigation** to main features
- **Content Filtering** and discovery

### Events Screen
- **Event Browsing** with category filtering
- **Location-based Search** for nearby events
- **Event Details** with session information
- **Attendance Tracking** and interest marking

### Stories Screen
- **Cultural Narratives** with multi-format support
- **Language Filtering** for diverse content
- **Story Details** with audio/video playback
- **Related Stories** recommendations

### Artisans Screen
- **Local Craftspeople** directory
- **Location-based Discovery** with map integration
- **Craft Showcase** with pricing and materials
- **Contact Information** with preferred methods

## 💬 Commit Message Examples

```
feat: implement cultural story verification system
- Added story verification workflow
- Implemented moderator assignment
- Added verification status tracking
- Updated story model with verification fields

feat: add location-based artisan discovery
- Implemented geospatial search for artisans
- Added radius-based filtering
- Integrated Google Maps for location display
- Added artisan verification status

fix: resolve authentication token persistence
- Fixed token storage in SharedPreferences
- Improved logout functionality
- Added token refresh mechanism
- Enhanced error handling for auth failures
```

## 👥 Team Members

**Culture Quest Development Team**

- [Emmy Nshimiye](https://github.com/nshimiyeemmy)
- [Branice Kazira Otiende](https://github.com/BraniceKaziraOtiende)
- [Leny Pascal IHIRWE](https://github.com/leny62)
- [Oluchi Rejoice Nduka-Aku](https://github.com/Lisky-pixel)
- [Ntwali Eliel](https://github.com/NtwaliEliel)

---

**Culture Quest** - Preserving African Heritage Through Digital Innovation 🌍✨ 