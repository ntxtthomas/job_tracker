namespace :opportunities do
  desc "Standardize salary_range format for all opportunities"
  task standardize_salaries: :environment do
    puts "Standardizing salary ranges..."

    opportunities = Opportunity.where.not(salary_range: [ nil, "" ])
    total = opportunities.count

    puts "Found #{total} opportunities with salary ranges"

    opportunities.find_each.with_index do |opportunity, index|
      old_value = opportunity.salary_range
      opportunity.save # This will trigger the before_save callback
      new_value = opportunity.reload.salary_range

      if old_value != new_value
        puts "#{index + 1}/#{total}: Updated '#{old_value}' -> '#{new_value}'"
      else
        puts "#{index + 1}/#{total}: No change for '#{old_value}'"
      end
    end

    puts "\nStandardization complete!"
  end
end
