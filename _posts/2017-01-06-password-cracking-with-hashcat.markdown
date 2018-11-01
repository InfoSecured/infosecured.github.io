---
title: "Password Cracking with Hashcat"
date:   2017-01-06 15:04:23
categories: [Password Cracking]
tags: [Hashcat]
---

Weak passwords are a very easy way for a hacker to gain access to your systems.  Passwords can be cracked very quickly these days with increased computer speeds and the use of GPUs for hash calculations.  Recently, I’ve begun checking service accounts for weak passwords.  Service accounts are generally used when an application requires authenticated access to systems without an interactive login (we hope).  This brief tutorial assumes that you already have access to a Linux system.  I’m writing it because when I first began password cracking, it took me a while to find the best and most efficient to do this. I performed these steps on Ubuntu 14.04 LTS.

For the following steps, you’ll need to download Hashcat.

View the password hashes by typing the following in terminal:

`tail -n 1 /etc/shadow`

To determine the hashing algorithm used by the system, type the following:

`grep -rn ENCRYPT_METHOD /etc/login.defs`

Extract the Hash from the file /etc/shadow and create the Hash File. Replace “user to crack” with the username of the account you are trying to crack.

`tail /etc/shadow | grep "user to crack" | awk  -F':' '{print $2}' >> password.hash`

Next, you’ll have to determine whether you’re using a dictionary, rules or brute force attack.

# Dictionary

Download or create a password list. You should be able to find one easily using Google or you can create your own.

Run Hashcat with the following command.  Note: The 1800 signifies that the hash type that you are cracking is sha512crypt $6$, SHA512(Unix).  If your hash type is different, you’ll want to run hashcat –help and search the list for your hash type.  You can also grep this information (i.e. hashcat –help | grep ntlm).

`hashcat -m 1800 -a 0 -o cracked.txt password.hash dictionaryfile.txt`

# Brute Force

Run Hashcat with the following command: Note that the brute-force method can be altered for specific combinations.  This method will take a long time.

`hashcat -m 1800 -a 3 -o cracked.txt password.hash ?a?a?a?a?a?a?a?a`

# Rules (This way worked really well for me)

In the rules sub-folder are numerous sets of rules to try.  You can also search Google for more rules.  In addition, you can open the rules file in a text editor, you can view the different types of iterations that are performed against each word in your dictionary file.

Run Hashcat with the following command (replacing the appropriate filenames).

`hashcat -m 1800 -a 1 -o cracked.txt -r rule.file password.hash dictionaryfile.txt`

This guide should be a basic start to password cracking with Hashcat.  As you get comfortable using a method like this, you can expand upon it by adding multiple dictionaries and more password iterations.