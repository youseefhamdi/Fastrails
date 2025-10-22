## haktrailsfree

Free securitytrails apikey only gives 2k subdomains, you can get 10k subdomains using your cookies.
Steps to Collect cookie:
- Note: `you must logged in`
1. Visit: `https://securitytrails.com/list/keyword/dell?page=2`
2. In Network tab request `Copy as cURL (bash)`
<img width="1431" height="720" alt="image" src="https://github.com/user-attachments/assets/3ae73954-0901-47be-a479-d202b0016a0d" />
4. Paste complete cookie in cookie.txt, that's it you're done

## Installation
```
go install github.com/youseefhamdi/Fastrails.git
```

## Compile from source
```
git clone --depth 1 github.com/rix4uni/haktrailsfree.git
cd haktrailsfree; go install
```

## Usage
```
Usage of haktrailsfree:
  -c, --cookiefile string   File containing curl command with cookies (default "cookie.txt")
  -d, --domain string       Single domain to process
  -l, --list string         File containing list of domains
      --silent              Silent mode.
      --verbose             Enable verbose output for debugging purposes.
      --version             Print the version of the tool and exit.
```

## Output Examples

Single URL:
```
echo "krazeplanet.com" | haktrailsfree
```

Multiple URLs:
```
cat subs.txt | haktrailsfree
```
