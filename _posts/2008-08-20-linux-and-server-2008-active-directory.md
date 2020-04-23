---
layout: post
title: Linux and Server 2008 Active Directory
author: alastairs
nid: 35
created: 1219272099
---
I've recently reconfigured my home network to utilise a Windows domain. As I've improved my home development environment, I've needed to make greater use of network shares and things, and running a mixed-OS environment as I do, I have inevitably run into some problems with credentials. <strong>This is the second post in a two-part series</strong>; <a href="http://www.alastairsmith.me.uk/science-and-technology/2008/08/20/my-experiences-server-2008.html" title="My experiences with Server 2008">the first post</a> describes my initial experiences configuring my domain, whilst this post will focus on getting Ubuntu and Fedora Core 7 talking to my domain.
<!--break-->
There are two subsystems that need to be configured to get Linux to connect to an Active Directory: Samba and Kerberos.  Most tutorials will teach you how to do this manually, and this method is fraught with semi-meaningful errors if you make a mistake (or seem to not have made a mistake).  These tutorials are ten-a-penny if you <a href="http://www.google.co.uk/search?q=Join+Linux+to+active+directory" title="Google search for &quot;Join Linux to active directory&quot;">search Google</a>, so I'm not going to replicate that information here, and not least because I didn't manage to get it working this way.  

What I'd like to do instead is draw your attention to a less well-known method that applies to all of the major distros and Mac OS X too: using <a href="http://www.likewisesoftware.com/products/likewise_open/">Likewise Open</a>.  I tried this on my Ubuntu server and it worked like a charm; ditto Fedora 7.  At this point, I'd like to credit <a href="http://bobbyallen.wordpress.com/" title="Bobby Allen's blog">Bobby Allen</a> for the invaluable help his <a href="http://bobbyallen.wordpress.com/2008/05/23/how-to-join-ubuntu-804-to-windows-active-directory-domain/" title="How to join Ubuntu 8.04 to Windows Active Directory (Domain)">post</a> provided.

The first step is to install Likewise Open.  This is simple enough on Ubuntu, Debian and other distros that use the apt-get update system; distros using RPM and yum (such as Fedora) will need to follow the link above to download, which requires registration.  It may be available from fink on Mac OS X; I don't know as I haven't tried.  

Once installation is complete (which is very easy), you then just need to run the following command:
<code>
sudo domainjoin-cli join fqdn.of.your.domain Administrator
</code>

On Fedora 7, the installer specified I had to supply the path to domainjoin-cli too:
<code>
sudo /usr/centeris/bin/domainjoin-cli join fqdn.of.your.domain Administrator
</code>

Note that <code>fqdn.of.your.domain</code> is your domain itself, not the domain controller.  So for me, where the domain controller is called gandalf.middle-earth.co.uk, I typed middle-earth.co.uk here.  All being well, you should get a message stating that the domain was joined successfully.  If not, check the errors, tweak as necessary, and try again.  I had no errors on either system; it worked first time.  

The next think you have to do (on Ubuntu) is to register Likewise Open with the daemon host and start the daemon:
<code>sudo update-rc.d likewise-open defaults
sudo /etc/init.d/likewise-open start</code>

This should be completed as part of the installer on Fedora, etc.  Unfortunately, I haven't found a way to confirm this yet.  Either way, you should be able to log on to your Linux host with the username DOMAIN\username, just as you would on Vista.  Note that you <em>really do have to add the DOMAIN</em>\, otherwise the Linux host will try to authenticate you against /etc/passwd or whatever other mechanism you were using before.  DOMAIN is the "pre-Windows 2000 domain" that you entered when setting up Active Directory, and is usually your domain name without the top-level domain suffixes (such as .com, .co.uk, etc.).  

Finally, in order to get Windows Server 2008 to pick up the DNS suffix of the Linux host in the DHCP manager, I had to tweak the DHCP client configuration.  This was simple enough; simply add or edit the following line in your dhclient.conf file:
<code>
send "linux-hostname.fqdn.of.your.domain";
</code>

Don't forget to restart your network interface after making this change.  

The location and name of the dhclient.conf file differs across distros: in Ubuntu it was at /etc/dhcp3/dhclient.conf; in Fedora 7 it was at /etc/dhclient-eth<em>n</em>.conf, where <em>n</em> matches the number of the network interface the config applies to (most likely 0).
