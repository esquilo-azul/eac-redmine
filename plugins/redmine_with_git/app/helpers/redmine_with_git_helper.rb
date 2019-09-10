# frozen_string_literal: true

module RedmineWithGitHelper
  def export_api_curl_command
    curl_command("curl -JLO '#{export_backup_url(key: User.current.api_key)}'")
  end

  def import_api_curl_command
    curl_command(<<~IMPORT_CURL)
      curl -X POST \\
        -F '#{import_param_key}=@<PATH_TO_BACKUP_FILE>' \\
        -F 'key=#{User.current.api_key}' \\
        #{import_backup_url(format: 'json')}
    IMPORT_CURL
  end

  private

  def curl_command(command)
    content_tag(:pre, command)
  end

  def import_param_key
    "#{::RedmineWithGit::Tableless::Load.model_name.param_key}[path]"
  end
end
