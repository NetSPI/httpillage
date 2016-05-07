package burp;

import java.util.regex.*;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.Font;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.net.URL;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.ScrollPaneConstants;
import javax.swing.SwingUtilities;
import javax.swing.JMenuItem;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import burp.ITab;

public class BurpExtender implements IBurpExtender, ITab, IContextMenuFactory, ActionListener {
    private static final String VERSION = "1.0.1-beta";

    public IBurpExtenderCallbacks mCallbacks;
    private IExtensionHelpers     helpers;
    private PrintWriter           stdout;
    private PrintWriter           stderr;
    private HttpClient            client;
    private static String         httpillageServerUrl           = "http://localhost:3000";
    private static String         httpillageServerKey           = "gsYr4l70l08bcr77cZJMGrBUMYqhQlnR8KrqZWbI3ehH39OX8qb1hK2EcxkW";

    public JLabel                 htmlDescription;
    public JPanel                 mainPanel;
    public JPanel                 serverConfig;
    public JPanel                 notice;

    public JTextField             httpillageServer;
    public JLabel                 httpillageServerHeader;
    public JTextField             httpillageServerKeyText;
    public JLabel                 httpillageServerKeyHeader;

    public JTabbedPane            tabbedPane;
    public JButton                btnAddText;
    public JButton                btnSaveTabAsTemplate;
    public JButton                btnRemoveTab;

    public IHttpService           selectedServiceForPillage;
    public byte[]                 selectedRequestForPillage;


    public String getTabCaption() {

        return "httpillage";
    }

    public Component getUiComponent() {

        return this.mainPanel;
    }

    public void registerExtenderCallbacks(IBurpExtenderCallbacks callbacks) {

        this.mCallbacks = callbacks;

        this.client = HttpClientBuilder.create().build();
        this.helpers = callbacks.getHelpers();

        callbacks.setExtensionName("httpillage");
        this.stdout = new PrintWriter(callbacks.getStdout(), true);
        this.stderr = new PrintWriter(callbacks.getStderr(), true);

        callbacks.registerContextMenuFactory(this);

        SwingUtilities.invokeLater(new Runnable() {

            public void run() {
                BurpExtender.this.mainPanel = new JPanel(new GridLayout(1, 1));

                /*
                 * Notice Stuff
                 */
                BurpExtender.this.notice = new JPanel();
                JLabel titleLabel = new JLabel("<html><center><h2>httpillage</h2>Created By: <em>John Poulin</em> (@forced-request)<br />\n" +
                    "Version: " + BurpExtender.this.VERSION + "</center><br />");

                String initialText = "<html>\n" +
                "<em>httpillage is a tool designed to allow the distribution of victim-based tasks...</em><br /><br />\n" +
                "<b>Getting started:</b>\n" +
                "<ul>\n" +
                "    <li>Ensure an accessible httpillage server is deployed</li>\n" +
                "    <li>Manually start a few nodes</li>\n" +
                "    <li>Use this extender to create jobs for the nodes to complete</li>" +
                "</ul>\n"; 
                BurpExtender.this.htmlDescription = new JLabel(initialText);
                BurpExtender.this.notice.add(titleLabel);
                BurpExtender.this.notice.add(BurpExtender.this.htmlDescription);

                /*
                 Server Config
                 */
                BurpExtender.this.serverConfig = new JPanel(new GridLayout(2,2));

                BurpExtender.this.httpillageServer = new JTextField(20);
                BurpExtender.this.httpillageServer
                        .setText(BurpExtender.httpillageServerUrl);
			
				
                BurpExtender.this.httpillageServerHeader = new JLabel("httpillage Server URL:");

                BurpExtender.this.httpillageServerKeyText = new JTextField(20);
                BurpExtender.this.httpillageServerKeyText
                        .setText(BurpExtender.httpillageServerKey);
            
                
                BurpExtender.this.httpillageServerKeyHeader = new JLabel("httpillage Server KEY:");

                BurpExtender.this.serverConfig
                        .add(BurpExtender.this.httpillageServerHeader);
                BurpExtender.this.serverConfig.add(BurpExtender.this.httpillageServer);

                 BurpExtender.this.serverConfig
                        .add(BurpExtender.this.httpillageServerKeyHeader);
                BurpExtender.this.serverConfig.add(BurpExtender.this.httpillageServerKeyText);

                BurpExtender.this.mainPanel.add(BurpExtender.this.notice);
                BurpExtender.this.mainPanel.add(BurpExtender.this.serverConfig);

                BurpExtender.this.mCallbacks
                        .customizeUiComponent(BurpExtender.this.mainPanel);
                BurpExtender.this.mCallbacks.addSuiteTab(BurpExtender.this);
            }
        });
    }

