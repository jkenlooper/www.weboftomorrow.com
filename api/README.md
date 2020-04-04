# API for Web of Tomorrow

The www.weboftomorrow.com-api.service should be placed in /etc/systemd/system/ in order to function. Note that this is commonly done by the install script.

```
sudo cp www.weboftomorrow.com-api.service /etc/systemd/system/
```

Start and enable the service.

```
sudo systemctl start www.weboftomorrow.com-api
sudo systemctl enable www.weboftomorrow.com-api
```

Stop the service.

```
sudo systemctl stop www.weboftomorrow.com-api
```

View the end of log.

```
sudo journalctl --pager-end _SYSTEMD_UNIT=www.weboftomorrow.com-api.service
```

Follow the log.

```
sudo journalctl --follow _SYSTEMD_UNIT=www.weboftomorrow.com-api.service
```

View details about service.

```
sudo systemctl show www.weboftomorrow.com-api
```

Check the status of the service.

```
sudo systemctl status www.weboftomorrow.com-api.service
```

Reload if www.weboftomorrow.com-api.service file has changed.

```
sudo systemctl daemon-reload
```

