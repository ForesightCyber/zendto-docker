# zendto-docker
ZendTo Dockerfile. It contains functional zendto instalation dockerized.

## Running
```
docker run limosek/zendto init-config|listusers|deleteuser|setpassword|adduser|upgrade|run|sh
```

To simply run a server:
```
docker run -d -p80:80  limosek/zendto
```

If you want persistent storage for data (recommended), config customization
and template customisation, use this command once after installation. This
will create empty configs in corresponding directories.

```
docker run -d \
  -p80:80 \
  -v /etc/zendto:/opt/zendto/config \
  -v /var/zendto-data:/var/zendto \
  -v /etc/zendto/templates:/opt/zendto/templates \
  limosek/zendto init-config
```

Next, you can use image as usual, making config changes externally:
```
docker run -d \
  -p80:80 \
  -v /etc/zendto:/opt/zendto/config \
  -v /var/zendto-data:/var/zendto \
  -v /etc/zendto/templates:/opt/zendto/templates \
  limosek/zendto
```

If you want to modify more settings, you can use docker environment
variables.

- TIMEZONE 
- MAX_POST_SIZE
