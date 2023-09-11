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
            MyClass.username = username
            MyClass.password = password
            c.config_object[:basic_auth].values == [username, password]
          end
        end
      end

      rake_tasks do
        load File.expand_path('../../../tasks/rswag-ui_tasks.rake', __FILE__)
      end
    end    

    class MyClass
      @@username = '100 username'
      @@password = '100 password'

      def self.username
        @@username
      end
    
      def self.username=(new_username)
        @@username = new_username
      end
    
      def self.password
        @@password
      end
    
      def self.password=(new_password)
        @@password = new_password
      end
    end
  end
end
