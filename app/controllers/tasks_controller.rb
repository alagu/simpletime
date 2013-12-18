class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json

  before_filter :authenticate_user!

  def index
    @tasks = Task.order("date DESC, id ASC").all

    hours_hash = {}

    @tasks.each do |task|
      if hours_hash.has_key? task.date.to_s
        hours_hash[task.date.to_s] = hours_hash[task.date.to_s] + task.hours
      else
        hours_hash[task.date.to_s] = task.hours
      end
    end

    @hours_progress = {}

    hours_hash.each do |date, hours|
      if hours < current_user.pref_hours
        @hours_progress[date] = 'incomplete'
      else
        @hours_progress[date] = 'completed'
      end
    end

    @newtask = Task.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
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
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    @task.user = current_user

    respond_to do |format|
      if @task.save
        if params[:source] == "dashboard"
          redirect_path = "/dashboard"
        else
          redirect_path = @task
        end

        format.html { redirect_to redirect_path, notice: 'Task was successfully created.' }
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
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
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
    @task.destroy

    respond_to do |format|
      format.html { redirect_to "/dashboard" }
      format.json { head :no_content }
    end
  end
end
