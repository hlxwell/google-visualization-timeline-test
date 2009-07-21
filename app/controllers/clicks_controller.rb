class ClicksController < ApplicationController
  # GET /clicks
  # GET /clicks.xml
  def index
    @clicks = [] #Click.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clicks }
      format.json { render :json => @clicks.to_json }
    end
  end

  # GET /clicks/1
  # GET /clicks/1.xml
  def show
    @clicks = Click.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clicks }
    end
  end

  # GET /clicks/new
  # GET /clicks/new.xml
  def new
    @clicks = Click.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clicks }
    end
  end

  # GET /clicks/1/edit
  def edit
    @clicks = Click.find(params[:id])
  end

  # POST /clicks
  # POST /clicks.xml
  def create
    @clicks = Click.new(params[:click])

    respond_to do |format|
      if @clicks.save
        flash[:notice] = 'Clicks was successfully created.'
        format.html { redirect_to(@clicks) }
        format.xml  { render :xml => @clicks, :status => :created, :location => @clicks }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clicks.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clicks/1
  # PUT /clicks/1.xml
  def update
    @clicks = Click.find(params[:id])

    respond_to do |format|
      if @clicks.update_attributes(params[:click])
        flash[:notice] = 'Clicks was successfully updated.'
        format.html { redirect_to(@clicks) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clicks.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clicks/1
  # DELETE /clicks/1.xml
  def destroy
    @clicks = Click.find(params[:id])
    @clicks.destroy

    respond_to do |format|
      format.html { redirect_to(clicks_url) }
      format.xml  { head :ok }
    end
  end

  def get_range
    require 'time'
    end_date = Time.parse params["end_date"]
    start_date = Time.parse params["start_date"]

    days = (end_date - start_date)/(3600*24)
    max_points_to_display = 1000
    mod_factor = 0

    # get all id between the duration
    click_ids = Click.find(:all, :select => ['id'], :conditions => ['? < duration and duration < ?', start_date, end_date]).collect(&:id)

    # calculate the factor for MOD calculation
    if click_ids.size > max_points_to_display and click_ids.size > 0
      mod_factor = (click_ids.size/max_points_to_display).round
    end

logger.info "-=-=-=-=-= #{start_date.year}-#{start_date.month}-#{start_date.day}  --->  #{end_date.year}-#{end_date.month}-#{end_date.day}"
logger.info "-=-=-=-=-= click_ids.size: #{click_ids.size}  max_points_to_display:#{max_points_to_display}   mod_factor: #{mod_factor}"

    # get filtered ids
    final_result_ids = []
    if mod_factor > 1
      click_ids.each_with_index do |id,i|
        if i%mod_factor == 0
           final_result_ids.push(id)
        end
      end
    else
      final_result_ids = click_ids
    end

    # get final result
    @results = Click.find final_result_ids

    render :layout => false
  end

end
