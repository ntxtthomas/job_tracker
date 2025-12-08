class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: %i[ show edit update destroy ]

  # GET /opportunities or /opportunities.json
  def index
    @opportunities = Opportunity.includes(:company)

    # Handle sorting
    if params[:sort].present?
      sort_column = params[:sort]
      sort_direction = params[:direction] == "desc" ? "desc" : "asc"

      # Validate sort column to prevent SQL injection
      allowed_columns = %w[position_title application_date status remote tech_stack created_at salary_range chatgpt_match jobright_match linkedin_match]
      if allowed_columns.include?(sort_column)
        @opportunities = @opportunities.order("#{sort_column} #{sort_direction}")
      elsif sort_column == "company"
        @opportunities = @opportunities.joins(:company).order("companies.name #{sort_direction}")
      end
    else
      @opportunities = @opportunities.order(:application_date).reverse_order
    end

    respond_to do |format|
      format.html
      format.csv do
        csv_data = OpportunitiesCsvExporter.new(@opportunities).generate
        send_data csv_data, filename: "opportunities_#{Date.today}.csv", type: 'text/csv'
      end
    end
  end

  # GET /opportunities/1 or /opportunities/1.json
  def show
    @interactions = @opportunity.company.interactions.includes(:contact) if @opportunity.company
  end

  # GET /opportunities/new
  def new
    @opportunity = Opportunity.new
    @companies = Company.all.order(:name)
  end

  # GET /opportunities/1/edit
  def edit
    @companies = Company.all.order(:name)
  end

  # POST /opportunities or /opportunities.json
  def create
    @opportunity = Opportunity.new(opportunity_params)

    respond_to do |format|
      if @opportunity.save
        format.html { redirect_to @opportunity, notice: "Opportunity was successfully created." }
        format.json { render :show, status: :created, location: @opportunity }
      else
        @companies = Company.all.order(:name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opportunities/1 or /opportunities/1.json
  def update
    respond_to do |format|
      if @opportunity.update(opportunity_params)
        format.html { redirect_to @opportunity, notice: "Opportunity was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @opportunity }
      else
        @companies = Company.all.order(:name)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1 or /opportunities/1.json
  def destroy
    @opportunity.destroy!

    respond_to do |format|
      format.html { redirect_to opportunities_path, notice: "Opportunity was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opportunity
      @opportunity = Opportunity.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def opportunity_params
      params.expect(opportunity: [ :company_id, :position_title, :application_date, :status, :notes, :remote, :tech_stack, :source, :salary_range, :listing_url, :chatgpt_match, :jobright_match, :linkedin_match ])
    end
end
