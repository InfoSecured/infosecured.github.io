---
title: "Getting Started with Lastpass"
date:   2017-02-09 08:04:23
categories: [Password Cracking]
tags: [Hashcat]
---

### Weak Passwords

Passwords are used every day in one way or another.  You create passwords to protect the information you hold dear such as your home and work computer, e-mail, and bank account.  But how much is your password protecting you?  As an ethical hacker, I can tell you that I have cracked ten character passwords in just minutes.  It’s very important for you to understand how to make a complex password and why it should be different for all of your accounts.

To help you understand why complex passwords are important, lets take a quick look at the alphabet.  We all know that there are twenty-six letters in the alphabet.  But that’s just lowercase.  When we add uppercase, we have fifty-two characters.  With numbers, that’s another ten.  And with special characters, that 15+.  When you put them all together, you can make a very complex password.  But I bet your thinking, how can I remember a password with a mixture of these types of characters?  Well, there’s two ways.

The first is to create a passphrase instead of a password and add some character substitutions.  For example (and this is not any password that I’m aware of), I’ll use the phrase, ‘Lauren is my wife’.  This can be altered to look like L@ur3n1$MyW1fe. This password is fourteen characters and uses all four password complexities.  But, since I also mentioned earlier that you should use a different password for all of your accounts, it may be difficult to remember many different passphrases.  So how can we resolve this dilemma?

### LastPass
In this post, we’ll be looking at Lastpass.  Lastpass is a product owned by LogMeIn that works as a password manager for consumers and enterprises.  It can help you to organize your passwords for an enormous amount of websites and applications.  It can generate and remember passwords for you.  You can even share them with family members if you so choose. And the best part, it’s free.  And with an optional, and very inexpensive pro version, you’ll get even more features.

When starting with Lastpass, you’ll need to create one very secure password to protect your vault.  This is the password that you will use when you want Lastpass to fill in your passwords on various websites or to make edits to your vault.

![vault](/images/posts/Vault.png "LastPass Vault")

Now, you have the option to add sites manually, or the recommended option is to add passwords to your vault as you visit sites.  For example, we will create a new account on dropbox.com, which is a popular online file storage website.  After signing up and choosing your own password, a box will appear and ask if you want to save it to your Lastpass vault.

<img src="http://infosecured.github.io/images/posts/addtolp.png" alt="Add a Password" class="inline"/>
#![add](~/images/posts/addtolp.jpeg "Add a Password")

This option makes it easier for you to add all of your future logins into Lastpass.  You should note though that this box will show up if you enter the incorrect password as well, so make sure you have successfully logged in to the target site before adding your password.  If you inadvertently add the incorrect password, you will be able to save the correct password on your next login attempt.  Now since I chose my own password, I’ve decided that I want to make it a more secure one.  So I’ve navigated to the Security section of dropbox.com and chose the option to change my password.  I’ve already entered my old password and in the new password box, I’ll be clicking on the Lastpass option in the password box as shown circled in red.

When the Lastpass box comes up, expand the options at the bottom of the window.  Now, some websites will not allow you to choose all of these options and some other websites may have limits on the number of characters your password can be.  But when possible, I try to choose the longest password possible with uppercase, lowercase, numbers, and symbols. (Note, this is not my password).

Lastpass offers some other great security tools which can help you to further secure your passwords.  The first tool that I would highly recommend using is two-factor authentication (2FA).  2FA will add a second measure of security to your vault which is a 6-8 digit passcode that changes every 30-60 seconds.  You can utilize your smart phone as your second factor if you choose by downloading the Lastpass or Google Authenticator.  When choosing this option, Lastpass will guide you through setup process which will involve using your phone’s camera to take a picture of a QR code.

Another great feature is the Security Challenge. This feature tests the strength of all of your passwords and makes recommendations on which ones are weak or even potentially compromised.  With some websites such as Google and Amazon, Lastpass can even change your password to a more secure one for you.

Lastpass is not the only product out there that secures passwords and more will be covered here over time.  But these days we have too many passwords to remember and with all of the recent hacks (Sony, Yahoo, OPM, DNC, etc,) its really important to keep your passwords secure and with tools like this, it’s just too easy.