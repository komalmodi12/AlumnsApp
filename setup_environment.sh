#!/bin/bash

# Environment Configuration Script for Alumns App
# This script helps set up environment-specific configurations

echo "🔧 Alumns App - Environment Configuration Setup"
echo "=================================================="
echo ""

# Detect current system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
else
    OS="unknown"
fi

echo "Detected OS: $OS"
echo ""

# Create environment configuration file
create_env_config() {
    cat > lib/core/api/.env.example << 'EOF'
# API Configuration
API_BASE_URL_QA=https://alumns-qa-render.onrender.com
API_BASE_URL_PROD=https://alumns.com

# Environment
CURRENT_ENV=qa

# Debug
ENABLE_API_LOGGING=true
ENABLE_OFFLINE_MODE=false

# Timeouts (in seconds)
API_CONNECT_TIMEOUT=30
API_RECEIVE_TIMEOUT=30
EOF

    echo "✅ Created .env.example configuration file"
}

# Create debug configuration
create_debug_config() {
    cat > lib/core/api/debug_config.dart << 'EOF'
/// Debug Configuration for API Services
/// 
/// Configure debug settings for development
class DebugConfig {
  static const bool enableApiLogging = true;
  static const bool enableOfflineMode = false;
  static const bool showNetworkLogs = true;
  static const bool simulateNetworkDelay = false;
  static const Duration networkDelayDuration = Duration(seconds: 1);
  
  // Mock response data for testing
  static const bool useMockData = false;
}
EOF

    echo "✅ Created debug_config.dart file"
}

# Create platform-specific configuration
create_platform_config() {
    case $OS in
        windows)
            cat > android/app/build.gradle.kts.api_config << 'EOF'
// Add to defaultConfig block:
manifestPlaceholders = [
    "API_BASE_URL": "https://alumns-qa-render.onrender.com"
]
EOF
            echo "✅ Created Android configuration"
            ;;
        macos)
            cat > ios/Runner/Configs/API-Config.xcconfig << 'EOF'
// API Configuration for iOS
API_BASE_URL = https://alumns-qa-render.onrender.com
API_TIMEOUT = 30
EOF
            echo "✅ Created iOS configuration"
            ;;
        linux)
            cat > web/config.js << 'EOF'
// Web API Configuration
const API_CONFIG = {
  baseUrl: 'https://alumns-qa-render.onrender.com',
  apiVersion: 'v1',
  enableLogging: true,
  timeout: 30000
};
EOF
            echo "✅ Created Web configuration"
            ;;
    esac
}

# Create API endpoints documentation
create_endpoints_doc() {
    cat > docs/API_ENDPOINTS.md << 'EOF'
# API Endpoints Documentation

## Base URLs
- **QA**: https://alumns-qa-render.onrender.com
- **Production**: https://alumns.com

## Endpoints

### Authentication
```
POST /auth/login
POST /auth/register  
POST /auth/logout
PUT  /auth/change-password
```

### Users
```
GET    /api/user
PUT    /api/user
DELETE /api/user
GET    /api/users
GET    /api/users/:id
POST   /api/user/change-password
```

### Analytics
```
GET  /api/v1/pageview/count?pageName=home
POST /api/v1/pageview/increment
```

### Static Content
```
Static files: /static/media/*
```

## Response Format

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "statusCode": 400
}
```
EOF

    echo "✅ Created API endpoints documentation"
}

# Main execution
echo "Creating configuration files..."
echo ""

create_env_config
create_debug_config
create_platform_config
create_endpoints_doc

echo ""
echo "✅ Environment configuration complete!"
echo ""
echo "Next steps:"
echo "1. Review created configuration files"
echo "2. Update .env file with your specific values"
echo "3. Run: flutter clean && flutter pub get"
echo "4. Test API connectivity"
echo ""
