The integration tests require that apache is running and test files are copied
to the default web directory.

## Enable Apache
If apache is not already setup, you will need to enable php in httpd.conf

Open httpd.conf for editing:
`sudo vim /etc/apache2/httpd.conf`

Find:
`#LoadModule php5_module libexec/apache2/libphp5.so`
and uncomment it so it is enabled
`LoadModule php5_module libexec/apache2/libphp5.so`

Save the file and exit

## Start Apache
`apachectl start`

## Copy Files
Copy the test pages across:
`sudo cp -r <project_root>/IntegrationTests /Library/WebServer/Documents/`

You should now be able to naviagte to http://localhost/IntegrationTests/resourcetrackers.html
