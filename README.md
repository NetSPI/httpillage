This is a burp that is designed for distributing tasks across multiple nodes (or zombies). Commands will be loaded into
the command and control server via the httpillage burp extender. Clients will be continuously polling the C&C looking for jobs, executing as they are made available.

Building Extender .Jar
----------------------

To build the extender .jar file, we first need to ensure that the system has ant, and is running version Java 7 or higher.

Navigate to the extender/bin/burp directory:

	$ cd extender/bin/burp

Build the jar using Apache ant:

	$ ant

After this has completed you should see a BUILD SUCCESSFUL message. The .jar file is located in extender/bin/burp/httpillage.jar. Import this into Burp.

Inside the proxy history table, right click any request and "send to httpillage." This will queue up the job on the C&C server. For verification that the response was recieved properly, click on the extender tab and you should see a C&C JSON encoded response within the Output tab.

Deploying the Server
---------------------
Ensure that the firewall will allow inbound access on port 3000.

	$ bundle install
	$ rake db:migrate
	$ rails s -b 0.0.0.0

Deploying the Nodes
-----

Before starting an attack it is necessary to start the phantom and/or slimer xss-detection servers. Navigate to the xss-detector directory and execute the following to start phantom.js xss-detection script:

	$ bundle install
	$ ruby httpillage.rb --server="http://server:3000"

Upon starting the client it'll constantly poll the server until it recieves a job. The client will spin up 3 threads that continuously send requests on behalf of the job. Clients will stop execution once the server changes the job status. 
