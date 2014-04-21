service 'World Risk Review' do
  description 'Assessing geo-political risk'
  health do
    success "http://worldriskreview.redacted.com"
  end
  dependency 'CDN (CloudFront)'

  host_health do
    disk_usage < "92%" or fail "Disk usage too high: #{disk_usage}"
  end

  component 'CDN (CloudFront)' do
    description 'Amazon CloudFront CDN for Public Site'
    dependency 'Public Site'
    dependency 'API'
    health do
      success "http://dxib3ntl0xr8y.cloudfront.net/"
    end
  end

  component 'Public Site' do
    description 'Amazon S3 - Static Site'
    health do
      success "http://world-risk-review.s3.amazonaws.com"
    end
  end

  component 'API' do
    description 'Node.js API interface to search'
    dependency 'ElasticSearch'
    health do
      listening 3000
      running 'api'
    end
  end

  component 'ElasticSearch' do
    description 'Search Index'

    health do
      listening 9200
    end
  end
end
