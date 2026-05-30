# Bandit Level 10 → 11

## 🎯 Goal
The password for the next level is stored in `data.txt`, which contains base64-encoded text.

## 🛠️ Steps Taken
1. Logged into bandit10:
   ssh bandit10@bandit.labs.overthewire.org -p 2220

2. Checked the manual for base64:
   man base64

3. Decoded the file:
   base64 -d data.txt

## 🔑 Password
dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr

## 📝 Notes
- The `-d` option with `base64` decodes instead of encodes.  
- Output gave the password directly.  
- Learned how to quickly decode base64 data from the terminal.

