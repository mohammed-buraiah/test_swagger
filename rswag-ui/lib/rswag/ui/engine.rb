require 'rswag/ui/middleware'
require 'rswag/ui/basic_auth'

module Rswag
  module Ui
    class Engine < ::Rails::Engine
      isolate_namespace Rswag::Ui

      initializer 'rswag-ui.initialize' do |app|
        middleware.use Rswag::Ui::Middleware, Rswag::Ui.config

        if Rswag::Ui.config.basic_auth_enabled
          c = Rswag::Ui.config
          app.middleware.use Rswag::Ui::BasicAuth do |username, password|
            c.username = username
            c.password = password

            if username.empty?
              c.config_object[:basic_auth] = { username: nil, password: nil }
            elsif c.config_object[:basic_auth].nil?
              c.config_object[:basic_auth] = { username: username, password: password }
            end

            c.config_object[:basic_auth].values == [username, password]      
          end
        end
      end

      rake_tasks do
        load File.expand_path('../../../tasks/rswag-ui_tasks.rake', __FILE__)
      end
    end
  end
end
