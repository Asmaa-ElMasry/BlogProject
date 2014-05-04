class PostsController < ApplicationController
  before_action :set_post, only: [ :edit, :update, :destroy]
  before_action :set_post_comm , only: [:show]
  before_filter :authenticate_user!
  before_filter :require_permission, only: [:edit , :update , :destroy ]
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.page(params[:page]).per_page(2)

    #@posts =Kaminari.paginate_array(body).page(params[:page]).per(10)
    #@posts =Post.order(:title).page params[:page]
    #@posts = Post.paginate ( :page => params[:page], :per_page => 2,:order => 'created_at DESC' )
    #@posts = Post.paginate(:page => params[:page], :per_page => 2, :order => 'published_at DESC')

  end
  def require_permission
    if current_user != Post.find(params[:id]).user
      redirect_to :controller=> 'posts' , :action => 'index'
      #Or do something else here
    end
  end
  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    if user_signed_in?
      @post = Post.new(post_params)
      @post.user = current_user
      respond_to do |format|
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :controller=> 'posts' , :action => 'index'
     end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
    def set_post_comm
      #@post = Post.includes(:Comment).where('Comment.report < ? AND Post.id = ?',10,params[:id]) 
      @post = Post.find(params[:id])
      @posts = Comment.all.where('comments.report < ? AND post_id = ?',10,params[:id])
      @comm = Comment.where('post_id = ? AND report >= ?',params[:id],10).select(:user_id).uniq
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :user_id)
    end
end
