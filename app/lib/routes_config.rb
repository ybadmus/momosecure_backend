# frozen_string_literal: true

class RoutesConfig
  class << self
    def subdomain
      options = { 'staging' => 'momosecure-api.staging', 'production' => 'momosecure-api', 'preview' => pr_number }
      options[env] || ''
    end

    def path
      %w[staging production preview].include?(env) ? '' : 'api'
    end

    private

    def env
      ENV['ENVIRONMENT'] == 'preview' ? 'preview' : Rails.application.credentials.environment
    end

    def pr_number
      if ENV['PR_NUMBER'] == 'pre-release-momosecure'
        'pre-release-momosecure'
      else
        "pr-#{ENV['PR_NUMBER']}-momosecure"
      end
    end
  end
end
