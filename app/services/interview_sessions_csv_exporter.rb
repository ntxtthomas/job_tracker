require "csv"

class InterviewSessionsCsvExporter
  def initialize(interview_sessions)
    @interview_sessions = interview_sessions
  end

  def generate
    CSV.generate(headers: true, write_headers: true, force_quotes: true) do |csv|
      csv << headers

      @interview_sessions.each do |session|
        csv << [
          sanitize_for_excel(session.opportunity.company.name),
          sanitize_for_excel(session.opportunity.position_title),
          sanitize_for_excel(session.contact&.name),
          sanitize_for_excel(session.stage&.humanize),
          sanitize_for_excel(session.scheduled_at&.strftime("%Y-%m-%d %H:%M")),
          sanitize_for_excel(session.duration_minutes),
          sanitize_for_excel(session.format&.humanize),
          sanitize_for_excel(session.status&.humanize),
          sanitize_for_excel(session.overall_signal&.humanize),
          sanitize_for_excel(session.confidence_score),
          sanitize_for_excel(session.questions_they_asked),
          sanitize_for_excel(session.questions_i_asked),
          sanitize_for_excel(session.follow_ups),
          sanitize_for_excel(session.next_steps)
        ]
      end
    end
  end

  private

  def sanitize_for_excel(value)
    return "" if value.nil? || value.to_s.strip.empty?

    string_value = value.to_s
    string_value.match?(/^[-=+@]/) ? "'#{string_value}" : string_value
  end

  def headers
    [
      "Company",
      "Opportunity",
      "Contact",
      "Stage",
      "Scheduled At",
      "Duration (minutes)",
      "Format",
      "Status",
      "Overall Signal",
      "Confidence Score",
      "Questions They Asked",
      "Questions I Asked",
      "Follow Ups",
      "Next Steps"
    ]
  end
end
