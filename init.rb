require 'default_module_hooks'
require 'projects_controller_patch'

Redmine::Plugin.register :default_module do
  name 'Default Module'
  author 'Nazar Hussain'
  description 'Choose default module for redmine projects'
  version '0.0.1'
  url 'https://github.com/nazarhussain/redmine_default_module'
  author_url 'http://microgigz.com'

  unless ProjectCustomField.exists?(:name => 'Project Default Module')
    ProjectCustomField.create(
        :name => 'Project Default Module',
        :field_format => 'list',
        :possible_values => Redmine::MenuManager.items(:project_menu).map { |p| p.name.to_s },
        :regexp => '',
        :min_length => nil,
        :max_length => nil,
        :is_required => false,
        :is_for_all => false,
        :is_filter => false,
        :position => 1,
        :searchable => false,
        :default_value => '',
        :editable => false,
        :visible => true,
        :multiple => false,
        :format_store => {:url_pattern => '', :edit_tag_style => ''},
        :description => 'Custom filed to store default module'
    )
  end

  # Here I have support for Redmine 1.x by falling back on Rails 2.x implementation.
  if Gem::Version.new("3.0") > Gem::Version.new(Rails.version) then
    Dispatcher.to_prepare do
      # This tells the Redmine version's controller to include the module from the file above.
      ProjectsController.send(:include, DefaultModule::ProjectsControllerPatch)
    end
  else
    # Rails 3.0 implementation.
    Rails.configuration.to_prepare do
      # This tells the Redmine version's controller to include the module from the file above.
      ProjectsController.send(:include, DefaultModule::ProjectsControllerPatch)
    end
  end
end