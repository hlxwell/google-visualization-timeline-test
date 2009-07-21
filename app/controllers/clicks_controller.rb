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

    max_points_to_display = 300
    mod_factor = 0

    # get some point from min date to max date
    whole_click_ids = Click.find(:all, :select => ['id'], :order => "duration").collect(&:id)
    if whole_click_ids.size > 100 and whole_click_ids.size > 0
      whole_mod_factor = (whole_click_ids.size/100).round
    end
    
    whole_final_result_ids = []
    if whole_mod_factor > 1
      whole_click_ids.each_with_index do |id,i|
        if i%whole_mod_factor == 0
           whole_final_result_ids.push(id)
        end
      end
    else
      whole_final_result_ids = whole_click_ids
    end
    
    ##############################################
    # get all id between the duration
    click_ids = Click.find(:all, :select => ['id'], :conditions => ['? < duration and duration < ?', start_date, end_date], :order => "duration").collect(&:id)

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

    # get final result
    @results = Click.find(whole_final_result_ids + final_result_ids)
    
    render :layout => false #, :text => @results.size
  end

end
