# Provides common behavior that is used in CSV-based imports for credentials.
require 'csv'
class Metasploit::Credential::Importer::CSV::Base
  include Metasploit::Credential::Importer::Base

  #
  # Attributes
  #

  # @!attribute data
  #   An {IO} that holds the CSV data. {File} in normal usage, {StringIO} in testing
  #   @return [IO]
  attr_accessor :data

  #
  # Method Validations
  #
  validate :header_format_and_csv_wellformedness

  private

  # Invalid if CSV is malformed or headers are not in compliance.
  #
  # @return [void]
  # TODO: add new i18n stuff for the error strings below
  def header_format_and_csv_wellformedness
    begin
      file = CSV.new(data)
      if file.present?
        first_row = file.first
        if first_row.present?
          header_symbols = first_row.map do |row|
            if row.present? then row.to_sym else :blank end
          end
          return header_symbols == self.class.const_get(:VALID_CSV_HEADERS)
        end
        errors.add(:file_path, :incorrect_public_private_csv_headers)
      end
    rescue
      errors.add(:file_path, :malformed_csv)
    end
  end

end