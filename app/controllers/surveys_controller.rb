class SurveysController < ApplicationController
  before_action :set_survey,
                only: %i[
                  show
                  edit
                  update
                  destroy
                  download_file
                  download_payload
                ]
  before_action :authenticate_user!, except: :api

  # GET /surveys or /surveys.json
  def index
    @surveys = Survey.where(user_id: current_user.id).page(params[:page])
  end

  # GET /surveys/1 or /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys or /surveys.json
  def create
    @survey = Survey.new(survey_params)
    @survey.user_id = current_user.id
    @survey.file = params[:survey][:file].read
    @survey.parse_file(params[:survey][:file].tempfile.to_path.to_s)

    respond_to do |format|
      if @survey.save
        format.html do
          redirect_to survey_url(@survey),
                      notice: "Survey was successfully created."
        end
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @survey.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /surveys/1 or /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        if params[:survey][:file]
          @survey.file = params[:survey][:file].read
          @survey.parse_file(params[:survey][:file].tempfile.to_path.to_s)
          @survey.save
        end

        format.html do
          redirect_to survey_url(@survey),
                      notice: "Survey was successfully updated."
        end
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @survey.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /surveys/1 or /surveys/1.json
  def destroy
    @survey.destroy

    respond_to do |format|
      format.html do
        redirect_to surveys_url, notice: "Survey was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  def download_file
    send_data(@survey.file, filename: "#{@survey.id}.xlsx")
  end

  def download_payload
    send_data(@survey.payload, filename: "#{@survey.id}.json")
  end

  def api
    @survey = Survey.find_by(slug: params[:slug])
    render json: { name: @survey.name, payloads: @survey.payloads }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey.find(params[:id])
    redirect_to surveys_url if @survey.user_id != current_user.id
  end

  # Only allow a list of trusted parameters through.
  def survey_params
    params.require(:survey).permit(:user_id, :name, :slug, :payload, :file)
  end
end
