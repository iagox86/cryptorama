# Solution

Solution: `dr.z`

# Walkthrough

This is just layers and layers of encoding. The bottom string is what matters!

Here's Jeff's:

```
echo '...' | ' | tr -d ' ' | base64 -d | tr ' ' '\n' | while read line || [ -n "$line" ]; do echo "$line" | xxd -r -p; done | tr ' ' '\n' | while read line || [ -n "$line" ]; do printf \\$(printf "%o" $line); done | while read -n 2 hex; do echo "$hex" | xxd -r -p; done | base32 -d
From the desk of Dr.Z (unlicensed)<Paste>
```
