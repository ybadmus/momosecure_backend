# frozen_string_literal: true

require 'audited'

Audited::Railtie.initializers.each(&:run)

Audited.max_audits = 10 # keep only 10 latest audits
