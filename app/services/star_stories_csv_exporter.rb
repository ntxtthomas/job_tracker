require "csv"

class StarStoriesCsvExporter
  def initialize(star_stories)
    @star_stories = star_stories
  end

  def generate
    CSV.generate(headers: true) do |csv|
      csv << headers

      @star_stories.each do |story|
        csv << [
          story.title,
          story.situation,
          story.task,
          story.action,
          story.result,
          story.skills&.join(", "),
          story.category&.titleize,
          story.outcome&.titleize,
          story.reflection
        ]
      end
    end
  end

  private

  def headers
    [
      "Title",
      "Situation",
      "Task",
      "Action",
      "Result",
      "Skills",
      "Category",
      "Outcome",
      "Notes"
    ]
  end
end
