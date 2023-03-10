##! Types, errors, and fields for analyzing DHCP data.  A helper file
##! for DHCP analysis scripts.

module DHCP;

export {
	## Types of DHCP messages. See :rfc:`1533`, :rfc:`3203`,
	## :rfc:`4388`, :rfc:`6926`, and :rfc:`7724`.
	const message_types = {
		[1]  = "DISCOVER",
		[2]  = "OFFER",
		[3]  = "REQUEST",
		[4]  = "DECLINE",
		[5]  = "ACK",
		[6]  = "NAK",
		[7]  = "RELEASE",
		[8]  = "INFORM",
		[9]  = "FORCERENEW",       # RFC3203
		[10] = "LEASEQUERY",       # RFC4388
		[11] = "LEASEUNASSIGNED",  # RFC4388
		[12] = "LEASEUNKNOWN",     # RFC4388
		[13] = "LEASEACTIVE",      # RFC4388
		[14] = "BULKLEASEQUERY",   # RFC6926
		[15] = "LEASEQUERYDONE",   # RFC6926
		[16] = "ACTIVELEASEQUERY", # RFC7724
		[17] = "LEASEQUERYSTATUS", # RFC7724
		[18] = "TLS",              # RFC7724
	} &default = function(n: count): string { return fmt("unknown-message-type-%d", n); };

	## Option types mapped to their names.
	const option_types = {
		[0] = "Pad",
		[1] = "Subnet Mask",
		[2] = "Time Offset",
		[3] = "Router",
		[4] = "Time Server",
		[5] = "Name Server",
		[6] = "Domain Server",
		[7] = "Log Server",
		[8] = "Quotes Server",
		[9] = "LPR Server",
		[10] = "Impress Server",
		[11] = "RLP Server",
		[12] = "Hostname",
		[13] = "Boot File Size",
		[14] = "Merit Dump File",
		[15] = "Domain Name",
		[16] = "Swap Server",
		[17] = "Root Path",
		[18] = "Extension File",
		[19] = "Forward On/Off",
		[20] = "SrcRte On/Off",
		[21] = "Policy Filter",
		[22] = "Max DG Assembly",
		[23] = "Default IP TTL",
		[24] = "MTU Timeout",
		[25] = "MTU Plateau",
		[26] = "MTU Interface",
		[27] = "MTU Subnet",
		[28] = "Broadcast Address",
		[29] = "Mask Discovery",
		[30] = "Mask Supplier",
		[31] = "Router Discovery",
		[32] = "Router Request",
		[33] = "Static Route",
		[34] = "Trailers",
		[35] = "ARP Timeout",
		[36] = "Ethernet",
		[37] = "Default TCP TTL",
		[38] = "Keepalive Time",
		[39] = "Keepalive Data",
		[40] = "NIS Domain",
		[41] = "NIS Servers",
		[42] = "NTP Servers",
		[43] = "Vendor Specific",
		[44] = "NETBIOS Name Srv",
		[45] = "NETBIOS Dist Srv",
		[46] = "NETBIOS Node Type",
		[47] = "NETBIOS Scope",
		[48] = "X Window Font",
		[49] = "X Window Manager",
		[50] = "Address Request",
		[51] = "Address Time",
		[52] = "Overload",
		[53] = "DHCP Msg Type",
		[54] = "DHCP Server Id",
		[55] = "Parameter List",
		[56] = "DHCP Message",
		[57] = "DHCP Max Msg Size",
		[58] = "Renewal Time",
		[59] = "Rebinding Time",
		[60] = "Class Id",
		[61] = "Client Id",
		[62] = "NetWare/IP Domain",
		[63] = "NetWare/IP Option",
		[64] = "NIS-Domain-Name",
		[65] = "NIS-Server-Addr",
		[66] = "Server-Name",
		[67] = "Bootfile-Name",
		[68] = "Home-Agent-Addrs",
		[69] = "SMTP-Server",
		[70] = "POP3-Server",
		[71] = "NNTP-Server",
		[72] = "WWW-Server",
		[73] = "Finger-Server",
		[74] = "IRC-Server",
		[75] = "StreetTalk-Server",
		[76] = "STDA-Server",
		[77] = "User-Class",
		[78] = "Directory Agent",
		[79] = "Service Scope",
		[80] = "Rapid Commit",
		[81] = "Client FQDN",
		[82] = "Relay Agent Information",
		[83] = "iSNS",
		[85] = "NDS Servers",
		[86] = "NDS Tree Name",
		[87] = "NDS Context",
		[88] = "BCMCS Controller Domain Name list",
		[89] = "BCMCS Controller IPv4 address option",
		[90] = "Authentication",
		[91] = "client-last-transaction-time option",
		[92] = "associated-ip option",
		[93] = "Client System",
		[94] = "Client NDI",
		[95] = "LDAP",
		[97] = "UUID/GUID",
		[98] = "User-Auth",
		[99] = "GEOCONF_CIVIC",
		[100] = "PCode",
		[101] = "TCode",
		[112] = "Netinfo Address",
		[113] = "Netinfo Tag",
		[114] = "URL",
		[116] = "Auto-Config",
		[117] = "Name Service Search",
		[118] = "Subnet Selection Option",
		[119] = "Domain Search",
		[120] = "SIP Servers DHCP Option",
		[121] = "Classless Static Route Option",
		[122] = "CCC",
		[123] = "GeoConf Option",
		[124] = "V-I Vendor Class",
		[125] = "V-I Vendor-Specific Information",
		[128] = "PXE - undefined (vendor specific)",
		[129] = "PXE - undefined (vendor specific)",
		[130] = "PXE - undefined (vendor specific)",
		[131] = "PXE - undefined (vendor specific)",
		[132] = "IEEE 802.1Q VLAN ID",
		[133] = "IEEE 802.1D/p Layer 2 Priority",
		[134] = "Diffserv Code Point (DSCP) for VoIP signalling and media streams",
		[135] = "HTTP Proxy for phone-specific applications",
		[136] = "OPTION_PANA_AGENT",
		[137] = "OPTION_V4_LOST",
		[138] = "OPTION_CAPWAP_AC_V4",
		[139] = "OPTION-IPv4_Address-MoS",
		[140] = "OPTION-IPv4_FQDN-MoS",
		[141] = "SIP UA Configuration Service Domains",
		[142] = "OPTION-IPv4_Address-ANDSF",
		[144] = "GeoLoc",
		[145] = "FORCERENEW_NONCE_CAPABLE",
		[146] = "RDNSS Selection",
		[150] = "TFTP server address",
		[151] = "status-code",
		[152] = "base-time",
		[153] = "start-time-of-state",
		[154] = "query-start-time",
		[155] = "query-end-time",
		[156] = "dhcp-state",
		[157] = "data-source",
		[158] = "OPTION_V4_PCP_SERVER",
		[159] = "OPTION_V4_PORTPARAMS",
		[160] = "DHCP Captive-Portal",
		[161] = "OPTION_MUD_URL_V4 (TEMPORARY - registered 2016-11-17)",
		[175] = "Etherboot (Tentatively Assigned - 2005-06-23)",
		[176] = "IP Telephone (Tentatively Assigned - 2005-06-23)",
		[177] = "PacketCable and CableHome (replaced by 122)",
		[208] = "PXELINUX Magic",
		[209] = "Configuration File",
		[210] = "Path Prefix",
		[211] = "Reboot Time",
		[212] = "OPTION_6RD",
		[213] = "OPTION_V4_ACCESS_DOMAIN",
		[220] = "Subnet Allocation Option",
		[221] = "Virtual Subnet Selection (VSS) Option",
		[252] = "auto-proxy-config",
		[255] = "End",
	} &default = function(n: count): string { return fmt("unknown-option-type-%d", n); };
}
