results = []
Dir["#{Rails.root}/lib/daemons/*_ctl"].each do |f|
  Rails.logger.info "Inicializando \"#{f}\""
  results << `ruby #{f} start`
end
results.delete_if { |result| result.nil? || result.empty? }
puts results.join unless results.empty?