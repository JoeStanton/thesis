service "X-Time" do
  description "Internal project resourcing & forecasting tool"
  health { success "https://x-time.redacted.com" }
  dependency "Nginx"

  host_health(interval: 30) do
    disk_usage < "80%" or fail "Disk too full"
  end

  component "Nginx" do
    description "Reverse proxy and static asset web server"
    dependency "Ruby on Rails (Unicorn)"
    health(interval: 15) do
      running "nginx"
      listening 80
    end
  end

  component "Ruby on Rails (Unicorn)" do
    description "Multi-process Ruby application server"
    dependency "Redis"
    dependency "Postgres"
    dependency "FreeAgent API"
    health(interval: 10) do
      running "unicorn master"
      running "unicorn worker"
    end
  end

  component "Redis" do
    description "Deprecated"
    health(interval: 10) do
      running "redis-server"
      listening 6379
    end
  end

  component "Postgres" do
    description "Relational database storing all entities"
    health(interval: 10) do
      running "postgres"
      listening 5432
    end
  end

  component "FreeAgent API" do
    description "Source of users, projects & timesheet data"
    health(interval: 360) do
      success "http://www.freeagent.com/", timeout: 30
    end
  end
end
