class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json

  before_filter :authenticate_user!

  def index
    tasks_query = Task.where(:user_id => current_user)

    if params.has_key? :from
      tasks_query = tasks_query.where("date >= ?", Date.parse(params[:from]))
      @datemin = params[:from]
    end

    if params.has_key? :to
      tasks_query = tasks_query.where("date <= ?", Date.parse(params[:to]))
      @datemax = params[:to]
    end

    @tasks = tasks_query.order("date DESC, id ASC").all

    if @tasks.length > 0
      @datemin ||= @tasks.last.date.to_s
      @datemax ||= @tasks.first.date.to_s
    end

    @hours_hash = {}

    @tasks.each do |task|
      if @hours_hash.has_key? task.date.to_s
        @hours_hash[task.date.to_s] = @hours_hash[task.date.to_s] + task.hours
      else
        @hours_hash[task.date.to_s] = task.hours
      end
    end

    @hours_progress = {}

    @hours_hash.each do |date, hours|
      if hours < current_user.pref_hours
        @hours_progress[date] = 'incomplete'
      else
        @hours_progress[date] = 'completed'
      end
    end

    @newtask = Task.new

    respond_to do |format|
      if params[:view] == "export"
        format.html { render :layout => false, :template => "tasks/export" }
      else
        format.html # index.html.erb
      end
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.user != current_user
        format.html { redirect_to "/dashboard", :alert => "You are not authorized to see a task which is not yours" }  
        format.json { render json: {:message => "You are not authorized to see a task which is not yours"}}
      else
        format.html # show.html.erb
        format.json { render json: @task }
      end
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    if @task.user != current_user
      redirect_to "/dashboard", :alert => "You are not authorized to edit a task which is not yours"
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to "/dashboard", notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task]) and @task.user == current_user
        format.html { redirect_to "/dashboard", notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    if @task.user == current_user
      @task.destroy
    end

    respond_to do |format|
      format.html { redirect_to "/dashboard" }
      format.json { head :no_content }
    end
  end
end
