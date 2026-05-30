# Bandit Level 15 → 16

## 🎯 Goal
Connect to the SSL service on `localhost:30001`, send the current level’s password, and read the next password.

## 🛠 Steps Taken
- Logged into bandit15:
  ssh bandit15@bandit.labs.overthewire.org -p 2220

- Sent the password for bandit14 to the SSL service:
  echo 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo | openssl s_client -quiet -connect localhost:30001

## 📥 Output
Can't use SSL_get_servername
depth=0 CN = SnakeOil
verify error:num=18:self-signed certificate
verify return:1
Correct! kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

## 🔑 Password for bandit16
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

## 📝 Notes
- The port requires SSL/TLS, so `nc` won’t work here.
- The self-signed cert warning is normal for this level.
