write_files:
  - path: /etc/httpd/conf/httpd.conf
    owner: root:root
    permissions: 0644
    content: |
      ServerTokens Prod
      ServerRoot "/etc/httpd"
      PidFile run/httpd.pid
      Timeout 120
      KeepAlive Off
      ExtendedStatus On
      
      Listen 0.0.0.0:80
      
      LoadModule auth_basic_module modules/mod_auth_basic.so
      LoadModule authz_host_module modules/mod_authz_host.so
      LoadModule include_module modules/mod_include.so
      LoadModule log_config_module modules/mod_log_config.so
      LoadModule logio_module modules/mod_logio.so
      LoadModule mime_magic_module modules/mod_mime_magic.so
      LoadModule headers_module modules/mod_headers.so
      LoadModule mime_module modules/mod_mime.so
      LoadModule status_module modules/mod_status.so
      LoadModule autoindex_module modules/mod_autoindex.so
      LoadModule vhost_alias_module modules/mod_vhost_alias.so
      LoadModule dir_module modules/mod_dir.so
      LoadModule alias_module modules/mod_alias.so
      
      User ${httpd_user}
      Group ${httpd_group}
      
      ServerAdmin enquiries@${domain_name}
      ServerName ${server_name}.${domain_name}
      
      UseCanonicalName Off
      
      DocumentRoot "/var/www/html"
      <Directory />
          Options FollowSymLinks
          AllowOverride None
      </Directory>
      
      AccessFileName .htaccess
      <Files ~ "^\.ht">
          Order allow,deny
          Deny from all
      </Files>
      
      TypesConfig /etc/mime.types
      DefaultType text/plain
      
      <IfModule mod_mime_magic.c>
          MIMEMagicFile conf/magic
      </IfModule>
      
      HostnameLookups Off
      
      ErrorLog /var/log/httpd/error_log
      LogLevel warn
      LogFormat "%%{X-Forwarded-For}i %h %l %u %t \"%r\" %>s %b \"%%{Referer}i\" \"%%{User-Agent}i\" \"%%{cookie}n\" %%{pid}P" combined
      LogFormat "%h %l %u %t \"%r\" %>s %b" common
      LogFormat "%%{Referer}i -> %U" referer
      LogFormat "%%{User-agent}i" agent
      CustomLog /var/log/httpd/access_log combined
      
      ServerSignature Off
      
      IndexOptions FancyIndexing VersionSort NameWidth=*
      
      AddDefaultCharset UTF-8
      AddCharset ISO-8859-1  .iso8859-1  .latin1
      
      <Location /server-status>
          SetHandler server-status
          Order deny,allow
          Deny from all
          Allow from ${status_allow_list}
      </Location>
      <Location /server-info>
          SetHandler server-info
          Order deny,allow
          Deny from all
          Allow from ${status_allow_list}
      </Location>
      
      NameVirtualHost *:80
      <VirtualHost *:80>
          ServerName ${server_name}.${domain_name}
      
          # Return 204 to any root-level requests
          <Location />
              RedirectMatch 204 ^(?:(?:http[s]?):\/)?\/?(?:[^:\/\s]+?\.)*([^:\/\s]+\.[^:\/\s]+)
          </Location>
      
          RewriteEngine On
          RewriteRule ${archive_rewrite} [R=301,L]
      
          Alias "/archive" "${archive_docroot}"
          <Directory "${archive_docroot}">
              AllowOverride none
              Options +Indexes
              Order allow,deny
              Allow from all
          </Directory>
      
          Alias "/submissions" "${submissions_docroot}"
          <Directory "${submissions_docroot}">
              AllowOverride none
              Options +Indexes
              Order allow,deny
              Allow from all
          </Directory>
      
          # Ensure files are downloaded, not rendered
          <Files *.xml>
              ForceType application/xml
              Header set Content-Disposition attachment
          </Files>
      </VirtualHost>
      
      #Include conf.d/*.conf

runcmd:
  - chkconfig httpd on
