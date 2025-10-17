class InteractionsController < ApplicationController
  before_action :set_interaction, only: %i[ show edit update destroy ]

  # GET /interactions or /interactions.json
  def index
    @interactions = Interaction.includes(:contact, :company)

    # Handle sorting
    if params[:sort].present?
      sort_column = params[:sort]
      sort_direction = params[:direction] == "desc" ? "desc" : "asc"

      # Validate sort column to prevent SQL injection
      allowed_columns = %w[category status follow_up_date created_at]
      if allowed_columns.include?(sort_column)
        @interactions = @interactions.order("#{sort_column} #{sort_direction}")
      elsif sort_column == "contact"
        @interactions = @interactions.joins(:contact).order("contacts.name #{sort_direction}")
      elsif sort_column == "company"
        @interactions = @interactions.joins(:company).order("companies.name #{sort_direction}")
      end
    else
      @interactions = @interactions.order(:follow_up_date).reverse_order
    end
  end

  # GET /interactions/1 or /interactions/1.json
  def show
  end

  # GET /interactions/new
  def new
    @interaction = Interaction.new
    # Pre-fill company if coming from an opportunity
    @interaction.company_id = params[:company_id] if params[:company_id]
    @companies = Company.all.order(:name)
    @contacts = Contact.all.order(:name)
  end

  # GET /interactions/1/edit
  def edit
    @companies = Company.all.order(:name)
    @contacts = Contact.all.order(:name)
  end

  # POST /interactions or /interactions.json
  def create
    @interaction = Interaction.new(interaction_params)

    respond_to do |format|
      if @interaction.save
        format.html { redirect_to @interaction, notice: "Interaction was successfully created." }
        format.json { render :show, status: :created, location: @interaction }
      else
        @companies = Company.all.order(:name)
        @contacts = Contact.all.order(:name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interactions/1 or /interactions/1.json
  def update
    respond_to do |format|
      if @interaction.update(interaction_params)
        format.html { redirect_to @interaction, notice: "Interaction was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @interaction }
      else
        @companies = Company.all.order(:name)
        @contacts = Contact.all.order(:name)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interactions/1 or /interactions/1.json
  def destroy
    @interaction.destroy!

    respond_to do |format|
      format.html { redirect_to interactions_path, notice: "Interaction was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interaction
      @interaction = Interaction.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def interaction_params
      params.expect(interaction: [ :contact_id, :company_id, :category, :note, :follow_up_date, :status ])
    end
end
