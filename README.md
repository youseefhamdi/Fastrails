# Fastrails 🚀

A powerful Go-based subdomain enumeration tool that leverages SecurityTrails website data via cookie authentication. Bypass API limitations and retrieve up to **10,000+ subdomains** instead of the free tier's 2,000 limit.

```
   _______ ______ ______ ______ _____  ______ _____ __   ______
  / _____// __  //_____//_____// ____)/ __  //_  _// /  /_____/
 / /___  / /_/ /(_____   / /  / /\ \ / /_/ /_/ /_ / /__(_____             
/_/      \___,/ /_____) /_/  /_/  \_\___,//____//____//_____)
```

## 🌟 Features

- ✅ Bypass API limitations (Get 10k+ subdomains instead of 2k)
- ✅ Cookie-based authentication (No API key required)
- ✅ Flexible input: single domain, file list, or stdin
- ✅ Configurable rate limiting (Adjust delay and max pages)
- ✅ Smart error detection (Intelligent cookie expiration handling)
- ✅ Multiple modes: silent, verbose, and normal
- ✅ Bug bounty ready (Easy integration with other tools)

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

### Step-by-step guide

1. **Login** to SecurityTrails at [https://securitytrails.com](https://securitytrails.com)
2. **Navigate** to any subdomain listing page:
   ```
   https://securitytrails.com/list/apex_domain/example.com?page=1
   ```
3. **Open Developer Tools** (F12 or Right-click → Inspect)
4. **Go to Network tab** and refresh the page (F5)
5. **Find** a request to `securitytrails.com`
6. **Right-click** the request → Copy → Copy as cURL (bash)
7. **Save** the complete cURL command to `cookie.txt`

### Example cookie.txt format

```bash
curl 'https://securitytrails.com/list/apex_domain/tesla.com?page=1'   -H 'accept: text/html,application/xhtml+xml,application/xml'   -H 'accept-language: en-US,en;q=0.9'   -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'   -b 'session_id=your_session_here; other_cookies=values_here'
```

The tool will automatically extract the User-Agent and Cookie from this file.

<img width="1917" height="1000" alt="cookie-example" src="https://github.com/user-attachments/assets/ddcb0f0a-0f52-4f2a-8acc-6887a75181b9" />

## 🚀 Usage

### Basic examples

**Single domain:**
```bash
fastrails -d tesla.com
```

**From stdin:**
```bash
echo "tesla.com" | fastrails
```

**From file:**
```bash
fastrails -l domains.txt
```

**Using custom cookie file:**
```bash
fastrails -d apple.com -c my_cookies.txt
```

### Advanced examples

**Increase max pages:**
```bash
fastrails -d example.com --max-pages 200
```

**Change request delay:**
```bash
fastrails -d example.com --delay 5s
```

**Silent mode (no banner):**
```bash
fastrails -d example.com --silent
```

**Verbose mode (debugging):**
```bash
fastrails -d example.com --verbose
```

**Save output to file:**
```bash
fastrails -d tesla.com > subdomains.txt
```

**Multiple domains in batch:**
```bash
cat targets.txt | fastrails --silent > all_subdomains.txt
```

### Command-line options

```
Usage of Fastrails:
  -c, --cookiefile string   File containing cURL command with cookies (default "cookie.txt")
  -d, --domain string       Single domain to process
  -l, --list string         File containing list of domains
  -m, --max-pages int       Maximum number of pages to scrape (default 100)
      --delay duration      Delay between requests (default 3400ms)
      --silent              Silent mode (no banner)
      --verbose             Enable verbose output for debugging
      --version             Print version and exit
```

## 🔗 Integration with Other Tools

**With httpx (check live subdomains):**
```bash
fastrails -d example.com | httpx -silent
```

**With nuclei (vulnerability scanning):**
```bash
fastrails -d example.com | httpx -silent | nuclei -t cves/
```

**With subfinder (combine results):**
```bash
subfinder -d example.com -silent > subs1.txt
fastrails -d example.com --silent > subs2.txt
cat subs1.txt subs2.txt | sort -u > all_subdomains.txt
```

**With dnsx (DNS validation):**
```bash
fastrails -d example.com | dnsx -silent
```

**Complete recon pipeline:**
```bash
# Step 1: Enumerate subdomains
fastrails -d target.com --silent > subdomains.txt

# Step 2: Check which are alive
cat subdomains.txt | httpx -silent -o alive.txt

# Step 3: Take screenshots
cat alive.txt | aquatone

# Step 4: Run vulnerability scan
cat alive.txt | nuclei -t vulnerabilities/
```

## 🛠️ Troubleshooting

**Issue: "Cookie expired"**  
→ Refresh your session cookie from SecurityTrails.  
→ Make sure you’re logged in when copying the cURL command.

**Issue: "User-Agent not found" or "Cookie not found"**  
→ Ensure your cookie file contains the complete cURL command including both `-H 'user-agent: ...'` and `-b '...'` or `--cookie '...'`.

**Issue: Fewer results than expected**  
→ Increase `--max-pages` (default 100). Try up to 500.

**Issue: Rate limiting or blocking**  
→ Increase `--delay` to 5s or 10s to avoid throttling.

**Issue: "Error opening cookie file"**  
→ Ensure `cookie.txt` exists in the current directory or provide a path: `-c /path/to/cookie.txt`

## 📊 How It Works

1. Extracts session cookie and User-Agent from cURL
2. Sends authenticated HTTPS requests to SecurityTrails
3. Parses HTML with regex to find subdomains
4. Goes through multiple pages automatically
5. Detects cookie expiration vs. empty results
6. Prints results directly to stdout

## ⚠️ Limitations

- Requires a valid SecurityTrails account (free tier fine)
- Cookies expire regularly (refresh required)
- Subject to SecurityTrails’ rate limits
- Output limited to data available on SecurityTrails
- Operates only over HTTPS

## 🔐 Security & Ethics

- For authorized security research and education only
- Respect SecurityTrails’ Terms of Service
- Always get permission before testing
- Use responsibly and avoid excessive scraping
- Never share your personal cookies

## 🐛 Bug Fixes in v0.0.3

- Fixed import path mismatch (compilation error)
- Fixed package declaration issues
- Corrected repository URLs
- Improved cookie expiration detection
- Added configurable `--max-pages` flag
- Added configurable `--delay` flag
- Updated to valid Go 1.21 version
- Consistent naming throughout the project

## 📝 Examples

**Example 1: Basic enumeration**
```bash
$ fastrails -d tesla.com
[www.tesla.com](https://www.tesla.com)
shop.tesla.com
service.tesla.com
auth.tesla.com
```

**Example 2: Large domain with custom settings**
```bash
$ fastrails -d microsoft.com --max-pages 300 --delay 2s --verbose
Processing domain: microsoft.com
Successfully extracted user-agent and cookie
Processing page 1...
Processing page 2...
...
```

**Example 3: Batch processing**
```bash
$ cat targets.txt
tesla.com
apple.com
google.com

$ cat targets.txt | fastrails --silent
[www.tesla.com](https://www.tesla.com)
shop.tesla.com
support.apple.com
mail.google.com
```

### 🎥 Demo Video
```
https://github.com/user-attachments/assets/77b64860-4ead-4d61-b9e1-d761df5952fc
```

## 🤝 Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License - See [LICENSE](LICENSE)

## 👤 Author

**youseefhamdi**  
GitHub: [@youseefhamdi](https://github.com/youseefhamdi)

---

⭐ **If you find this tool useful, please star the repository!**

🐛 **Happy Bug Hunting!** 🔍
