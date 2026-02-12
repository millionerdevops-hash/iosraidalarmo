require 'xcodeproj'

# Path to your project
project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Find the Runner target
target = project.targets.find { |t| t.name == 'Runner' }
if target.nil?
  abort("Could not find target 'Runner' in #{project_path}")
end

# Find the Runner group
group = project.main_group.find_subpath(File.join('Runner'), true)
if group.nil?
  abort("Could not find group 'Runner' in #{project_path}")
end

# Add Runner.entitlements file reference if it doesn't exist
entitlements_file = 'Runner.entitlements'
file_ref = group.find_file_by_path(entitlements_file)
unless file_ref
  puts "Adding #{entitlements_file} to project..."
  file_ref = group.new_file(entitlements_file)
end

# Update build settings for all configurations
puts "Updating build settings for target '#{target.name}'..."
target.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = "Runner/#{entitlements_file}"
  # Ensure bundle identifier matches
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.raidalarm'
  # Ensure development team is empty (Codemagic handles signing)
  config.build_settings['DEVELOPMENT_TEAM'] = ''
end

# Save the project
project.save
puts "Successfully updated #{project_path} with entitlements."
