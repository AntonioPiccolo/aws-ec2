# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Development
- `npm install` - Install dependencies
- `npm start` - Start local development environment (Docker Compose with app and PostgreSQL)
- `npm stop` - Stop local development environment and clean up containers
- `npm test` - Run integration tests (requires database to be running first)

### AWS Deployment

#### EC2 (Traditional)
- `cd infrastructure && npm install` - Install CDK dependencies
- `cdk bootstrap` - Bootstrap CDK (first time only)
- `cdk deploy AwsEc2Stack` - Deploy AWS infrastructure
- `EC2_HOST=YOUR_IP ./scripts/deploy-to-ec2.sh` - Deploy application to EC2


## Architecture Overview

This is a Node.js/Express REST API for file upload management with the following key components:

### Core Structure
- **Entry point**: `app/server.js` - Express server with CORS, Swagger docs, and health endpoint
- **Database**: PostgreSQL with Kysely query builder (`app/config/database.js`)
- **File Storage**: AWS S3 with local fallback (`app/config/s3.js`)
- **Authentication**: API key-based auth via `X-API-Key` header
- **Validation**: Zod schemas for request validation

### Key Directories
- `app/controllers/` - Business logic for resource operations
- `app/routes/` - Express route handlers
- `app/middlewares/` - Authentication, file upload, and validation middleware
- `app/validators/` - Zod validation schemas
- `test/integration/` - Mocha/Chai integration tests
- `infrastructure/` - AWS CDK infrastructure code

### Database Schema
Single `resources` table with columns: id, title, description, category, language, provider, role, file_name, file_path, s3_key, s3_bucket, file_size, mime_type, created_at, updated_at

### API Endpoints
- `GET /api/resources` - List all resources
- `GET /api/resources/:id` - Get specific resource 
- `GET /api/resources/summary` - Get aggregated statistics
- `POST /api/resources` - Upload new resource with multipart/form-data
- `GET /api-docs` - Swagger documentation
- `GET /health` - Health check

### Environment Configuration
- **Local**: Uses `docker-compose.local.yml` with hardcoded credentials for testing
- **EC2 Production**: Uses AWS EC2 + S3 + PostgreSQL container with `docker-compose.yml`
- Database connection via `DATABASE_URL` environment variable
- AWS S3 configured via `S3_BUCKET_NAME` and AWS credentials

### Testing
- Integration tests in `test/integration/resources.test.js`
- Uses separate test database configuration
- Tests cover all endpoints, authentication, validation, and file uploads
- Test helpers in `test/helpers/` for app setup and database management

### Development Notes
- Database table auto-created on server start with 2-second delay
- File uploads handled via multer middleware
- Swagger docs dynamically configured based on environment
- CORS configured for all origins (adjust for production)
- API key authentication required for all `/api/resources` endpoints