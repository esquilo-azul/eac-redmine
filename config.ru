# This file is used by Rack-based servers to start the application.

$server_mode = true

require ::File.expand_path('../config/environment',  __FILE__)
run RedmineApp::Application
