class Daemon
  def self.all
    @@all ||= Daemons::Rails::Monitoring.statuses.each_with_index.map { |v, i| Daemon.new(v[0], i) }
  end

  def self.find(id)
    all.each do |d|
      return d if d.id == id.to_s
    end
    fail ActiveRecord::RecordNotFound
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

  def stop
    @controller.stop
  end

  def restart
    stop
    start
  end

  def name
    @controller.app_name
  end

  def running
    @controller.status == :running
  end

  def log_file
    "#{Rails.root}/log/#{@controller.app_name}.log"
  end

  def autostart
    return false unless ActiveRecord::Base.connection.table_exists? Setting.table_name
    Setting.plugin_daemons_manager[autostart_key]
  end

  def toogle_autostart
    all = Setting.plugin_daemons_manager
    all[autostart_key] = !autostart
    Setting.plugin_daemons_manager = all
  end

  def to_s
    id
  end

  private

  def autostart_key
    "daemons.#{@controller.app_name}.autostart"
  end
end
