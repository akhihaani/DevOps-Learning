# Bandit Level 11 → 12

## 🎯 Goal
The password for the next level is stored in `data.txt`, where all lowercase (a–z) and uppercase (A–Z) letters have been rotated by 13 positions (ROT13).

## 🛠️ Steps Taken
1. Logged into bandit11:
   ssh bandit11@bandit.labs.overthewire.org -p 2220

2. Inspected the file:
   cat data.txt  
   → Output: `Gur cnffjbeq vf 7k16JArUVv5LxVuJfsSVdbbtaHGlw9D4`

3. Tried invalid commands (`cat -a`, `ROT13 -d`) which failed, then found correct approach.

4. Used `tr` to apply ROT13:
   cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'  
   → Output: `The password is 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4`

## 🔑 Password
7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4

## 📝 Notes
- ROT13 is a simple Caesar cipher with shift 13.  
- The `tr` command translates characters according to ranges.  
- Learned to use `tr 'A-Za-z' 'N-ZA-Mn-za-m'` to apply ROT13 in Linux.
