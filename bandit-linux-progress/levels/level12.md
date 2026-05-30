# Bandit Level 12 → 13

## 🎯 Goal
`data.txt` is a hexdump of a file that has been (re)compressed multiple times in different formats. Recover the original text to get the password.

## 🛠️ Steps Taken

1. Logged in and made a safe working dir in `/tmp`, then copied the file:
    
    DIR=$(mktemp -d)
    cd "$DIR"
    cp ~/data.txt .

2. Converted the hexdump back to raw bytes:
    
    xxd -r data.txt > stage01
    file stage01
    # → gzip compressed data (named "data2.bin")

3. Gzip → raw:
    
    mv stage01 stage01.gz
    gzip -d stage01.gz
    file stage01
    # → bzip2 compressed data

4. Bzip2 → raw:
    
    mv stage01 stage01.bz2
    bzip2 -d stage01.bz2
    file stage01
    # → gzip compressed data (again)

5. Gzip → tar:
    
    mv stage01 stage01.gz
    gzip -d stage01.gz
    file stage01
    # → POSIX tar archive

6. Extract the tar to get `data5.bin`:
    
    tar -xvf stage01
    file data5.bin
    # → POSIX tar archive

7. Extract again to get `data6.bin`, which is bzip2:
    
    tar -xvf data5.bin
    file data6.bin
    # → bzip2 compressed data

8. Bunzip2 to `data6` (a tar), then extract to get `data8.bin` (gzip):
    
    mv data6.bin data6.bz2
    bzip2 -d data6.bz2
    file data6
    # → POSIX tar archive
    tar -xvf data6
    file data8.bin
    # → gzip compressed data

9. Gunzip to plain text and read it:
    
    mv data8.bin data8.gz
    gzip -d data8.gz
    file data8
    # → ASCII text
    cat data8
    # → “The password is FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn”

## 🔑 Password
FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn

## 📝 Notes
- When `file` reports a format, rename with the correct extension before using the corresponding tool (`.gz` → `gzip -d`, `.bz2` → `bzip2 -d`, tar → `tar -xvf`).
- `xxd -r` reverses a hexdump back into the original binary.
- Working in `/tmp/$(mktemp -d)` avoids permission issues and cleanup races in `/tmp`.
