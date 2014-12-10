# Netflix VPN Router

First, clone the repository.
```
$ sudo vim /etc/ppp/ip-up
#!/bin/sh

sh /where/you/have/cloned/the/repo/to/route.sh ppp0 #ppp0 is the interface name of the VPN you want netflix to route through

$ sudo chmod a+x /etc/ppp/ip-up
```
