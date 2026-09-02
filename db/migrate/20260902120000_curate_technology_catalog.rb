class CurateTechnologyCatalog < ActiveRecord::Migration[8.0]
  RETIRED_TECHNOLOGIES = [
    "Foundation",
    "Nuxt.js",
    "Svelte",
    "Cassandra",
    "Oracle",
    "Minitest",
    "Mocha",
    "Chai",
    "JUnit",
    "Ansible",
    "SendGrid",
    "MariaDB",
    "Flask",
    "Laravel",
    ".NET",
    "C#",
    "SQLite",
    "LLM API Integration",
    "OpenAI API"
  ].freeze

  TECHNOLOGIES_BY_CATEGORY = {
    "Backend" => [ "FastAPI", "Node.js", "Sidekiq" ],
    "Database" => [ "SQL" ],
    "Testing" => [ "FactoryBot", "Playwright" ],
    "DevOps/Infrastructure" => [ "AWS EC2", "GitLab CI/CD" ],
    "AI/LLM" => [ "LLM API", "RAG", "Vector Databases", "Agentic AI", "MCP", "Prompt Engineering" ],
    "Observability" => [ "AWS CloudWatch", "New Relic", "Honeybadger", "Sentry", "AppSignal", "Datadog", "PostHog" ],
    "Event/Messaging" => [ "Kafka", "RabbitMQ", "AWS SQS", "AWS SNS" ]
  }.freeze

  def up
    Technology.where(name: RETIRED_TECHNOLOGIES).find_each(&:destroy!)

    Company.where.not(known_tech_stack: [ nil, "" ]).find_each do |company|
      technologies = company.known_tech_stack.split(",").map(&:strip) - RETIRED_TECHNOLOGIES
      company.update_column(:known_tech_stack, technologies.join(", "))
    end

    TECHNOLOGIES_BY_CATEGORY.each do |category, names|
      names.each do |name|
        Technology.find_or_initialize_by(name: name).update!(category: category)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
