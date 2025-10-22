# 🤝 Contributing to Multi-PHP

Thank you for your interest in contributing to Multi-PHP Development Environment! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Process](#contributing-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Reporting Issues](#reporting-issues)

## 🤗 Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code:

- **Be respectful** and inclusive
- **Be collaborative** and constructive
- **Be patient** with newcomers
- **Focus on what's best** for the community
- **Show empathy** towards other community members

## 🚀 Getting Started

### Prerequisites

- Docker >= 20.10.0
- Docker Compose >= 2.0.0
- Git
- Basic knowledge of PHP, Docker, and web servers

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/multi-php.git
cd multi-php

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/multi-php.git
```

## 🛠️ Development Setup

### 1. Initial Setup

```bash
# Make scripts executable
chmod +x build.sh route.sh

# Start development environment
./route.sh
docker-compose up -d

# Verify setup
docker-compose ps
```

### 2. Development Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make your changes
# ... edit files ...

# Test your changes
./test.sh  # If test script exists

# Commit your changes
git add .
git commit -m "feat: add new PHP version support"

# Push to your fork
git push origin feature/your-feature-name
```

## 🔄 Contributing Process

### 1. Types of Contributions

We welcome various types of contributions:

- **🐛 Bug fixes**
- **✨ New features**
- **📚 Documentation improvements**
- **🔧 Configuration enhancements**
- **🧪 Tests and testing improvements**
- **🎨 UI/UX improvements**

### 2. Contribution Workflow

1. **Check existing issues** to avoid duplication
2. **Create an issue** for major changes (discuss first)
3. **Fork the repository**
4. **Create a feature branch**
5. **Make your changes**
6. **Test thoroughly**
7. **Update documentation**
8. **Submit a pull request**

### 3. Pull Request Guidelines

#### Before Submitting

- [ ] Code follows project standards
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] No merge conflicts

#### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Configuration change

## Testing
- [ ] Tested locally
- [ ] All containers start successfully
- [ ] Applications accessible via browser

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## 📝 Coding Standards

### Shell Scripts

```bash
#!/bin/bash
# Use bash shebang
# Add comments for complex logic
# Use meaningful variable names

# Good
PHP_VERSION="8.3"
APP_NAME="myapp"

# Bad
v="8.3"
n="myapp"

# Use proper error handling
if [ ! -d "$APP_DIR" ]; then
    echo "ERROR: Directory $APP_DIR does not exist"
    exit 1
fi
```

### Docker Compose

```yaml
# Use consistent indentation (2 spaces)
# Add comments for complex configurations
# Group related services together

services:
  app1:
    # PHP 5.6 Application
    build:
      context: .
      dockerfile: ./dockerfile/php-apache2.dockerfile
      args:
        - php_version=5.6
        - app_name=app1
```

### Configuration Files

```ini
; PHP Configuration
; Use comments to explain non-obvious settings

; Memory settings
memory_limit = 256M
upload_max_filesize = 100M

; Performance settings
opcache.enable=1
opcache.memory_consumption=256
```

### Documentation

- Use **clear headings** and structure
- Include **code examples** where helpful
- Add **screenshots** for UI changes
- Use **consistent formatting**
- Write for **different skill levels**

## 🧪 Testing Guidelines

### Manual Testing

Before submitting, test the following:

```bash
# 1. Clean environment test
docker-compose down
docker system prune -f
./route.sh
docker-compose up -d

# 2. Service accessibility
curl -I http://app1.local
curl -I http://app2.local
# ... test all services

# 3. Build script test
./build.sh -n testapp -v 8.2
curl -I http://testapp.local

# 4. Error scenarios
# Test with invalid parameters
./build.sh -n "" -v 8.2  # Should fail gracefully
```

### Automated Testing

If adding automated tests:

```bash
#!/bin/bash
# test.sh

echo "Running Multi-PHP Tests..."

# Test 1: Container startup
echo "Testing container startup..."
docker-compose up -d
sleep 30

# Test 2: Service accessibility
echo "Testing service accessibility..."
for service in app1 app2 app3 app4 app5 app6; do
    if curl -f http://$service.local > /dev/null 2>&1; then
        echo "✅ $service accessible"
    else
        echo "❌ $service not accessible"
        exit 1
    fi
done

echo "All tests passed! ✅"
```

## 📚 Documentation

### Documentation Standards

- **README.md**: Main documentation
- **QUICK_START.md**: Getting started guide
- **TROUBLESHOOTING.md**: Problem solving
- **CHANGELOG.md**: Version history
- **Code comments**: Inline documentation

### Writing Guidelines

1. **Be clear and concise**
2. **Use examples** liberally
3. **Include expected outputs**
4. **Test all instructions**
5. **Keep it updated**

### Documentation Structure

```markdown
# Title

Brief description

## Section 1

Content with examples:

```bash
# Command example
docker-compose up -d
```

Expected output:
```
Creating network "multi-php_route" with the default driver
Creating app1 ... done
```
```

## 🐛 Reporting Issues

### Before Reporting

1. **Search existing issues**
2. **Check documentation**
3. **Try troubleshooting steps**
4. **Test with clean environment**

### Issue Template

```markdown
**Bug Description**
Clear description of the bug

**Environment**
- OS: [e.g., Ubuntu 20.04]
- Docker: [e.g., 20.10.8]
- Docker Compose: [e.g., 2.0.1]

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Logs**
```
Paste relevant logs here
```

**Additional Context**
Any other relevant information
```

## 🎯 Specific Contribution Areas

### Adding New PHP Version

1. **Create configuration directory**:
   ```bash
   mkdir config/php8.4
   cp config/php8.3/php.ini config/php8.4/php.ini
   ```

2. **Update docker-compose.yml**:
   ```yaml
   app7:
     build:
       args:
         - php_version=8.4
         - app_name=app7
   ```

3. **Test thoroughly**:
   ```bash
   ./build.sh -n test84 -v 8.4
   ```

4. **Update documentation**

### Improving Build Script

Focus areas:
- Better error handling
- Parameter validation
- Progress indicators
- Cleanup on failure

### Enhancing Documentation

- Add more examples
- Improve troubleshooting
- Create video tutorials
- Translate to other languages

## 🏆 Recognition

Contributors will be recognized in:

- **README.md** contributors section
- **CHANGELOG.md** for significant contributions
- **GitHub releases** notes

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and ideas
- **Email**: [maintainer@email.com] for sensitive issues

## 📄 License

By contributing, you agree that your contributions will be licensed under the same MIT License that covers the project.

---

**Thank you for contributing to Multi-PHP! 🙏**

Your contributions help make this project better for everyone in the PHP development community.
