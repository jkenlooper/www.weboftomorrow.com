# Local Development Guide

Get a local development version of the website to run on your machine by
following these instructions.

Written for a Linux machine that is Debian based. Only tested on Ubuntu. Use
[VirtualBox](https://www.virtualbox.org/) and
[Vagrant](https://www.vagrantup.com/) or something similar if not on a Linux
machine.

If using Vagrant; then run `vagrant up` and ssh in (`vagrant ssh`) and go to
the /vagrant/ shared directory when running the rest of the commands.

```bash
vagrant up;
vagrant ssh;

# After logging in as the vagrant user on the vagrant machine.
cd /vagrant/;

# The /vagrant/ directory is a shared folder with the host machine.
ls;
```

If **not** using Vagrant and running locally on a Ubuntu 18.04 (Bionic Beaver)
machine:

```bash
# Run only some commands from bin/init.sh to create the 'dev' user:
sudo adduser dev
# Set the user to have sudo privileges by placing in the sudo group
sudo usermod -aG sudo dev
```

Run the initial `bin/setup.sh` script after logging into the development
machine.

```bash
# Install other software dependencies with apt-get and npm.
sudo ./bin/setup.sh;
```

To have TLS (SSL) on your development machine run the `bin/provision-local.sh`
script. That will use `openssl` to create some certs in the web/ directory.
The rootCA.pem should be imported to Keychain Access and marked as always trusted.

### The 'dev' user and sqlite db file

The sqlite db file is owned by dev with group dev. If developing with
a different user then run `adduser nameofuser dev` to include the 'nameofuser'
to the dev group. Make sure to be signed in as the dev user when manually
modifying the database.

If using Vagrant then change the password for dev user and login as that user
when doing anything with the sqlite db file. Any other commands that modify the
source files and such should be done as the vagrant user (default user when
using `vagrant ssh`).

```bash
sudo passwd dev;
su dev;
```

## Configuration with `.env`

Create the `.env` and `.htpasswd` files. These should not be added to the
distribution or to source control (git).

```bash
echo "EXAMPLE_PUBLIC_KEY=fill-this-in" > .env;
echo "EXAMPLE_SECRET_KEY=fill-this-in" >> .env;
htpasswd -c .htpasswd admin;
```

## Setup For Building

The website apps are managed as
[systemd](https://freedesktop.org/wiki/Software/systemd/) services.
The service config files are created by running `make` and installed with
`sudo make install`. It is recommended to use Python's `virtualenv . -p python3`
and activating each time for a new shell with `source bin/activate` before
running `make`.

**All commands are run from the projects directory unless otherwise noted.** For
the Vagrant setup this is the shared folder `/vagrant/`.

```bash
vagrant ssh;
cd /vagrant/;
```

Some git commit hooks are installed and rely on commands to be installed to
format the python code (black) and format other code (prettier). Committing
before following the below setup will result in an error if these commands
haven't been installed on the development machine.

If `nvm` isn't available on the dev machine then install it. See
[github.com/creationix/nvm](https://github.com/creationix/nvm) for more
information.

```bash
# Install Node Version Manager

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
source ~/.bashrc

# Install latest Nodejs LTS version and set it in the .nvmrc
nvm install --lts=Erbium
nvm current > .nvmrc

# Install and use the version set in .nvmrc
nvm install
nvm use
```

When first installing on a development machine (not production) run:

```bash
# Setup to use a virtual python environment
virtualenv . -p python3;
source bin/activate;

# Install black to format python code when developing
pip install black;

# Build the dist files for local development
npm install;
npm run build;

# Checkout any git submodules in this repo if didn't
# `git clone --recurse-submodules ...`.
git submodule init;
git submodule update;

# Makes the initial development version
make;

sudo make install;
sudo systemctl reload nginx
```

Update `/etc/hosts` to have local-weboftomorrow map to your machine.
Access your local development version of the website at
http://local-weboftomorrow/ . If using vagrant you'll need to use the
8080 port http://local-weboftomorrow:8080/ .

Append to your `/etc/hosts` file on the host machine (Not vagrant). The
location of this file on a Windows machine is different.

```bash
# Append to /etc/hosts
127.0.0.1 local-weboftomorrow
```

### Building the `dist/` files

The javascript and CSS files in the `dist/` directory are built from the source
files in `src/` by running the `npm run build` command. This uses
[webpack](https://webpack.js.org/) and is configured with the
`webpack.config.js`. The entry file is `src/index.ts` and following that the
main site bundle (`site.bundle.js`, `site.css`) is built from
`src/site/index.js`.

The source files for javascript and CSS are organized mostly as components. The
`src/site/` being an exception as it includes CSS and javascript used across the
whole site. Each component includes its own CSS (if applicable) and the CSS
classes follow the
[SUIT CSS naming conventions](https://github.com/suitcss/suit/blob/master/doc/naming-conventions.md).

When editing files in `src/` either run `npm run debug` or `npm run watch`. The
production version is done with `npm run build` which will create compressed
versions of the files.

## Creating a versioned dist for deployment

After making any changes to the source files; commit those changes to git in
order for them to be included in the distribution file. The distribution file
is uploaded to the server and the guide to do deployments should then be
followed.

To create the versioned distribution file (like `weboftomorrow-2.2.0.tar.gz`) use the
`make dist` command. Note that the version is set in the `package.json`.

The script to create the distribution file only includes the files that have
been committed to git. It will also limit these to what is listed in the
`weboftomorrow/MANIFEST`.

## Feature branches and chill-data

The `chill-data.sql` contains only a dump of the database tables that are used
in chill. The Chill, Node, Node_Node, Query, Route, and Template tables are
rebuilt if the `cat chill-data.sql | sqlite3 /path/to/sqlite/db` command is run.
This command is commonly run when deploying to a server or developing locally on
your own machine. A new feature on a git feature branch will sometimes require updates
to the `chill-data.sql` file. There is a potential that if multiple feature
branches are being developed, that there will be messy git conflicts in
`chill-data.sql`. That would happen if those feature branches committed any
changes to `chill-data.sql`.

To solve this potential problem of conflicts with `chill-data.sql`, feature
branches should _not_ be committing any changes to the `chill-data.sql`.
Instead, the new additions to the chill data should be dumped into
a `chill-data-feature-[feature-name].yaml` file using the `chill dump` command.
Then when the feature branch has been merged to the develop branch, the
`chill-data-feature-[feature-name].yaml` file contents should be appended to
the `chill-data.yaml` file. The `chill-data-feature-[feature-name].yaml` file
should then be removed.

The `chill-data-feature-[feature-name].yaml` file should also be edited to
_only_ include changes that are being added for that feature branch.

On updates to any chill-data\*.yaml files; run the below commands to reload the chill database.

```bash
# stop the apps first
sudo ./bin/appctl.sh stop;

# Builds new db.dump.sql
make;

# Reset the chill data tables with what is in the new db.dump.sql file
sqlite3 "/var/lib/weboftomorrow/sqlite3/db" < db.dump.sql;
echo "pragma journal_mode=wal" | sqlite3 /var/lib/weboftomorrow/sqlite3/db;
```

## Uninstalling the app

Run the below commands to remove weboftomorrow from your
development machine. This will uninstall and disable the services, remove any
files installed outside of the project's directory including the sqlite3
database. _Only do this on a development machine if it's database and other
data is no longer needed._

```bash
source bin/activate;
sudo ./bin/appctl.sh stop;

# Removes any installed files outside of the project
sudo make uninstall;

# Remove files generated by make
make clean;
deactivate;

# Remove any source files and directories that are ignored by git
git clean -fdX

# Removes all data including the sqlite3 database
sudo rm -rf /var/lib/weboftomorrow/
```
