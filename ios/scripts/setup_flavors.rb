#!/usr/bin/env ruby
require 'xcodeproj'
require 'xcodeproj/config'

FLAVORS = ['dev', 'qa', 'prod'].freeze
BASE_CONFIGS = ['Debug', 'Release', 'Profile'].freeze
BUNDLE_ID = 'com.bancosol.warehouse'.freeze
DISPLAY_NAMES = {
  'dev' => 'Warehouse Dev',
  'qa' => 'Warehouse QA',
  'prod' => 'Warehouse'
}.freeze

project_path = File.join(__dir__, '..', 'Runner.xcodeproj')
project = Xcodeproj::Project.open(project_path)

puts "Opening project: #{project_path}"

runner_target = project.targets.find { |t| t.name == 'Runner' }
runner_tests_target = project.targets.find { |t| t.name == 'RunnerTests' }

unless runner_target
  puts "Error: Runner target not found"
  exit 1
end

FLAVORS.each do |flavor|
  BASE_CONFIGS.each do |base|
    config_name = "#{base}-#{flavor}"

    if project.build_configuration_list.build_configurations.any? { |c| c.name == config_name }
      puts "  Config #{config_name} already exists (project level), skipping"
      next
    end

    config_type = base == 'Debug' ? :debug : :release
    new_config = project.add_build_configuration(config_name, config_type)

    base_config = project.build_configuration_list.build_configurations.find { |c| c.name == base }
    if base_config
      new_config.build_settings.merge!(base_config.build_settings.dup)
    end

    puts "Created project-level config: #{config_name}"

    runner_config = runner_target.add_build_configuration(config_name, config_type)
    base_runner_config = runner_target.build_configuration_list.build_configurations.find { |c| c.name == base }
    if base_runner_config
      runner_config.build_settings.merge!(base_runner_config.build_settings.dup)
      runner_config.base_configuration_reference = base_runner_config.base_configuration_reference
    end

    runner_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "#{BUNDLE_ID}#{flavor == 'prod' ? '' : ".#{flavor}"}"
    runner_config.build_settings['FLUTTER_APP_NAME'] = DISPLAY_NAMES[flavor]

    puts "  Created Runner target config: #{config_name}"

    if runner_tests_target
      tests_config = runner_tests_target.add_build_configuration(config_name, config_type)
      base_tests_config = runner_tests_target.build_configuration_list.build_configurations.find { |c| c.name == base }
      if base_tests_config
        tests_config.build_settings.merge!(base_tests_config.build_settings.dup)
        tests_config.base_configuration_reference = base_tests_config.base_configuration_reference
      end

      tests_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "#{BUNDLE_ID}#{flavor == 'prod' ? '' : ".#{flavor}"}.RunnerTests"

      puts "  Created RunnerTests target config: #{config_name}"
    end
  end
end

BASE_CONFIGS.each do |base|
  base_config = runner_target.build_configuration_list.build_configurations.find { |c| c.name == base }
  if base_config && !base_config.build_settings['FLUTTER_APP_NAME']
    base_config.build_settings['FLUTTER_APP_NAME'] = 'Warehouse'
    puts "Added FLUTTER_APP_NAME to Runner base config: #{base}"
  end
end

project.save
puts "Project saved successfully!"
