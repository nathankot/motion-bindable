unless defined?(Motion::Project::Config)
  raise "The motion_bindable gem must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|

  Dir.glob(
    File.join(File.dirname(__FILE__), 'motion_bindable/**/*.rb')
  ).each do |file|
    app.files.unshift(file)
  end

  Dir.glob(
    File.join(File.dirname(__FILE__), 'strategies/**/*.rb')
  ).each do |file|
    app.files.unshift(file)
  end

end
