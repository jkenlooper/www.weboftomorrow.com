# Chill app for www.weboftomorrow.com

The www.weboftomorrow.com-chill.service should be placed in /etc/systemd/system/ in order to function. Note that this is commonly done by the install script.

```
sudo cp www.weboftomorrow.com-chill.service /etc/systemd/system/
```

Start and enable the service.

```
sudo systemctl start www.weboftomorrow.com-chill
sudo systemctl enable www.weboftomorrow.com-chill
```

Stop the service.

```
sudo systemctl stop www.weboftomorrow.com-chill
```

View the end of log.

```
sudo journalctl --pager-end _SYSTEMD_UNIT=www.weboftomorrow.com-chill.service
```

Follow the log.

```
sudo journalctl --follow _SYSTEMD_UNIT=www.weboftomorrow.com-chill.service
```

View details about service.

```
sudo systemctl show www.weboftomorrow.com-chill
```

Check the status of the service.

```
sudo systemctl status www.weboftomorrow.com-chill.service
```

Reload if www.weboftomorrow.com-chill.service file has changed.

```
sudo systemctl daemon-reload
```
