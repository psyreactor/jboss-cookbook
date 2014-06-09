[![Build Status](https://travis-ci.org/psyreactor/jboss-cookbook.svg?branch=master)](https://travis-ci.org/psyreactor/jboss-cookbook)
Jboss Cookbook
==================

This cookbook installs JBoss EAP from a zip. This cookbook is based on [jboss-eap cookbook](https://github.com/andrewfraley/chef-jboss-eap)(not is a fork)

####[Jboss EAP](http://redhat.com/products/jbossenterprisemiddleware/)
"Boss is a division of Red Hat that provides support for the JBoss open source application server program and related services marketed under the JBoss Enterprise Middleware Suite (JEMS) brand. It is an open source alternative to commercial offerings from IBM WebSphere, Oracle BEA Services, and SAP NetWeaver.

The JBoss applications server is a J2EE platform for developing and deploying enterprise Java applications, Web applications and services, and portals.  J2EE allows the use of standardized modular components and enables the Java platform to handle many aspects of programming automatically"

Requirements
------------
- `java` - Not managed by this cookbook, yuo can use [java-cookbook](https://github.com/socrata-cookbooks/java)
- `JBoss EAP 6` - Packaged as a zip and stored on a web server acccessible by the node.

#### Cookbooks:
- No depends

The following platforms and versions are tested and supported using Opscode's test-kitchen.

- CentOS 5.8, 6.3

The following platform families are supported in the code, and are assumed to work based on the successful testing CentOS.


- Red Hat (rhel)
- Fedora
- Amazon Linux

Recipes
-------
#### jboss:default
##### Basic Config
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:jboss][:version]</tt></td>
    <td>String</td>
    <td>version of jboss to install</td>
    <td><tt>6.2.0</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:url]</tt></td>
    <td>String</td>
    <td>url for local repo</td>
    <td><tt>http://localhost/jboss/</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:path]</tt></td>
    <td>String</td>
    <td>Install Path for jboss</td>
    <td><tt>/opt</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:application]</tt></td>
    <td>String</td>
    <td>name of application</td>
    <td><tt>app</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:checksum]</tt></td>
    <td>String</td>
    <td>checksum of zip file</td>
    <td><tt>73c542c2e7f1102a3b51ab62e14023bcda227e737233327d2f17aa361c9ff05c</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:jboss_user]</tt></td>
    <td>String</td>
    <td>user for run jboss</td>
    <td><tt>jboss</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:jboss_group]</tt></td>
    <td>String</td>
    <td>user group for run jboss</td>
    <td><tt>jboss</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:java_home]</tt></td>
    <td>String</td>
    <td>set home of java</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:java_opts]</tt></td>
    <td>String</td>
    <td>java ops settings</td>
    <td><tt>'-Xms1303m -Xmx1303m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true'</tt></td>
  <tr>
    <td><tt>node[:jboss][:admin_user]</tt></td>
    <td>String</td>
    <td>User for admin console</td>
    <td><tt>admin</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:admin_passwd]</tt></td>
    <td>String</td>
    <td>Password for admin console user</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:startup_wait]</tt></td>
    <td>integer</td>
    <td>startup time wait the init script to give error</td>
    <td><tt>30</tt></td>
  </tr>
  <tr>
    <td><tt>node[:jboss][:shutdown_wait]</tt></td>
    <td>integer</td>
    <td>shutdown time wait the init script to give error</td>
    <td><tt>30</tt></td>
  </tr>
</table>


Usage
-----
### jboss::default
#### Example role:

```ruby
name "jboss"
description "JBoss EAP install"
run_list [
    "recipe[jboss]",
    ]

default_attributes: {
  jboss: {
      install_path: "/opt",
      application: "server1",
      url: "https://yourserver.local/jboss/",
      checksum: "0ef5d62a660fea46e0c204a9f9f35ad4",
      version: "6.2.0",
      admin_user: "admin",
      admin_passwd: "password"
    }
}

```
Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

[More details](https://github.com/psyreactor/jboss-cookbook/blob/master/CONTRIBUTING.md)

License and Authors
-------------------
Authors:
Lucas Mariani (Psyreactor)
- [marianiluca@gmail.com](mailto:marianiluca@gmail.com)
- [https://github.com/psyreactor](https://github.com/psyreactor)
-------------------
Authors: https://github.com/andrewfraley
