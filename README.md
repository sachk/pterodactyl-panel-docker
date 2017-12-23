# pterodactyl-panel-docker
> Docker Compose configuration for the [Pterodactyl Panel](https://github.com/Pterodactyl/Panel).

Pterodactyl is an open-source control panel used for hosting numerous game-related
services, such as Minecraft and Teamspeak servers. Setting it up, however, takes
quite a few steps according to the [documentation](https://docs.pterodactyl.io/docs).

This Docker Compose configuration is aimed at removing a majority of the steps so
that the installation process is almost as simple as cloning this build script and
running `docker-compose up`.

There are other Docker Compose setups available, including the [one](https://github.com/parkervcp/pterodactyl-panel-Dockerfile)
created by one of the project's primary developers, parkervcp. However, I opted
to create my own for a few reasons:

1. These setups detract from Docker's "one service per container" philosophy. While
it might be impossible to completely narrow down such a complex setup to one container,
there are services, such as PHP and Nginx, that can be separated.
2. I wanted to add a few alternative services for use in the Panel, such as Nginx
instead of caddy.

## Usage
The instructions are fairly self explanatory: clone the repository and launch the
stack.
```
git clone https://github.com/TehTotalPwnage/pterodactyl-panel-docker mypanel
cd mypanel
```
I'd recommend cloning the repository into a specific directory name unless you want
all your containers to be named pterodactylpaneldocker_service_number.
```
vim docker-compose.yml
```
In your favorite text editor, change the port that you want the panel binded to.
There are other settings you may need to modify that are documented below.
```
docker-compose pull
docker-compose build
docker-compose up
```
The panel should now be ready, and you can connect to it via localhost at the port
you specified in the Docker Compose file.

## API
To set the port for the HTTP server, adjust the setting under services, http, and
ports:
```
<host port number>:80
```
For the Panel, there are different environment variables that you can configure:
- `panel_url` - The FQDN that the Panel will be hosted on. Required. (https://mc.example.com)
- `timezone` - The timezone that the Panel will be hosted on. A list is available at http://php.net/manual/en/timezones.php.
- `email_driver` - The email driver for the Panel. Options are smtp, mail, mailgun, mandrill, or postmark.
- `panel_email` - The email address the panel should use. Required for all drivers.
- `email_name` - The display name emails sent should have. Required for all drivers.
- `email_user` - A username for the email server. Required for smtp, mandrill, mailgun, and postmark.
- `email_pass` - A password for the email server. Required for smtp.
- `email_domain` - The domain the driver should connect to. Required for smtp and mailgun.
- `email_port` - The port of the email server. Required for smtp.
- `admin_email` - The email address for the admin user. Required.
- `admin_first` - The first name for the admin user. Required.
- `admin_last` - The last name for the admin user. Required.
- `admin_pass` - The password for the admin user. Required.
- `admin_username` - The username for the admin user. Required.

## Caveats
- Do not stop the Docker Compose stack on the first run until supervisor announces
that the setup is complete! Errors may occur if you kill the process too early!
