service 'The X Awards Site' do
  health do
    success "http://redacted-awards.co.uk"
  end
  dependency 'Nginx'

  host_health do
    disk_usage < "90%" or fail "No disk space left"
  end

  component 'Nginx' do
    description 'reverse proxy and cache'
    type :webserver 
    version '1.4.0'
    dependency 'Application'

    health do
      running 'nginx'
      listening 80 
    end
  end

  component 'Application' do
    description 'Express.js Web Application'
    type :application
    dependency 'MongoDB'
    dependency 'Redis'
    health do
      running 'www'
      listening 3000
    end
  end

  component 'MongoDB' do
    description 'open-source document database'
    type :database 
    version 'v2.4.8'

    health do
      running 'mongod'
      listening 27017 
    end
  end
  component 'Redis' do
    description 'simple networked key value store'
    type :database 
    version 'version'

    health do
      running 'redis-server'
      listening 6379 
    end
  end
end
