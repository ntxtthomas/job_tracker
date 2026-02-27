class InterviewSessionsController < ApplicationController
  before_action :set_interview_session, only: [ :show, :edit, :update, :destroy ]

  def index
    @interview_sessions = InterviewSession.all.includes(:opportunity).order(date: :desc)
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

  def interview_session_params
    params.require(:interview_session).permit(
      :opportunity_id, :stage, :date, :confidence_score, :clarity_score,
      :questions_asked, :weak_areas, :strong_areas, :follow_up, :overall_signal
    )
  end
end
