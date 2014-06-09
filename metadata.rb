name             'jboss'
maintainer       'Lucas Mariani'
maintainer_email 'lmariani@lojack.com.ar'
license          'Apache 2.0'
description      'Installs/Configures jboss'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue "0.1.0"

recommends 'java'
