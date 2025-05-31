# app_http

A helper package to handle/encapsulate network request operations for application-kib_sales_force

## Getting Started

### Installation

Add this package to your project's `pubspec.yaml`:

```yaml
dependencies:
  app_http:
    path: packages/app_http
```

### Environment Setup

1. Create environment files in the package root:
   ```bash
   touch .env.dev .env.prod
   
2. Add environment variables to your .env files:
```
# .env.dev
API_BASE_URL=https://api.dev.example.com
API_KEY=your_dev_api_key

# .env.prod
API_BASE_URL=https://api.prod.example.com
API_KEY=your_prod_api_key
```
3. Create example env files to show required variables structure:
```
cp .env.dev .env.dev.example
cp .env.prod .env.prod.example
```
4. Add env files to .gitignore:
```
# Environment files
.env*
!.env.*.example
*.env
*.g.dart
```
5. Run build_runner to generate env code:
```
flutter pub run build_runner build
```
