DP-util (c) Radware Inc.
Alex Behar, Yuri Gushin 2010

This utility allows the remote configuration of commonly used modules on the Radware DefensePro.


Functionality
=============

    - Network classes
        - Add/delete network classes (using IP range/mask/CIDR or GeoIP location)
        - List network classes
        - Search network classes by name
        - Move network objects between classes
    - Whitelist/Blacklist policies
        - Add whitelist/blacklist policies (using network classes)
        - List/delete whitelist/blacklist policies
    - Server Protection policies
        - Add/list/delete server protection policies 
    - Locations (GeoIP)
        - List locations and network objects belonging to locations
        - Search for locations by name
    - Support IPv4 and IPv6


GeoIP database installation
===========================

Several GeoIP databases are supported:
    - MaxMind GeoIP/GeoLite Country (http://www.maxmind.com/) - IPv4 and IPv6 versions
    - WorldIP Database (http://www.wipmania.com/)

Installation procedure:
    - Download the database of choice in CSV/Text format, unzip and place into the
    same directory as dp-util, renaming the file to 'geoip.db'

It is advised to update the database on a monthly basis.


Usage
=====

# dp-util [OPERATION]... [CLASS]... [ARGS]...

Operations:
    list    Lists all objects for a certain class
    add     Add new objects to that class
    delete  Remove objects/classes
    move    Move a network object from one network class to another

Classes:
    blacklist           Blacklist policies
    whitelist           Whitelist policies
    network             Network classes and contained addresses (objects)
    server-protections  Server Protection policies
    locations           Locations in local GeoIP database (list only)


Environment setup
=================

In order to specify which destination the util will run for, credentials
are passed along with environment variables. That allows for cleaner and
more secure scripting capabilities.

Here's how the configuration looks like:

Linux / OS X:
# export RDWR_DEVICE="10.1.2.3"
# export RDWR_USER="radware"
# export RDWR_PASSWORD="radware"
# export RDWR_PROTO="https"

Alternatively, the ENV variables can also be specified at the command line:
# RDWR_DEVICE="192.168.100.105" RDWR_PROTO="https" dp-util ls bl

Windows:
> set RDWR_DEVICE="10.2.3.4"


DefensePro setup
================
DefensePro version 5.10 or later must be used with this tool.

dp-util requires DefensePro to have the web-services feature turned on.
The use of GeoIP requires tuning the network-objects per class parameter.

Enable web-services:
# manage web-services status set 1

Tune the network-objects-per-class parameter, and check there is sufficient memory to proceed:
# system tune classifier subnets-per-network set 256
# system tune test-after-reset-values

Reboot the DefensePro for these changes to take effect.


Usage examples
==============

List all Blacklists:
# dp-util ls bl

To create a new Whitelist or Blacklist policy, first create a network class (using an IP range/mask/CIDR):
# dp-util add net badguys 10.11.12.0/255.255.255.0
# dp-util add net badguys 20.11.13.1-20.11.13.3
# dp-util add net badguys 44.44.22.1/32
# dp-util add net badguys 2001:db8:85a3:8d3:1319:8a2e:370:7340/128

Then, create the Blacklist policy:
# dp-util add bl badguys

List network classes:
# dp-util ls net

List network classes and the belonging objects matching to 'bad':
# dp-util ls net bad
Network: badguys 
         Mask: 10.1.2.0/255.255.255.0           index: 0
        Range: 10.1.3.3-10.1.3.5                index: 1
         Mask: 10.1.4.0/255.255.255.252         index: 2

Remove a network object from a network class (index 2):
# dp-util del net badguys 2

Remove an entire network class:
# dp-util del net badguys

Move a network object from one network class to another:
# dp-util mv net badguys 1.2.6.0/255.255.255.0 goodguys
Moving address 1.2.6.0/255.255.255.0 from network badguys (index 4) to network goodguys.

List all Server Protection profiles:
# dp-util ls sp

To create a Server Protection profile:
# dp-util add server-protections web-vip-policy 10.20.30.40 cracking="http cracking" http="HTTP Mitigator Profile"

List all available locations in the local GeoIP DB:
# dp-util ls locations

Search for a specific location using a regex (case insensitive):
# dp-util ls locations ".*IS"

List all networks of a specific location:
# dp-util ls locations "Iceland - IS"

Add a location to a network class, and then to a whitelist:
# dp-util add net ISnet "Iceland - IS"
# dp-util add wl ISnet

Add a location with more than 256 network objects (resulting in multiple network classes):
# dp-util add net ESnet "Spain - ES"
This results with 4 different network objects (ESnet-part-1, ESnet-part-2, ..) which we add to the blacklist:
# dp-util add bl ESnet-part-1
# dp-util add bl ESnet-part-2
# dp-util add bl ESnet-part-3
# dp-util add bl ESnet-part-4


DefensePro capabilities with GeoIP
==================================

DefensePro supports up to 5000 different network objects in the blacklist/whitelist in total.
This means that the total number of network objects, out of all network classes assigned with a whitelist
or blacklist policy, cannot exceed that.
It is advised to list the relevant GeoIP location and see the number of networks it contains before adding
it.

DefensePro supports up to 256 different network objects as part of a network class.  When dp-util creates a
network class from a location containing over 256 network objects, it splits the location addresses across
multiple network classes with a "-part-N" suffix.


