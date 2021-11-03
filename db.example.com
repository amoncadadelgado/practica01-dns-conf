;
; BIND data file for example.com
;
$TTL	604800
@	IN	SOA	example.com. root.example.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	ns.example.com.
@	IN	A	172.27.0.2
@	IN	AAAA	::1
ns  IN  A   172.27.0.2
ggg	IN	A	19.80.89.88
maquina1	IN 	A 	19.80.89.83