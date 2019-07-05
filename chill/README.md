# Chill app for weboftomorrow

The weboftomorrow-chill.service should be placed in /etc/systemd/system/ in order to function. Note that this is commonly done by the install script.

```
sudo cp weboftomorrow-chill.service /etc/systemd/system/
```

Start and enable the service.

```
sudo systemctl start weboftomorrow-chill
sudo systemctl enable weboftomorrow-chill
```

Stop the service.

```
sudo systemctl stop weboftomorrow-chill
```

View the end of log.

```
sudo journalctl --pager-end _SYSTEMD_UNIT=weboftomorrow-chill.service
```

Follow the log.

```
sudo journalctl --follow _SYSTEMD_UNIT=weboftomorrow-chill.service
```

View details about service.

```
sudo systemctl show weboftomorrow-chill
```

Check the status of the service.

```
sudo systemctl status weboftomorrow-chill.service
```

Reload if weboftomorrow-chill.service file has changed.

```
sudo systemctl daemon-reload
```
