# Configuración zona y como comprobar que funciona

Lo primero es ubicar el volumen asociado al directorio /etc/bind/, click derecho, Explore in a Development Container, una vez tenemos acceso a los archivos, el primero en ser modificado es: 
~~~
named.conf.options
~~~
Donde descomentamos las siguientes líneas:
~~~
forwarders {
    8.8.8.8;
    4.4.4.4;
};
~~~
Dichas líneas indican al servidor, que las ips especificadas, son los servidores dns a los cuales enviaremos una solicitud, en caso de no poder resolverlo nosotros mismos.

Para confirmar los datos, es primordial reiniciar el servicio (contenedor), para ello, desde una terminal, introducimos:
~~~
docker restart nombre_Contenedor
~~~

Para continuar, hay que modificar el siguiente archivo, el cual nos permite agregar una zona dns, convirtiendo a nuestro servidor, en uno primario de la zona:
~~~
named.conf.local
~~~
En dicho archivo colocaremos las siguientes lineas, las cuales establecen una zona llamada example.com ubicada en el archivo especificado:
~~~
zone "example.com" {
    type master;
    file "/etc/bind/db.example.com";
};
~~~
Creamos el archivo db.example.com el cual contiene toda la configuración de la zona:
~~~
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
maquina1	IN 	A 	19.80.89.82
ggg IN	TXT	"Aqui va un token de seguridad"
owo	IN	CNAME	maquina1
~~~
Donde se establece con el registro SOA:
- nombre del servidor maestro: example.com. 
- correo electronico del administrador 

En las líneas inferios se establecen los registros dns que solucionara nuestro servidor. Hay que recordar establecer el ns.example.com. y otorgarle su ip correspondiente (responsable de la zona).

Se añade un registro TXT, el cual otorga información cuando se realiza una consulta dig TXT.

Se añade un registro CNAME, para generar un alias, donde maquina1, se asocia con ooo.

Para confirmar los datos, es primordial reiniciar el servicio (contenedor), para ello, desde una terminal, introducimos:
~~~
docker restart nombre_Contenedor
~~~

Tras el reinicio del servidor, desde una shell del cliente, con ayuda del comando:
~~~
dig ggg.example.com
~~~
Realizamos una solicitud dns, pregúntando por la ip de dicho dominio. Aunque en un principio en la información del comando dig, aparece que el servidor de respuesta es el 127.0.0.11. No hay que procuparse, ya que dicho comportamiento se debe al funcionamiento servicio systemd encargado de la configuración.

Como prueba del buen funcionamiento, a la petición dig realizada anteriormente, se obtuvo una respuesta satisfactoria, con la ip del dominio solicitado, lo cual indica que el sistema está trabajando correctamente. Otro sistema de comprobación, es ejecutar el siguiente comando:
~~~
ping ggg.example.com
~~~

Si el ping se ejecuta sin problemas, indica que el servidor responde correctamente a las peticiones dns y que la configuración está realizada correctamente.