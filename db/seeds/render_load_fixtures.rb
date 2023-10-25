# frozen_string_literal: true

require 'active_record'
require 'active_record/fixtures'
require 'faker'

# rubocop:disable Rails
def render_load_fixtures
  # render.com seeding resolve
  # WARNING: Rails was not able to disable referential integrity.
  # This is most likely caused due to missing permissions.
  # Rails needs superuser privileges to disable referential integrity.
  #
  #     cause: PG::InsufficientPrivilege: ERROR:  permission denied: "RI_ConstraintTrigger_a_16826" is a system trigger
  #
  # rails aborted!
  # ActiveRecord::InvalidForeignKey: PG::ForeignKeyViolation: ERROR:  insert or update on table "taggings" violates foreign key constraint "fk_rails_9fcd2e236b"

  fixture_path = Rails.root.join('test/fixtures')

  fixtures = %w[
    users
    vacancies
    notifications
    acts_as_taggable_on/tags
    acts_as_taggable_on/taggings
    careers
    career/members
    career/steps
    career/step/members
    career/items
    resumes
    resume/answers
    resume/answer/comments
    resume/answer/likes
    resume/comments
    resume/educations
    resume/works
  ]

  puts '#############'
  puts 'Seeding start'
  fixtures.each do |path|
    table = path_to_class(path)
    next if table.count.positive?

    puts "Seed #{table.name}"
    ActiveRecord::FixtureSet.create_fixtures(fixture_path, path)
  rescue StandardError => e
    puts "#{path}: #{e.full_message}"
  end
  puts 'Seeding stop'
  puts '############'
end

# rubocop:enable Rails

def path_to_class(path)
  path.split('/').map(&:camelize).join('::').singularize.constantize
end
