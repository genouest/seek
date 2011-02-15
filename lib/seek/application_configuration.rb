module Seek
  class ApplicationConfiguration

    @@pagination_settings ||= nil

    def self.default_page controller
      unless @@pagination_settings
        configpath           =File.join(RAILS_ROOT, PAGINATION_CONFIG_FILE)
        @@pagination_settings=YAML::load_file(configpath)
      end
      @@pagination_settings[controller.to_s]["index"]
    end

  end
end