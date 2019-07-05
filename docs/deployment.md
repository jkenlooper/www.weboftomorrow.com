# Deployment Guide

There are two kinds of deployments outlined here. The first one is for in-place
deployments where only minor changes are needed and don't require any services
to be restarted. These are usually updates to the client-side resources like
Javascript, CSS, and HTML or other graphic files. The other type of deployment
is commonly called a blue-green deployment where a new server is created and
then when everything has been deployed and ready; traffic is directed to the new
server.

## Create a new version for the deployment

Deployments should use a versioned distribution file that is uploaded to the
server. This file can be made after a new version has been created with `npm version`. On the development machine build the versioned distribution file.

```
make dist;
```

The distribution file will be at the top level of the project and named after
the version found in package.json. For example, with version 0.3.1 the file is
`weboftomorrow-0.3.1.tar.gz`.

That tar file can then be uploaded to the server. The next step varies
depending if the deployment will be an in-place deployment or if a new server
is being created.

## In-place Deployments

Normally the choice to do an in-place deployment instead of a blue-green
deployment is that the change is very minimal and it would just be faster.
These changes are usually simple updates to the client-side resources or minor
patches to the running apps.

SSH into the server as the 'dev' user after the versioned distribution file has
been uploaded to the home directory.

### Steps

1.  Stop the running apps and backup the db. The deactivate command is done to
    deactivate the python virtualenv. A backup of the database is made just as
    a cautionary measure and is left in the folder.

    ```bash
    cd /usr/local/src/weboftomorrow;
    source bin/activate;
    sudo ./bin/appctl.sh stop;
    ./bin/backup.sh;
    deactivate;
    ```

2.  Replace the current source code with the new version. Example shows the
    weboftomorrow-0.3.1.tar.gz which should be in the dev home directory.
    The current source code is moved to the home directory under a date label in
    case it needs to revert back. The `.env` and `.htpasswd` files are copied
    over since they are not included in the distribution.

    ```bash
    cd /home/dev/;
    sudo mv /usr/local/src/weboftomorrow weboftomorrow-$(date +%F);
    sudo tar --directory=/usr/local/src/ --extract --gunzip -f weboftomorrow-0.3.1.tar.gz
    sudo chown -R dev:dev /usr/local/src/weboftomorrow
    cp weboftomorrow-$(date +%F)/.env /usr/local/src/weboftomorrow/;
    cp weboftomorrow-$(date +%F)/.htpasswd /usr/local/src/weboftomorrow/;
    ```

3.  Make the new apps and install the source code. The install will also start
    everything back up. The last command to test and reload nginx is optional
    and is only needed if the nginx conf changed.

    ```bash
    cd /usr/local/src/weboftomorrow;
    virtualenv . -p python3;
    source bin/activate;
    make ENVIRONMENT=production && \
    sudo make ENVIRONMENT=production install;
    sudo nginx -t && \
    sudo systemctl reload nginx;
    ```

4.  Verify that stuff is working by monitoring the logs.

    ```bash
    ./bin/log.sh;
    ```

## Blue-Green Deployments

Create a new server and transfer data over from the old one. This is a good
choice of deployment when the changes are more significant and would benefit
from being able to test things a bit more thoroughly before having it accessible
by the public.

### Steps

1.  After the tar file has been uploaded to the server; SSH in and expand it to
    the `/usr/local/src/` directory. This is assuming that only root can SSH in
    to the server and the distribution was uploaded to the /root/ directory.

    ```bash
    cd /root;
    tar --directory=/usr/local/src/ --extract --gunzip -f weboftomorrow-0.3.1.tar.gz
    ```

2.  Now setup the new server by running the `init.sh` and `setup.sh` scripts.
    These should be run with root privileges (prepend these commands with 'sudo'
    if not root user). The init.sh script will ask for the id_rsa.pub key which
    can just be pasted in. The ownership of the source code files are switched
    to dev since it was initially added via root user.

    ```bash
    cd /usr/local/src/weboftomorrow/;
    ./bin/init.sh;
    ./bin/setup.sh;
    chown -R dev:dev /usr/local/src/weboftomorrow
    ```

3.  SSH in as the dev user and upload or create the `.env` and `.htpasswd` files
    in the `/usr/local/src/weboftomorrow/` directory. See the README on how to
    create these. At this point there is no need to SSH in to the server as the
    root user.

4.  Now create the initial bare-bones version without any data as the dev user.

    ```bash
    cd /usr/local/src/weboftomorrow/;
    virtualenv . -p python3;
    source bin/activate;
    make ENVIRONMENT=production;
    sudo make ENVIRONMENT=production install;
    ```

