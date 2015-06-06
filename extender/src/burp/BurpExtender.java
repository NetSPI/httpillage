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

import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import burp.ITab;

public class BurpExtender implements IBurpExtender, ITab, IContextMenuFactory, ActionListener {
    private static final String VERSION = "0.1.0";

    public IBurpExtenderCallbacks mCallbacks;
    private IExtensionHelpers     helpers;
    private PrintWriter           stdout;
    private PrintWriter           stderr;
    private HttpClient            client;
    private static String         httpillageServerUrl           = "http://ec2-52-7-111-135.compute-1.amazonaws.com:3000";

    public JLabel                 htmlDescription;
    public JPanel                 mainPanel;
    public JPanel                 serverConfig;
    public JPanel                 notice;
    public JTextField             httpillageServer;
    public JLabel                 httpillageServerHeader;

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
                "<em>httpillage is a tool designed to allow the distribution of intruder-based tasks...</em><br /><br />\n" +
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
                BurpExtender.this.serverConfig = new JPanel(new GridLayout(1,2));

                BurpExtender.this.httpillageServer = new JTextField(20);
                BurpExtender.this.httpillageServer
                        .setText(BurpExtender.httpillageServerUrl);
			
				
                BurpExtender.this.httpillageServerHeader = new JLabel("httpillage Server URL:");

                BurpExtender.this.serverConfig
                        .add(BurpExtender.this.httpillageServerHeader);
                BurpExtender.this.serverConfig.add(BurpExtender.this.httpillageServer);

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
        // Only show context menu for scanner results...
        if (ctx == IContextMenuInvocation.CONTEXT_PROXY_HISTORY) {
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
        // Do something
        this.stdout.println("Attempting to perform action");
        this.stdout.println("Going to process the following message: " + new String(this.selectedRequestForPillage));
    }
}