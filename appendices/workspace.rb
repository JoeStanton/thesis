service 'Workspace+' do
  health do
    success "https://workspace.redacted.com"
    ssl_certificate_valid "https://workspace.redacted.com"
  end

  dependency 'Nginx'
  dependency 'ADFS'
  dependency 'Routing Infrastructure'

  host_health do
    disk_usage < "90%" or fail "Disk too full"
  end

  component 'Routing Infrastructure' do
    description 'Firewall & Routing'
  end

  component 'ADFS' do
    description 'SSO Service'
    health do
      success 'https://login.workspace.dev/IdpInitiatedLogin.aspx'
    end
  end

  component 'Nginx' do
    description 'Static asset web server and reverse-proxy'
    dependency 'Search Portal Application'
    health do
      running 'nginx'
      listening 80
    end
  end

  component 'Search Portal Application' do
    description 'Express.js search interface'
    dependency 'Search Index'
    dependency 'Redis'
    health do
      running 'www'
      listening 3000
    end
  end

  component 'Real-Time Crawler' do
    description 'Listens for changes from Sharepoint'
    dependency 'RabbitMQ'
    dependency 'Sharepoint API'
    dependency 'Search Index'
    health do
      running 'realtime-crawler'
    end
  end

  component 'RabbitMQ' do
    description 'Distributed queue for change notifications'
    health do
      running 'rabbitmq'
    end
  end

  component 'Discovery Crawler' do
    description 'Crawls LDAP, Chatter, Redis for new users/documents'
    dependency 'Search Index'
    dependency 'Sharepoint API'
    dependency 'Chatter API'
    dependency 'Active Directory (LDAP)'
    health do
      running 'discovery-crawler'
    end
  end

  component 'Sharepoint API' do
    description 'Primary Content Management System'
    dependency 'ADFS'
  end
  component 'Active Directory (LDAP)' do
    description 'Internal User Profiles'
  end
  component 'Chatter API' do
    description 'External User Profiles'
  end

  component 'Redis' do
    description 'Key-Value store of session data'
    health do
      running 'redis-server'
      listening 6879
    end
  end

  component 'Search Index' do
    description 'ElasticSearch powered cluster'
    health do
      running 'elasticsearch'
      listening 9200
    end
  end
end
