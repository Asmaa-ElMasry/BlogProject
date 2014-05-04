class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :report]
  before_filter :authenticate_user!
  before_filter :require_permission, only: [:edit , :update , :destroy ]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.where("report < 10")
    @user_name = @comment.user.name
  end
  def require_permission
    if current_user != Comment.find(params[:id]).user
      redirect_to :controller=> 'posts' , :action => 'index'
      #Or do something else here
    end
  end
  # GET /comments/1
  # GET /comments/1.json
  def show
  end
  def report
    #@comment.update_attributes(:report => @comment.report+1)
    @comment.report = @comment.report + 1
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_url(@comment.post), notice: 'Comment was successfully reported.' }
        format.json { redirect_to post_url(@comment.post), notice: 'Comment was successfully reported.' }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
   
  end
  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit

  end

  # POST /comments
  # POST /comments.json
  def create

    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.report = 0
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_url(@comment.post), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      #@comment.report = params[:report] + 1
      if @comment.update(comment_params)
        format.html { redirect_to post_url(@comment.post), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    id=@comment.post_id
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_url(id),notice: 'Comment has been deleted successfully' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comment, :post_id)
    end
end
