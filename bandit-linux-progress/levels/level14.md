# Bandit Level 14 → 15

## Goal
Use the password for **bandit14** to connect to a service on port **30000** and retrieve the next level’s password.

## Steps Taken
1. Logged into bandit14:
    
        ssh bandit14@bandit.labs.overthewire.org -p 2220

2. Read bandit14’s current password from the password store:
    
        cat /etc/bandit_pass/bandit14
        MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS

3. Sent that password to the local service on port 30000:
    
        echo MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS | nc localhost 30000
        Correct! 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo

## Password for bandit15
8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo

## Notes
- The password files live in `/etc/bandit_pass/`.
- `nc` (netcat) is used here to talk to a simple TCP service.
