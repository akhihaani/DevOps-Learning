# Bandit Level 13 → 14

## 🎯 Goal
Use the private SSH key found in bandit13’s home to log in as **bandit14**.

## 🛠️ Steps Taken
- Logged into bandit13: ssh bandit13@bandit.labs.overthewire.org -p 2220
- Located the key: ls -l → found sshkey.private
- Copied the key into a temp directory and fixed permissions:
  TMPDIR=$(mktemp -d)
  cp ~/sshkey.private $TMPDIR/bandit14.key
  chmod 600 $TMPDIR/bandit14.key
- Used the private key to connect as bandit14:
  ssh -i $TMPDIR/bandit14.key bandit14@localhost -p 2220

## 🔑 Result
Successfully logged in as bandit14.