5.  The logs can be followed with the `./bin/log.sh` command. It is just
    a shortcut to doing the same with `journalctrl`.

    Check the status of the apps with this convenience command to `systemctl`.

    ```bash
    sudo ./bin/appctl.sh status;
    ```

6.  Test and reload the nginx config.

    ```bash
    sudo nginx -t && \
    sudo systemctl reload nginx
    ```

7.  Set up the production server with TLS certs. [certbot](https://certbot.eff.org/)
    is used to deploy [Let's Encrypt](https://letsencrypt.org/) certificates.
    This will initially fail if the server isn't accepting traffic at the domain
    name. The certs can be copied over from the live server later.

    ```bash
    cd /usr/local/src/weboftomorrow/;
    source bin/activate;
    sudo bin/provision-certbot.sh /srv/weboftomorrow/
    make ENVIRONMENT=production;
    sudo make ENVIRONMENT=production install;
    sudo nginx -t && \
    sudo systemctl reload nginx
    ```

Note that by default the production version of the nginx conf for the website is
hosted at [www.weboftomorrow.com](http://www.weboftomorrow.com) as well as
[blue-weboftomorrow](http://blue-weboftomorrow/) and
[green-weboftomorrow](http://green-weboftomorrow/). You can edit
your `/etc/hosts` to point to the old (blue-weboftomorrow) and new
(green-weboftomorrow) servers.

### Transferring data from the old server to the new server

At this point two servers should be running the website with only the older
one (blue) having traffic. The new one (green) should be verified that everything is working
correctly by doing some integration testing. The next step is to stop the apps
on the old server and copy all the data over to the new green-weboftomorrow server.

1.  On the **old server** (blue-weboftomorrow) stop the apps and backup the data. The old
    server is left untouched in case something fails on the new server.

    ```bash
    cd /usr/local/src/weboftomorrow/;
    source bin/activate;
    sudo ./bin/appctl.sh stop;
    ./bin/backup.sh;
    ```

2.  On the **new server** (green-weboftomorrow) the files from the old server will be copied over with
    rsync. First step here is to stop the apps on the new server and remove the
    initial db.

    ```bash
    cd /usr/local/src/weboftomorrow/;
    source bin/activate;
    sudo ./bin/appctl.sh stop;
    rm /var/lib/weboftomorrow/sqlite3/db;
    ```

3.  Copy the backup db (db-YYYY-MM-DD.dump.gz) to the new server and replace the
    other one (SQLITE_DATABASE_URI). This is assuming that ssh agent forwarding
    is enabled for the blue-weboftomorrow host.
    TODO: should journal_mode be set to wal for this app? Only have one app
    accessing the database at this point.

    ```bash
    cd /usr/local/src/weboftomorrow/;
    DBDUMPFILE="db-$(date +%F).dump.gz";
    rsync --archive --progress --itemize-changes \
      dev@blue-weboftomorrow:/usr/local/src/weboftomorrow/$DBDUMPFILE \
      /usr/local/src/weboftomorrow/;
    zcat $DBDUMPFILE | sqlite3 /var/lib/weboftomorrow/sqlite3/db
    #echo 'pragma journal_mode=wal' | sqlite3 /var/lib/weboftomorrow/sqlite3/db
    ```

4.  Copy the nginx logs (NGINXLOGDIR) found at: `/var/log/nginx/weboftomorrow/`

    ```bash
    rsync --archive --progress --itemize-changes \
      dev@blue-weboftomorrow:/var/log/nginx/weboftomorrow \
      /var/log/nginx/
    ```

5.  Copy the certificates listed on the old server (`sudo certbot certificates`) to the new server.

    ```bash
    scp \
      dev@blue-weboftomorrow:/etc/letsencrypt/live/www.weboftomorrow.com/fullchain.pem \
      /etc/letsencrypt/live/www.weboftomorrow.com/
    scp \
      dev@blue-weboftomorrow:/etc/letsencrypt/live/www.weboftomorrow.com/privkey.pem \
      /etc/letsencrypt/live/www.weboftomorrow.com/
    ```

6.  Start the new server and switch traffic over to it.

    After the old server data has been copied over, then start up the new server
    apps with the 'bin/appctl.sh' script. It is also good to monitor the logs to see
    if anything is throwing errors.

    ```
    cd /usr/local/src/weboftomorrow/;
    source bin/activate;
    sudo ./bin/appctl.sh start;
    ./bin/log.sh;
    ```

    Verify that the new version of the website is running correctly on
    green-weboftomorrow/. If everything checks out, then switch the traffic over to
    www.weboftomorrow.com/.
