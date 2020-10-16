# mailcatcher #

Here is (https://hub.docker.com/r/schickling/mailcatcher/ docker container) you can use for testing mail sending from your lovely application.

add to your docker-compose.yml

mail:
  image: schickling/mailcatcher
  ports:
     - 1080:1080

Do not forget to link this container to your app container, then use SMTP settings:

STMP: 
  server: mail
  port: 1025

and voila!

Open your browser at http://host:1080 and enjoy with preview of caught emails.

