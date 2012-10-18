Facebook XSCF Exploit
=====================

This is a Proof of Concept exploit for Cross-Site Content Forgery on Facebook.

This vulnerability was initially discovered by blackhatacademy and disclosed here: http://seclists.org/fulldisclosure/2011/Oct/404

Since then, facebook has taken rudementary steps to protect against this attack, unsucessfully.

A video demo of this software can be seen at: http://www.youtube.com/watch?v=Vrb_1TZVk20

This software is a proof of concept and is not to be used to break any law.
I will not be held responsible for your actions.



INSTALLATION
------------

* install ruby
* apt-get install libxml2 libxml2-dev libxslt1-dev sqlite3 libsqlite3-dev
* gem install ronin
* git clone https://github.com/ronin-ruby/ronin-web.git
* cd ronin-web
* bundle install
* gem build ronin-web.gemspec
* gem install ronin-web-0.3.0.rc1.gem
* gem install googl

