SL2017
================

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is open source and supported by subscribers. Please join RailsApps to support development of Rails Composer.

Problems? Issues?
-----------

Need help? Ask on Stack Overflow with the tag 'railsapps.'

Your application contains diagnostics in the README file. Please provide a copy of the README file when reporting any issues.

If the application doesn’t work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include the diagnostics.

Ruby on Rails
-------------

This application requires:

- Ruby 2.1.2
- Rails 4.1.5

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------

Start by reading through [this 6 part guide on setting up the app and environment for deployment of a Rails app on Debian](http://vladigleba.com/blog/2014/03/05/deploying-rails-apps-part-1-securing-the-server/)

		mkdir sl2017
		cd sl2017
		rbenv local 2.1.2
		rails new . -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb
		spring rails server
		mate .env config/production.rb config/sl2017.nginx.conf config/secrets.yml config/unicorn_init.sh config/unicorn.rb 
		rake secret
		chmod +x unicorn_init.sh

		ssh <server> -l<user>
		sudo chgrp oxenserver /etc/nginx/sites-enabled
		sudo chmod g+w /etc/nginx/sites-enabled
		sudo chgrp oxenserver /etc/init.d
		sudo chmod g+w /etc/init.d
		sudo service nginx restart
		sudo update-rc.d unicorn_sl2017 defaults
		

















##### Deploying
When you're ready to deploy

* cap production setup:upload_yml
* cap production deploy
* cap production setup:seed\_db

Further deployments

* cap production deploy

Changing something which involves restarting the webserver and application server

* sudo service nginx restart
* /etc/init.d/unicorn_sl2017 restart

Documentation and Support
-------------------------

####Bower package management
Bower is a Javascript package manager and to use it with Rails follow this guide: http://blog.revealinghour.in/rails/2014/05/15/bower-and-rails/

Important commands are:

* bower search <package>
* bower info <package>
* bower install <package>#<version> --save

Issues
-------------
* when building email - check [email fun with Rails](http://www.sitepoint.com/fun-sending-mail-rails/)
* when designing forms - remember about [satisficing](http://www.sitepoint.com/satisficing-mean-web-forms)

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------

# prepare app with deployment to Debian
#
mkdir <project>
cd <project>
rbenv local 2.1.2
rails new . -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb
mate .
	<edit config/deploy.rb>
	<edit config/deploy/production.rb>
  <add config/<project>.nginx.conf
		
<setup GitHub repo>
<add bookmark to SourceTree>

spring rails server