    @Override
    public ArrayList<JMenuItem> createMenuItems(IContextMenuInvocation invocation) {
        ArrayList<JMenuItem> menu = new ArrayList<JMenuItem>();
        byte ctx = invocation.getInvocationContext();
        
        if (ctx == IContextMenuInvocation.CONTEXT_PROXY_HISTORY ||
            ctx == IContextMenuInvocation.CONTEXT_MESSAGE_VIEWER_REQUEST ||
            ctx == IContextMenuInvocation.CONTEXT_MESSAGE_EDITOR_REQUEST) {
            IHttpRequestResponse[] request = invocation.getSelectedMessages();

            this.selectedServiceForPillage = request[0].getHttpService();
            this.selectedRequestForPillage = request[0].getRequest();
            JMenuItem item = new JMenuItem("Send to httpillage", null);
            item.addActionListener(this);
            menu.add(item);
        }

        return menu;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String requestString = new String(this.selectedRequestForPillage);

        String http_method = http_method_from_request(requestString);
        String http_uri = full_uri_from_request(requestString, this.selectedServiceForPillage.getProtocol());
        String http_headers = new String(http_headers_from_request(requestString).getBytes());
        String http_data = new String(post_data_from_request(requestString).getBytes());

        // Hard coded, for now
        String attack_type = "repeat";
        String status = "active";

        this.stdout.println("Going to process the following message:");
        this.stdout.println("\tDestination Method: " + http_method);
        this.stdout.println("\tDestination Host: " + http_uri);
        this.stdout.println("\tDestination Headers: " + http_headers);
        this.stdout.println("\tDestination data: " + http_data);


        // Start Post
        HttpPost request = new HttpPost(BurpExtender.this.httpillageServer.getText() + "/api/job/create");

        // Add authorization key
        request.setHeader("X-Auth-Token", BurpExtender.this.httpillageServerKeyText.getText());
        
        try {
            List nameValuePairs = new ArrayList(6);
            nameValuePairs.add(new BasicNameValuePair("http_method",
                        http_method));
            nameValuePairs.add(new BasicNameValuePair("http_uri",
                        http_uri));
            nameValuePairs.add(new BasicNameValuePair("http_headers",
                        http_headers));
            nameValuePairs.add(new BasicNameValuePair("http_data",
                        http_data));
            nameValuePairs.add(new BasicNameValuePair("attack_type",
                        attack_type));
            nameValuePairs.add(new BasicNameValuePair("status",
                        status));

            request
                .setEntity(new UrlEncodedFormEntity(nameValuePairs));

                HttpResponse response = this.client.execute(request);
                String responseAsString = EntityUtils.toString(response
                        .getEntity());

            this.stdout.println("Response recieved from C&C: " + responseAsString);
        } catch (Exception ex) {
                this.stderr.println(ex.getMessage());
        }
    }

    public String http_method_from_request(String req) {
        String victimMethod = "";

        String urlPattern = "(GET|POST|PUT|PATCH|DELETE) (.*) H";
        Pattern url = Pattern.compile(urlPattern);
        Matcher urlMatcher = url.matcher(req);

        while (urlMatcher.find()) {
            victimMethod = urlMatcher.group(1);
        }

        return victimMethod;
    }

    public String full_uri_from_request(String req, String proto) {
        String victimUrl = "";
        String victimHost = "";

        String urlPattern = "(GET|POST|PUT|PATCH|DELETE) (.*) H";
        Pattern url = Pattern.compile(urlPattern);
        Matcher urlMatcher = url.matcher(req);

        String hostPattern = "Host: (.*)";
        Pattern host = Pattern.compile(hostPattern);
        Matcher hostMatcher = host.matcher(req);

        while (urlMatcher.find()) {
            victimUrl = urlMatcher.group(2); 
        }

        while(hostMatcher.find()) {
            victimHost = hostMatcher.group(1);
        }

        victimUrl = proto + "://" + victimHost + victimUrl;

        return victimUrl;
    }

    // @TODO
    public String http_headers_from_request(String req) {
        String headers = "";

        this.stdout.println("We're in here trying to get headesr");

        String headerPatternString = "(.*)\r?\n";
        Pattern headerPattern = Pattern.compile(headerPatternString);
        Matcher headerMatcher = headerPattern.matcher(req);

        // Skip first line, we don't want to include that
        headerMatcher.find();

        while(headerMatcher.find()) {
            headers += headerMatcher.group(1) + "\n";
        }

        return headers;
    }

    public String post_data_from_request(String req) {
        String postData = "";

        String postPatternString = "\r?\n\r?\n(.*)";
        Pattern postPattern = Pattern.compile(postPatternString);
        Matcher postMatcher = postPattern.matcher(req);

        while (postMatcher.find()) {
            postData = postMatcher.group(1);
        }

        return postData;
    }
}