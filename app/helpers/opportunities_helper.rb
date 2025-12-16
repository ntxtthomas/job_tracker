module OpportunitiesHelper
  def technology_badges(opportunity, limit: nil)
    technologies = opportunity.technologies.order(:category, :name)
    technologies = technologies.limit(limit) if limit

    content_tag(:div, class: "tech-badges", style: "display: flex; flex-wrap: wrap; gap: 5px;") do
      badges = technologies.map do |tech|
        content_tag(:span, tech.name,
          style: "background-color: #e7f1ff; color: #0056b3; padding: 3px 8px; border-radius: 3px; font-size: 13px; white-space: nowrap;")
      end

      if limit && opportunity.technologies.count > limit
        badges << content_tag(:span, "+#{opportunity.technologies.count - limit}",
          style: "color: #666; font-size: 11px; padding: 3px 5px;")
      end

      safe_join(badges)
    end
  end

  def technologies_by_category(opportunity)
    content_tag(:div, class: "technologies-by-category") do
      Technology::CATEGORIES.map do |category|
        category_techs = opportunity.technologies.where(category: category).order(:name)
        next if category_techs.empty?

        content_tag(:div, style: "margin-bottom: 10px;") do
          category_header = content_tag(:strong, "#{category}:",
            style: "font-size: 14px; color: var(--text-secondary, #666); display: block; margin-bottom: 3px;")

          badges = content_tag(:div, style: "display: flex; flex-wrap: wrap; gap: 5px;") do
            safe_join(category_techs.map { |tech|
              content_tag(:span, tech.name,
                style: "background-color: #e7f1ff; color: #0056b3; padding: 3px 8px; border-radius: 3px; font-size: 13px;")
            })
          end

          category_header + badges
        end
      end.compact.join.html_safe
    end
  end
end
