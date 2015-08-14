class Daemon
  def self.all    
    @@all ||= Daemons::Rails::Monitoring.statuses.each_with_index.map { |v, i| Daemon.new(v[0], i)}
  end
  
  def self.find(id)
    all.each do |d|
      return d if d.id == id.to_s
    end    
    raise ActiveRecord::RecordNotFound
  end
  
  def initialize(name, id)
    @controller = Daemons::Rails::Monitoring.controller(name)    
    @id = id
  end
  
  def id
    @id.to_s
  end
  
  def start
    @controller.start
  end
  
  def name
    @controller.app_name
  end
  
  def running
    @controller.status == :running
  end
  
  def to_s
    id
  end
end
