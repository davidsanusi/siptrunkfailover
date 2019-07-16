# siptrunkfailover
Automatically fails over the PBX default gateway when main gateway goes down

It checks for the reachability of the sip provider and fails over automatically if provider is not reachable.
This is achieved by sending ping packets at regular intervals to the provider's gateway. Based on the outcome of the ping, network configuration files are automatically edited to enable the backup gateway.
