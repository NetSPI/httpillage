httpillage is a command and control server designed to increase the effectiveness of Web-App testing through distributed attacks. HTTP(S) requests will be loaded into
the command and control server via the httpillage burp extender, or directly within the C&C web interface. Clients will be deployed on servers continuously polling the C&C looking for jobs, executing as they are made available.

httpillage current supports three modes of attack:

- Repeat: Designed for repeating a baseline request in rapid fashion, with a large quantity of threads. Useful in performance testing
- Dictionary: Iterate through a dictionary file to inject paylods in the HTTP request via custom defined payload markers `{P}`
- Bruteforce: Perform bruteforce attacks against a specified keyspace. Currently supports upper-case (u), lower-case (l) and numeric (d). To test a keyspace that matches [a-z][0-9]{3} provide the charset: `lddd`.

Response matching can be used to determine successful execution of a specific payload. When creating the job specify zero or more response matching strings or regular expressions. Upon receiving the job, nodes will be aware of the patterns to analyze, reporting back to the C&C upon success.

Deploying the Server 
---------------------
Ensure that the firewall will allow inbound access on port 3000, or specify a unique port.

	$ bundle install
	$ rake db:migrate db:seed
	$ rails s -b 0.0.0.0

Deploying the Nodes
-----
The nodes have only been tested with Ruby 2.2.3. Before deploying obtain a copy of the Node API Key from the C&C Settings panel (http://localhost:3000/settings). This key is used to authenticate the nodes. Providing an invalid key will result in server exceptions.

	$ bundle install
	$ ruby httpillage.rb --server="http://server:3000" --api-key="[APIKEY]"

Upon starting the client it'll constantly poll the server until it recieves a job. The client will spin up 5 threads that continuously send requests on behalf of the job. Clients will stop execution once the server changes the job status. 

Building Extender .Jar
----------------------

To build the extender .jar file, we first need to ensure that the system has ant, and is running version Java 7 or higher.

Navigate to the extender/bin/burp directory:

  $ cd extender/bin/burp

Build the jar using Apache ant:

  $ ant

After this has completed you should see a BUILD SUCCESSFUL message. The .jar file is located in extender/bin/burp/httpillage.jar. Import this into Burp.

Update the Server and API Token textfields within Burp to represent the values for the custom httpillage implementation.

Inside the proxy history table, right click any request and "send to httpillage." This will queue up the job on the C&C server. For verification that the response was recieved properly, click on the extender tab and you should see a C&C JSON encoded response within the Output tab.

Potential Use Cases
----------------------
- Denial of Service Testing
- Username Enumeration
- Defeating expiring tokens
- Forced Browsing