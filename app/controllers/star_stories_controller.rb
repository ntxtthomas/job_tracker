class StarStoriesController < ApplicationController
  before_action :set_star_story, only: [ :show, :edit, :update, :destroy ]

  def index
    @star_stories = StarStory.all.order(created_at: :desc)
  end

  def new
    @star_story = StarStory.new
  end

  def create
    @star_story = StarStory.new(star_story_params)

    if @star_story.save
      redirect_to @star_story, notice: "STAR story was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @star_story.update(star_story_params)
      redirect_to @star_story, notice: "STAR story was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @star_story.destroy
    redirect_to star_stories_url, notice: "STAR story was successfully deleted."
  end

  def show
  end

  private

  def set_star_story
    @star_story = StarStory.find(params[:id])
  end

  def star_story_params
    params.require(:star_story).permit(
      :situation, :task, :action, :result, :category, :outcome,
      :strength, :keywords, :reflection, skills: [], opportunity_ids: []
    )
  end
end
