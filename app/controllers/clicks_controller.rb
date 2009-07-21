class ClicksController < ApplicationController
  # GET /clicks
  # GET /clicks.xml
  def index
    max_date = Click.maximum('duration')
    min_date = Click.minimum('duration')

    ###
    # This is a very important things we got to take attention.
    # new Date(year, month, day) # month is from 0 - 11
    @dateline_start = "new Date(#{min_date.year},#{min_date.month - 1},#{min_date.day})"
    @dateline_end = "new Date(#{max_date.year},#{max_date.month - 1},#{max_date.day})"

    # @clicks = [] Click.all

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
    start_date = Time.parse params["start_date"]
    end_date = Time.parse params["end_date"]
    @results = Click.find(get_result_ids(start_date, end_date, 300, false) + get_result_ids(start_date, end_date, 100, true))
    render :layout => false
  end

  private
  def get_result_ids(start_date, end_date, max_points_to_display = 300, is_load_outside_points = false)
    mod_factor = 0

    if is_load_outside_points
      # get some points out of the range between start and end date. 
      click_ids = Click.find(:all, :select => ['id'], :conditions => ['? > duration or duration > ?',  start_date, end_date], :order => "duration").collect(&:id)
    else
      # get all ids inside the range
      click_ids = Click.find(:all, :select => ['id'], :conditions => ['? < duration and duration < ?', start_date, end_date], :order => "duration").collect(&:id)
    end
    
    # calculate the factor for MOD calculation
    if click_ids.size > max_points_to_display and click_ids.size > 0
      mod_factor = (click_ids.size/max_points_to_display).round
    end

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

    final_result_ids
  end
end
