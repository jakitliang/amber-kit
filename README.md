# Amber Kit
A glitter network toolkit

> Amber is a easy using network tool for web apps.

Install
----------------
`$ gem install amber-kit`

Run It
----------------
In terminal:

`$ amber`

Amber server binds 3001 port as default, just open your browser and visit <http://localhost:3001>.

It is a empty server so that you can see nothing but 404 page.

Simple start
----------------
Create file `app.rb`:

	require "amber"
	app = Amber.new do |amber|
	  amber.route.map('/', Amber::Http::Request::GET) do
	    "<html>Hello Amber!</html>"
	  end
	end
	app.run

Then run:

`$ amber app.rb`

Open your browser and visit <http://localhost:3001/> you will see the page "Hello Amber!".

Description
----------------
Web can use amber in such:

1. Web crawler
2. Web middle layer
3. Proxy server
4. Web service
5. Create your own site

Web Crawler
----------------
Amber has `Switch` tool for fetch data.

You can almost fetch anything from any website.

Web middle layer
------------------
If you are maintain a large website and web service. You may try to use Amber for manage routines between any URL.

Clean up dirty data and holds a tidy environment.

Proxy server
------------------
You can forward a page to another page, or a web service to another web service

Web service
-------------------
Amber is RESTFul design so you can easy binding route for your web service development.

Create your own site
-------------------
Amber is basically support MVC and you an design your own View which can be JSON / HTML, and Controllers should compact them and return as View directly.

Also, you can return an String and Amber will regard it as a pure HTML page.

DEMO
-------------------

Here is a little sample:

<http://pingz.org.cn/amber/demo.zip>

Contact
-------------------
Email: jakit_liang@outlook.com

Twitter: @jakit_jie

Github: jakitto

&copy; 2017 Jakit. All rights Reserved.
