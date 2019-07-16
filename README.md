# siptrunkfailover
This is my first ever bash script that attempts to do something useful. It's probably an overkill using functions for this simple task but writing this script also served as a learning process.

I use to administer a linux based PBX that has two network interfaces and for strange reasons, whenever the trunk to the sip provider goes down, users endpoint registrations also starts to fail. In order to solve this problem, I had to manually log in to the server and change the default gateway and problem is solved. This became an inconvenience over time and I decided to automate it. Hence, this script was born. This script automatically fails over the PBX default gateway to the backup when main gateway goes down.

It checks for the reachability of the sip provider and fails over automatically if provider is not reachable.
This is achieved by sending ping packets at regular intervals to the provider's gateway. Based on the outcome of the ping, network configuration files are automatically edited to enable the backup gateway.
