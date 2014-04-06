class Service
  attr_accessor :name

  def description(value)
    @description = value
  end
end

def service(name, &block)
  service = Service.new
  service.name = name
  service.instance_eval &block
end

service 'Example Service' do
  description 'ABC'
end
