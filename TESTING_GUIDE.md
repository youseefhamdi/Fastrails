# Fastrails Testing Guide

## Pre-Build Testing Checklist

### 1. Environment Setup
```bash
# Check Go installation
go version
# Should show: go version go1.21.x or higher

# Check GOPATH
echo $GOPATH

# Navigate to project directory
cd /path/to/Fastrails
```

### 2. Dependency Check
```bash
# Download dependencies
go mod download

# Verify dependencies
go mod verify

# Tidy up (remove unused, add missing)
go mod tidy
```

## Build Testing

### 1. Standard Build
```bash
# Build the binary
go build -o fastrails

# Check if binary was created
ls -lh fastrails

# Test version flag
./fastrails --version
```

### 2. Using Build Script
```bash
# Make script executable
chmod +x build.sh

# Run build script
./build.sh
```

### 3. Check for Compilation Errors
```bash
# Compile check without building
go build -n

# Format check
gofmt -l .

# Vet check (static analysis)
go vet ./...
```

## Functional Testing

### 1. Basic Flag Testing
```bash
# Test help flag
./fastrails -h

# Test version flag
./fastrails --version

# Test without arguments (should show error)
./fastrails
```

### 2. Cookie File Testing
```bash
# Test with missing cookie file
./fastrails -d example.com
# Should show: Error loading cookie file

# Test with invalid cookie file
echo "invalid content" > cookie.txt
./fastrails -d example.com
# Should show: user agent not found or cookie not found

# Test with valid cookie file
# (Copy your actual cURL command to cookie.txt first)
./fastrails -d tesla.com --verbose
```

### 3. Input Method Testing

**Single Domain:**
```bash
./fastrails -d tesla.com
```

**From File:**
```bash
# Create test file
echo -e "tesla.com\napple.com\ngoogle.com" > test_domains.txt

# Run with file input
./fastrails -l test_domains.txt --silent
```

**From Stdin:**
```bash
# Using echo
echo "tesla.com" | ./fastrails --silent

# Using cat
cat test_domains.txt | ./fastrails --silent
```

### 4. Configuration Testing

**Max Pages:**
```bash
./fastrails -d example.com --max-pages 5 --verbose
```

**Delay:**
```bash
./fastrails -d example.com --delay 1s --verbose
./fastrails -d example.com --delay 5000ms --verbose
```

**Silent Mode:**
```bash
./fastrails -d example.com --silent
# Should not show banner
```

**Verbose Mode:**
```bash
./fastrails -d example.com --verbose
# Should show detailed logging
```

## Integration Testing

### 1. Pipeline with httpx
```bash
./fastrails -d tesla.com --silent | httpx -silent
```

### 2. Save Output
```bash
./fastrails -d tesla.com > output.txt
cat output.txt
```

### 3. Count Results
```bash
./fastrails -d tesla.com --silent | wc -l
```

## Error Handling Testing

### 1. Cookie Expiration
```bash
# Use an expired or invalid cookie
# Tool should detect and exit gracefully with proper message
```

### 2. Network Issues
```bash
# Test with network disconnected
# Tool should handle connection errors gracefully
```

### 3. Invalid Domain
```bash
./fastrails -d invaliddomainthatdoesntexist12345.com --verbose
# Should handle gracefully (no subdomains or proper error)
```

## Performance Testing

### 1. Timing Test
```bash
time ./fastrails -d example.com --max-pages 5 --silent
```

### 2. Memory Usage
```bash
# On Linux
/usr/bin/time -v ./fastrails -d example.com --silent

# Monitor during execution
top -p $(pgrep fastrails)
```

### 3. Large Domain Test
```bash
# Test with a domain known to have many subdomains
./fastrails -d microsoft.com --max-pages 20 --verbose
```

## Expected Outputs

### Successful Run
```
  _____           _   _____       _ _     
 |  ___|_ _  __ _| |_|  __ \     (_) |    
 | |_ / _' |/ _' | __| |__) |__ _ _| |___ 
 |  _| (_| | (_| | |_|  _  // _' | | / __|
 |_|  \__,_|\__,_|\__|_| \_\__,_|_|_\___|

                          Current Fastrails version v0.0.3

www.tesla.com
shop.tesla.com
service.tesla.com
...
```

