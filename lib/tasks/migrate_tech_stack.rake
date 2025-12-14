namespace :opportunities do
  desc "Migrate tech_stack strings to structured technologies"
  task migrate_tech_stack: :environment do
    puts "Starting tech_stack migration..."
    
    # Mapping of common variations to Technology names
    tech_mappings = {
      "ruby on rails" => "Ruby on Rails",
      "rails" => "Ruby on Rails",
      "ror" => "Ruby on Rails",
      "react" => "React",
      "reactjs" => "React",
      "react.js" => "React",
      "vue" => "Vue",
      "vuejs" => "Vue",
      "vue.js" => "Vue",
      "python" => "Python",
      "graphql" => "GraphQL",
      "postgres" => "PostgreSQL",
      "postgresql" => "PostgreSQL",
      "mysql" => "MySQL",
      "mongodb" => "MongoDB",
      "mongo" => "MongoDB",
      "node" => "Node.js",
      "nodejs" => "Node.js",
      "node.js" => "Node.js",
      "typescript" => "TypeScript",
      "javascript" => "JavaScript",
      "js" => "JavaScript",
      "docker" => "Docker",
      "kubernetes" => "Kubernetes",
      "k8s" => "Kubernetes",
      "aws" => "AWS",
      "tailwind" => "Tailwind",
      "bootstrap" => "Bootstrap",
      "angular" => "Angular",
      "next.js" => "Next.js",
      "nextjs" => "Next.js"
    }
    
    migrated_count = 0
    skipped_count = 0
    not_found = []
    
    Opportunity.find_each.with_index do |opportunity, index|
      next if opportunity.tech_stack.blank? || opportunity.tech_stack.downcase.in?(["n/a", "na", "none"])
      
      # Split by comma or semicolon and clean up
      tech_names = opportunity.tech_stack.split(/[,;]/).map(&:strip).reject(&:blank?)
      
      tech_names.each do |tech_name|
        # Normalize the name
        normalized = tech_name.downcase.strip
        canonical_name = tech_mappings[normalized] || tech_name.titleize
        
        # Find the technology
        tech = Technology.find_by("LOWER(name) = ?", canonical_name.downcase)
        
        if tech
          # Create the association if it doesn't exist
          unless opportunity.technologies.include?(tech)
            opportunity.technologies << tech
            puts "  ID #{opportunity.id}: Added '#{tech.name}'"
          end
        else
          # Add to other_tech_stack for manual review
          unless not_found.include?(tech_name)
            not_found << tech_name
          end
          
          # Append to other_tech_stack field
          if opportunity.other_tech_stack.present?
            opportunity.other_tech_stack += ", #{tech_name}" unless opportunity.other_tech_stack.include?(tech_name)
          else
            opportunity.other_tech_stack = tech_name
          end
          opportunity.save
          puts "  ID #{opportunity.id}: '#{tech_name}' not found - added to other_tech_stack"
        end
      end
      
      migrated_count += 1
      
      print "." if (index + 1) % 10 == 0
    end
    
    puts "\n\nMigration completed!"
    puts "Migrated: #{migrated_count} opportunities"
    puts "Technologies not found (added to other_tech_stack): #{not_found.uniq.join(', ')}" if not_found.any?
    puts "\nNote: Review opportunities with other_tech_stack and create missing technologies if needed."
  end
end
