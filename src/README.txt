= Application Design and Architecture

Author::    Rodolfo Andrés Ramírez Valenzuela
Date::      May 5 2016

The directory structure for the application and its documentation is as follows:

   AdventureGame/
         ├─ doc/                        Folder produced by RDoc.
         ├─ images/                     Folder for the documentation's image files.
         └─ src/                        Folder for the application's source code.
              ├─ db/                    Folder for the initial database records
              ├─ public/                Folder for the server's public documents.
              │       └─ css/           Folder for the application's CSS files.
              │       └─ fonts/         Folder for the application's font files.
              │       └─ img/           Folder for the application's asset image files.
              │       └─ js/            Folder for the application's client-JS files.
              ├─ models/                Folder for the application's models.
              ├       |_ states/                Folder for the application's state models.
              └─ views/                 Folder for the application's views (ERB files).
         └─ Rakefile                    Rake tasks to run the server, seeding the DB, and generate the documentation
         └─ Gemfile                     Application dependencies managed by Bundler

== Installing and Running the Application
In order to run the application you must install its dependencies. Type the following command for this to be done:

  bundle install

Once installed, run the following command to seed the database.
  rake seed

You can start the application by running the command:
  rake app

Once the server is running you must access it through the URL:
  <http://localhost:4567/>

== Documentation

In order to produce the documentation you must run the following command:
  rake doc

The root of the documentation should now be available at: +game/doc/index.html+

== 4+1 Architectural View Model

=== Logical View

link:/images/class_diagram.png

=== Process View

Diagram that shows the initial process of the application and the execution:

link:/images/Activity_Diagram.png

==== Fight Activity Diagram

link:/images/Fight_Activity.png

==== State Diagram

link:/images/state_diagram.png

=== Development View

link:/images/package_diagram.png

=== Physical View

link:/images/Deployment_diagram.png

=== Scenarios
link:/images/use_case.png

== Patterns Used

Briefly mention all the patterns that your application uses and identify where exactly. In our example, the following pattern are clearly used:

- <b>Domain-Specific Language</b>: The +app.rb+ file consists of a series of Sinatra _routes_. Sinatra is a DSL for creating web applications in Ruby.
- <b>Model-View-Controller</b>: The application follows the classical web implementation of the MVC architectural pattern. The models (+.rb+ files) and views (+.erb+ files) are stored in the corresponding +models+ and +views+ directory. The controller is contained in +server.rb+ file.
- <b>State Pattern</b>: All the +States.rb+ files implement this pattern, each state knows the current action of the player on the game, each state identifies each of the possible actions the player may do during the game.
- <b>Composite Pattern</b>:

== Acknowledgments

This section is optional. If somebody helped you with your project make sure to include her or his name here.

== References

Mention here any consulted books or web resources. Examples:


- \A. Harris, K. Haase. <em>Sinatra: Up and Running.</em> O'Reilly, 2011. {Safari Books Online}[http://proquestcombo.safaribooksonline.com/book/web-development/ruby/9781449306847].

- \Ph. Kruchten. <em>The 4+1 View Model of Architecture.</em> IEEE Software, vol. 12 (6), pp. 45-50, 1995. {\http://www.ics.uci.edu/~andre/ics223w2006/kruchten3.pdf}[http://www.ics.uci.edu/~andre/ics223w2006/kruchten3.pdf] Accessed April 14, 2016.

- \R. Olsen. <em>Design Patterns in Ruby.</em> Addison-Wesley, 2007. Available through {Safari Books Online}[http://proquestcombo.safaribooksonline.com/book/web-development/ruby/9780321490452].

- Ruby-Doc.org. <em>RDoc Markup Reference.</em> {\http://ruby-doc.org/stdlib-2.2.3/libdoc/rdoc/rdoc/RDoc/Markup.html}[http://ruby-doc.org/stdlib-2.2.3/libdoc/rdoc/rdoc/RDoc/Markup.html#class-RDoc::Markup-label-Block+Markup] Accessed May 06, 2016.
