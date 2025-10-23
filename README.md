# Fastrails 🚀

A powerful Go-based subdomain enumeration tool that leverages SecurityTrails website data via cookie authentication. Bypass API limitations and retrieve up to **10,000+ subdomains** instead of the free tier's 2,000 limit.

```
  _____           _   _____       _ _     
 |  ___|_ _  __ _| |_|  __ \     (_) |    
 | |_ / _' |/ _' | __| |__) |__ _ _| |___ 
 |  _| (_| | (_| | |_|  _  // _' | | / __|
 |_|  \__,_|\__,_|\__|_| \_\__,_|_|_\___|
```

## 🌟 Features

- ✅ **Bypass API Limitations** - Get 10k+ subdomains instead of 2k
- ✅ **Cookie-Based Authentication** - No API key required
- ✅ **Flexible Input** - Single domain, file list, or stdin
- ✅ **Configurable Rate Limiting** - Adjust delay and max pages
- ✅ **Smart Error Detection** - Intelligent cookie expiration handling
- ✅ **Multiple Modes** - Silent, verbose, and normal output
- ✅ **Bug Bounty Ready** - Easy integration with other tools

## 📋 Prerequisites

- Go 1.21 or higher
- Active SecurityTrails account (free tier works)
- Valid SecurityTrails session cookie

## 🔧 Installation

### Method 1: Install via go install

```bash
go install github.com/youseefhamdi/Fastrails@latest
```

### Method 2: Build from source

```bash
# Clone the repository
git clone https://github.com/youseefhamdi/Fastrails.git
cd Fastrails

# Build the binary
go build -o fastrails

# (Optional) Move to PATH
sudo mv fastrails /usr/local/bin/
```

### Method 3: Direct download

```bash
# Download and build in one go
git clone https://github.com/youseefhamdi/Fastrails.git
cd Fastrails
go mod download
go build -o fastrails
./fastrails --version
```

## 🍪 Getting Your Cookie

**IMPORTANT:** You must be logged into SecurityTrails for this to work!

### Step-by-step guide:

1. **Login** to SecurityTrails at https://securitytrails.com/

2. **Navigate** to any subdomain listing page:
   ```
   https://securitytrails.com/list/apex_domain/example.com?page=1
   ```

3. **Open Developer Tools**:
   - Press `F12` or Right-click → `Inspect`

4. **Go to Network tab** and refresh the page (`F5`)

5. **Find any request** to `securitytrails.com`

6. **Right-click** on the request → **Copy** → **Copy as cURL (bash)**

7. **Save** the entire cURL command to a file named `cookie.txt`

### Example cookie.txt format:

```bash
curl 'https://securitytrails.com/list/apex_domain/tesla.com?page=1' \
  -H 'accept: text/html,application/xhtml+xml,application/xml' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' \
  -b 'session_id=your_session_here; other_cookies=values_here'
```

The tool will automatically extract the User-Agent and Cookie from this file.

## 🚀 Usage

### Basic Examples

**Single domain:**
```bash
fastrails -d tesla.com
```

**From stdin:**
```bash
echo "tesla.com" | fastrails
```

**From a file:**
```bash
fastrails -l domains.txt
```

**With custom cookie file:**
```bash
fastrails -d apple.com -c my_cookies.txt
```

### Advanced Usage

**Increase page limit:**
```bash
fastrails -d example.com --max-pages 200
```

**Adjust rate limiting:**
```bash
fastrails -d example.com --delay 5s
```

**Silent mode (no banner):**
```bash
fastrails -d example.com --silent
```

**Verbose debugging:**
```bash
fastrails -d example.com --verbose
```

**Save results:**
```bash
fastrails -d tesla.com > subdomains.txt
```

**Process multiple domains:**
```bash
cat targets.txt | fastrails --silent > all_subdomains.txt
```

### Command-Line Options

```
Usage of Fastrails:
  -c, --cookiefile string   File containing curl command with cookies (default "cookie.txt")
  -d, --domain string       Single domain to process
  -l, --list string         File containing list of domains
  -m, --max-pages int       Maximum number of pages to scrape (default: 100)
      --delay duration      Delay between requests (default: 3400ms)
      --silent              Silent mode (no banner)
      --verbose             Enable verbose output for debugging
      --version             Print version and exit
```

## 🔗 Integration with Other Tools

### With httpx (check live subdomains):
```bash
fastrails -d example.com | httpx -silent
```

### With nuclei (vulnerability scanning):
```bash
fastrails -d example.com | httpx -silent | nuclei -t cves/
```

