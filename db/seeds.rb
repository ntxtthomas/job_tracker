# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Seed Technologies
technologies_data = {
  "Backend" => [
    "Ruby on Rails",
    "Python",
    "Django",
    "Flask",
    "Node.js",
    "Express",
    "Java",
    "Spring Boot",
    "PHP",
    "Laravel",
    ".NET",
    "C#",
    "Go",
    "Elixir",
    "Phoenix"
  ],
  "Frontend" => [
    "React",
    "Vue",
    "Angular",
    "JavaScript",
    "TypeScript",
    "Tailwind",
    "Bootstrap",
    "Foundation",
    "Stimulus",
    "Hotwire",
    "Turbo",
    "Next.js",
    "Nuxt.js",
    "Svelte",
    "HTML/CSS"
  ],
  "Database" => [
    "PostgreSQL",
    "MySQL",
    "MongoDB",
    "Redis",
    "SQLite",
    "MariaDB",
    "Elasticsearch",
    "Cassandra",
    "DynamoDB",
    "Oracle"
  ],
  "Testing" => [
    "RSpec",
    "Jest",
    "Minitest",
    "Capybara",
    "Cypress",
    "Selenium",
    "Mocha",
    "Chai",
    "PyTest",
    "JUnit"
  ],
  "DevOps/Infrastructure" => [
    "Docker",
    "Kubernetes",
    "Jenkins",
    "CI/CD",
    "AWS",
    "AWS RDS",
    "AWS S3",
    "AWS SES",
    "AWS Lambda",
    "Azure",
    "Google Cloud",
    "Heroku",
    "Terraform",
    "Ansible",
    "GitHub Actions",
    "CircleCI"
  ],
  "API/Integration" => [
    "RESTful APIs",
    "GraphQL",
    "gRPC",
    "LLM API Integration",
    "OpenAI API",
    "Stripe API",
    "Twilio",
    "SendGrid",
    "Webhooks"
  ]
}

puts "Seeding technologies..."

technologies_data.each do |category, tech_names|
  tech_names.each do |name|
    Technology.find_or_create_by!(name: name) do |tech|
      tech.category = category
      puts "  Created: #{name} (#{category})"
    end
  end
end

puts "Technology seeding completed!"
puts "Total technologies: #{Technology.count}"
