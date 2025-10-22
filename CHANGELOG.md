# 📝 Changelog

All notable changes to Multi-PHP Development Environment will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-10-22

### 🎉 Added
- **PHP 8.1 Support**: Added app5 service with PHP 8.1
- **PHP 8.2 Support**: Added app6 service with PHP 8.2  
- **PHP 8.3 Support**: Added app4 service with PHP 8.3 (latest)
- **Comprehensive Documentation**: 
  - Complete README.md with architecture diagrams
  - Quick Start Guide
  - Detailed Troubleshooting Guide
  - Contributing Guidelines
- **Enhanced Build Script**: Better error handling and validation
- **Configuration Templates**: Standardized config templates for all services

### 🔧 Changed
- **Docker Compose**: Updated to support 6 PHP services (app1-app6)
- **Nginx Routing**: Enhanced proxy configuration with better timeout settings
- **PHP Extensions**: Standardized extension list across all PHP versions
- **Volume Mapping**: Improved volume structure for better organization

### 🐛 Fixed
- **Permission Issues**: Better handling of file permissions in containers
- **Network Connectivity**: Improved inter-container communication
- **Build Process**: More reliable container building process

### 📚 Documentation
- **Architecture Diagrams**: Added Mermaid diagrams for system overview
- **Usage Examples**: Comprehensive examples for all common use cases
- **Troubleshooting**: Detailed solutions for common issues
- **Performance Tuning**: Guidelines for optimization

## [1.2.0] - 2025-06-21

### 🎉 Added
- **Sample Applications**: Added hasil-pro3 and sparepart_tsp applications
- **Logging Structure**: Organized log directories per application
- **Apache Configuration**: Standardized virtual host configurations

### 🔧 Changed
- **Container Names**: More consistent naming convention
- **Volume Mounts**: Improved volume mounting strategy

### 🐛 Fixed
- **Build Script**: Fixed issues with directory creation
- **Route Configuration**: Better Nginx routing setup

## [1.1.0] - 2025-05-15

### 🎉 Added
- **Build Automation**: Enhanced build.sh script with better parameter handling
- **Route Management**: Improved route.sh for Nginx setup
- **Configuration Management**: Better organization of config files

### 🔧 Changed
- **Docker Images**: Updated base images for better security
- **PHP Configuration**: Optimized php.ini settings

### 🐛 Fixed
- **Network Issues**: Resolved Docker network connectivity problems
- **File Permissions**: Fixed permission issues in mounted volumes

## [1.0.0] - 2025-04-01

### 🎉 Initial Release

#### Core Features
- **Multi-PHP Support**: PHP 5.6, 7.4, and 8.0
- **Docker Compose Setup**: Complete orchestration with docker-compose.yml
- **Nginx Reverse Proxy**: Route service for request routing
- **Apache Integration**: Each PHP service runs with Apache2
- **Volume Mounting**: Persistent storage for applications and configs

#### Services
- **app1**: PHP 5.6 + Apache2
- **app2**: PHP 8.0 + Apache2
- **app3**: PHP 7.4 + Apache2
- **route**: Nginx reverse proxy

#### Scripts
- **build.sh**: Automated application creation
- **route.sh**: Nginx container setup

#### Configuration
- **PHP Configurations**: Separate php.ini for each version
- **Apache Virtual Hosts**: Individual configurations per app
- **Nginx Routing**: Proxy configurations for each service

#### Extensions Included
- imagick, curl, gd, mbstring
- mysql, pgsql, bcmath, bz2
- memcache, xml, dom, json

---

## 🔮 Upcoming Features

### [2.1.0] - Planned
- **PHP 8.4 Support**: When officially released
- **Database Integration**: MySQL and PostgreSQL services
- **SSL/HTTPS Support**: Let's Encrypt integration
- **Monitoring Dashboard**: Web-based monitoring interface
- **Backup Scripts**: Automated backup solutions

### [2.2.0] - Planned
- **Load Balancing**: Multiple instances per PHP version
- **Caching Layer**: Redis integration
- **CI/CD Integration**: GitHub Actions workflows
- **Testing Framework**: Automated testing setup

### [3.0.0] - Future
- **Kubernetes Support**: Helm charts for K8s deployment
- **Microservices Architecture**: Service mesh integration
- **Advanced Monitoring**: Prometheus and Grafana
- **Auto-scaling**: Dynamic resource allocation

---

## 📋 Version Support

| Version | PHP Versions | Support Status | End of Life |
|---------|--------------|----------------|-------------|
| 2.0.x   | 5.6, 7.4, 8.0, 8.1, 8.2, 8.3 | ✅ Active | TBD |
| 1.2.x   | 5.6, 7.4, 8.0 | 🔶 Maintenance | 2025-12-31 |
| 1.1.x   | 5.6, 7.4, 8.0 | ❌ End of Life | 2025-06-30 |
| 1.0.x   | 5.6, 7.4, 8.0 | ❌ End of Life | 2025-04-30 |

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