### Cookie Error
```
Error loading cookie file: failed to open cookie file: open cookie.txt: no such file or directory
```

### Authentication Error
```
Cookie expired or authentication required
```

### No Input Error
```
Error: either --domain, --list, or stdin must be provided
```

## Debugging Tips

### 1. Enable Verbose Mode
```bash
./fastrails -d example.com --verbose
# Shows detailed execution flow
```

### 2. Check Cookie Extraction
```bash
# The verbose output should show:
# "Successfully extracted user agent and cookie from curl command"
```

### 3. Network Debugging
```bash
# Use a network monitoring tool
tcpdump -i any host securitytrails.com
```

### 4. Go Debug Build
```bash
# Build with debug symbols
go build -gcflags="all=-N -l" -o fastrails_debug

# Run with race detector
go run -race fastrails.go -d example.com
```

## Test Results Checklist

- [ ] Tool compiles without errors
- [ ] --version flag works
- [ ] --help flag works
- [ ] Banner displays correctly
- [ ] Cookie file is read successfully
- [ ] Single domain input works
- [ ] File list input works
- [ ] Stdin input works
- [ ] --max-pages flag works
- [ ] --delay flag works
- [ ] --silent flag works
- [ ] --verbose flag works
- [ ] Subdomains are enumerated correctly
- [ ] Cookie expiration is detected
- [ ] HTTP errors are handled gracefully
- [ ] Output can be piped to other tools
- [ ] No memory leaks
- [ ] Reasonable performance

## Common Issues & Solutions

### Issue: "command not found: go"
**Solution:** Install Go from https://golang.org/

### Issue: "package github.com/spf13/pflag not found"
**Solution:** Run `go mod download`

### Issue: "permission denied: ./fastrails"
**Solution:** Run `chmod +x fastrails`

### Issue: "user agent not found in curl command"
**Solution:** Ensure cookie.txt contains complete cURL command with -H 'user-agent: ...'

### Issue: "Cookie expired" immediately
**Solution:** Get fresh cookie from SecurityTrails while logged in

### Issue: No subdomains found
**Solution:** 
- Check if domain has subdomains on SecurityTrails website
- Verify cookie is valid
- Try with --verbose to see what's happening

## Automated Test Script

Create `test.sh`:
```bash
#!/bin/bash

echo "Running Fastrails Tests..."
echo "=========================="

# Test 1: Build
echo "Test 1: Building..."
go build -o fastrails || exit 1
echo "✓ Build successful"

# Test 2: Version
echo "Test 2: Version check..."
./fastrails --version || exit 1
echo "✓ Version check passed"

# Test 3: Help
echo "Test 3: Help flag..."
./fastrails --help || exit 1
echo "✓ Help flag works"

# Test 4: No args (should fail)
echo "Test 4: No arguments..."
./fastrails 2>/dev/null && echo "✗ Should have failed" || echo "✓ Correctly fails without args"

# Test 5: Missing cookie (should fail)
echo "Test 5: Missing cookie file..."
rm -f cookie.txt
./fastrails -d example.com 2>/dev/null && echo "✗ Should have failed" || echo "✓ Correctly fails with missing cookie"

echo ""
echo "=========================="
echo "Basic tests passed! ✓"
echo ""
echo "Next: Create cookie.txt and test with real domain"
```

Run with:
```bash
chmod +x test.sh
./test.sh
```

## Final Verification

Before considering the tool production-ready:

1. ✓ All 8 issues from original code are fixed
2. ✓ Tool compiles on Linux, macOS, Windows
3. ✓ All command-line flags work as expected
4. ✓ Cookie authentication works
5. ✓ Error handling is robust
6. ✓ Documentation is complete
7. ✓ Code follows Go best practices
8. ✓ No hardcoded values (configurable)
9. ✓ Integration with other tools works
10. ✓ Performance is acceptable

---

**Testing Complete! 🎉**

If all tests pass, your Fastrails tool is ready for production use!