### With subfinder (combine results):
```bash
subfinder -d example.com -silent > subs1.txt
fastrails -d example.com --silent > subs2.txt
cat subs1.txt subs2.txt | sort -u > all_subdomains.txt
```

### With dnsx (DNS validation):
```bash
fastrails -d example.com | dnsx -silent
```

### Complete recon pipeline:
```bash
# Step 1: Gather subdomains
fastrails -d target.com --silent > subdomains.txt

# Step 2: Check alive
cat subdomains.txt | httpx -silent -o alive.txt

# Step 3: Screenshot
cat alive.txt | aquatone

# Step 4: Scan
cat alive.txt | nuclei -t vulnerabilities/
```

## 🛠️ Troubleshooting

### "Cookie Expired" error
- Your session cookie has expired
- Get a fresh cookie by following the steps above
- Make sure you're logged in when copying the cURL command

### "User agent not found" or "Cookie not found" error
- Ensure you copied the **complete** cURL command
- The command must include `-H 'user-agent: ...'` and `-b '...'` or `--cookie '...'`
- Check that your `cookie.txt` file contains the full cURL command

### Getting fewer results than expected
- Increase `--max-pages` value (default is 100)
- Example: `--max-pages 500`
- Some domains simply have fewer subdomains

### Rate limiting / IP blocking
- Increase the `--delay` between requests
- Default is 3400ms, try `--delay 5s` or `--delay 10s`
- SecurityTrails may rate limit aggressive scraping

### "Error opening cookie file"
- Make sure `cookie.txt` exists in the current directory
- Or specify path: `-c /path/to/cookie.txt`

## 📊 How It Works

1. **Authentication**: Extracts session cookie and user-agent from cURL command
2. **Request**: Makes authenticated HTTPS requests to SecurityTrails
3. **Parsing**: Extracts subdomain names from HTML using regex
4. **Pagination**: Automatically follows pages up to max-pages limit
5. **Smart Exit**: Detects cookie expiration vs empty results
6. **Output**: Prints discovered subdomains to stdout

## ⚠️ Limitations

- Requires valid SecurityTrails account (free tier works fine)
- Cookie expires periodically (refresh as needed)
- Subject to SecurityTrails rate limiting
- Maximum results depend on SecurityTrails data
- HTTPS only (more secure)

## 🔐 Security & Ethics

- **Educational/Research Use Only**: This tool is for authorized security research
- **Respect Terms of Service**: Follow SecurityTrails' terms of service
- **Get Permission**: Always have permission before testing systems
- **Responsible Use**: Don't abuse rate limits or scrape excessively
- **Cookie Security**: Keep your cookies private, don't share them

## 🐛 Bug Fixes in v0.0.3

This version fixes critical issues from the original fork:

- ✅ Fixed import path mismatch (compilation error)
- ✅ Fixed package declaration issues
- ✅ Corrected repository URLs
- ✅ Improved cookie expiration detection
- ✅ Added configurable max-pages flag
- ✅ Added configurable delay flag
- ✅ Updated to valid Go version (1.21)
- ✅ Consistent tool naming throughout

## 📝 Examples

### Example 1: Basic enumeration
```bash
$ fastrails -d tesla.com
[Banner displayed]
www.tesla.com
shop.tesla.com
service.tesla.com
auth.tesla.com
...
```

### Example 2: Large domain with custom settings
```bash
$ fastrails -d microsoft.com --max-pages 300 --delay 2s --verbose
Processing domain: microsoft.com
Successfully extracted user agent and cookie from curl command
Processing page 1...
Processing page 2...
...
```

### Example 3: Batch processing
```bash
$ cat targets.txt
tesla.com
apple.com
google.com

$ cat targets.txt | fastrails --silent
www.tesla.com
shop.tesla.com
www.apple.com
support.apple.com
mail.google.com
...
```

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License - See LICENSE file for details

## 👤 Author

**youseefhamdi**
- GitHub: [@youseefhamdi](https://github.com/youseefhamdi)

## 🙏 Acknowledgments

- Original concept inspired by haktrailsfree by rix4uni
- SecurityTrails for providing subdomain data
- The bug bounty community

## 📞 Support

If you encounter issues:
- Check the [Troubleshooting](#-troubleshooting) section
- Open an issue on GitHub
- Make sure you're using the latest version

## 🎯 Roadmap

- [ ] Add JSON output format
- [ ] Implement concurrent processing
- [ ] Add proxy support
- [ ] Create Docker image
- [ ] Add CI/CD pipeline
- [ ] Support for other data sources

---

**⭐ If you find this tool useful, please star the repository!**

**Happy Bug Hunting! 🐛🔍**
