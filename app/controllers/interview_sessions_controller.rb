class InterviewSessionsController < ApplicationController
  before_action :set_interview_session, only: [ :show, :edit, :update, :destroy ]
  before_action :load_form_collections, only: [ :new, :create, :edit, :update ]

  def index
    @interview_sessions = InterviewSession.includes(opportunity: :company, contact: :company)

    if params[:sort].present?
      sort_column = params[:sort]
      sort_direction = params[:direction] == "desc" ? "desc" : "asc"
      allowed_columns = %w[stage scheduled_at status overall_signal confidence_score duration_minutes format]

      if allowed_columns.include?(sort_column)
        @interview_sessions = @interview_sessions.order("#{sort_column} #{sort_direction}")
      elsif sort_column == "company"
        @interview_sessions = @interview_sessions.joins(opportunity: :company).order("companies.name #{sort_direction}")
      elsif sort_column == "opportunity"
        @interview_sessions = @interview_sessions.joins(:opportunity).order("opportunities.position_title #{sort_direction}")
      elsif sort_column == "contact"
        @interview_sessions = @interview_sessions.left_joins(:contact).order("contacts.name #{sort_direction} NULLS LAST")
      else
        @interview_sessions = @interview_sessions.order(scheduled_at: :desc)
      end
    else
      @interview_sessions = @interview_sessions.order(scheduled_at: :desc)
    end
  end

  def show
  end

  def new
    @interview_session = InterviewSession.new
  end

  def create
    @interview_session = InterviewSession.new(interview_session_params)

    if @interview_session.save
      redirect_to @interview_session, notice: "Interview session was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @interview_session.update(interview_session_params)
      redirect_to @interview_session, notice: "Interview session was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @interview_session.destroy
    redirect_to interview_sessions_url, notice: "Interview session was successfully deleted."
  end

  private

  def set_interview_session
    @interview_session = InterviewSession.find(params[:id])
  end

  def load_form_collections
    @companies = Company.order(:name)
    @opportunities = Opportunity.includes(:company).references(:company).order("companies.name ASC, opportunities.position_title ASC")
    @contacts = Contact.includes(:company).references(:company).order("companies.name ASC, contacts.name ASC")

    @opportunity_select_options = @opportunities.map do |opportunity|
      [ "#{opportunity.company.name} — #{opportunity.position_title}", opportunity.id ]
    end

    @contact_select_options = @contacts.map do |contact|
      [ "#{contact.name} (#{contact.company.name})", contact.id ]
    end

    @opportunity_scope_data = @opportunities.map do |opportunity|
      {
        id: opportunity.id,
        company_id: opportunity.company_id,
        label: "#{opportunity.company.name} — #{opportunity.position_title}"
      }
    end

    @contact_scope_data = @contacts.map do |contact|
      {
        id: contact.id,
        company_id: contact.company_id,
        label: "#{contact.name} (#{contact.company.name})"
      }
    end
  end

  def interview_session_params
    params.require(:interview_session).permit(
      :opportunity_id,
      :contact_id,
      :stage,
      :scheduled_at,
      :duration_minutes,
      :format,
      :status,
      :overall_signal,
      :confidence_score,
      :notes,
      :questions_they_asked,
      :questions_i_asked,
      :follow_ups,
      :next_steps
    )
  end
end
