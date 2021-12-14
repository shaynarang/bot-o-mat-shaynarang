# frozen_string_literal: true

class RobotsController < ApplicationController
  before_action :set_robot, only: %i[ show edit update destroy ]

  # GET /robots
  def index
    @robots = current_user.robots
    respond_to do |format|
      format.html { render :index }
      format.json { render :index }
    end
  end

  # GET /robots/1
  def show
    respond_to do |format|
      format.json { render :show }
    end
  end

  # GET /robots/new
  def new
    @robot = Robot.new
  end

  # GET /robots/1/edit
  def edit
  end

  # POST /robots or /robots.json
  def create
    @robot = Robot.new(robot_params)
    respond_to do |format|
      if @robot.save
        format.html { redirect_to robots_url, notice: 'Robot was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /robots/1
  def update
    respond_to do |format|
      if @robot.update(robot_params)
        # This allows task ids params to go through when all boxes are unchecked.
        @robot.attributes = {'task_ids' => []}.merge(robot_params || {}) if @robot.valid?
        format.html { redirect_to robots_url, notice: 'Robot was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.html { redirect_to :edit, error: @robot.errors.full_messages }
      end
    end
  end

  # DELETE /robots/1
  def destroy
    @robot.destroy
    respond_to do |format|
      format.html { redirect_to robots_url, notice: 'Robot was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_robot
    @robot = Robot.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def robot_params
    params.require(:robot).permit(:name, :kind, :user_id, :task_ids => [])
  end
end
