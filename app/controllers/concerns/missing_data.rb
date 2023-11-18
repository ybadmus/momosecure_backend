# frozen_string_literal: true

module MissingData
  # Render and error if parameters are missing
  def missing_params!(*)
    missing_data(params, *)
  end

  def missing_data(data, *required_fields)
    missing = []

    required_fields.each do |field|
      required_field = boolean?(data[field]) ? data[field].to_s : data[field]

      missing << field if required_field.blank?
    end
    raise(BadRequestError, "Missing Parameters: #{missing.join(' ,').split("\n")[0]}") if missing.present?
  end

  def boolean?(value)
    [true, false].include?(value)
  end
end
