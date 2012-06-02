class DiscussionPostsController < ApplicationController
  # GET /discussion_posts
  # GET /discussion_posts.xml

  layout 'default'

  def index
    grab_posts
    @new_post = DiscussionPost.new(:web => @web, :author => @author)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @discussion_posts }
    end
  end

  # GET /discussion_posts/1
  # GET /discussion_posts/1.xml
  def show
    @discussion_post = DiscussionPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @discussion_post }
    end
  end

  # GET /discussion_posts/1/edit
  def edit
    @discussion_post = DiscussionPost.find(params[:id])
  end

  # POST /discussion_posts
  # POST /discussion_posts.xml
  def create
    @discussion_post = DiscussionPost.new(params[:discussion_post])

    # Since we're using this in two places right now, should really factor this out into
    # a method in the action controller that we use here and wherever else we need it...
    author_name = @discussion_post.author.purify
    author_name = 'AnonymousCoward' if author_name =~ /^\s*$/
    cookies['author'] = { :value => author_name.dup.as_bytes, :expires => Time.now + 30.years }

    respond_to do |format|
      if @discussion_post.save
        query_hash = {:web => @discussion_post.web}
        format.html { redirect_to discussion_posts_url(query_hash), :notice => 'DiscussionPost was successfully created.' }
        format.xml  { render :xml => @discussion_post, :status => :created, :location => @discussion_post }
      else
        grab_posts
        format.html { render :action => "index" }
        format.xml  { render :xml => @discussion_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /discussion_posts/1
  # PUT /discussion_posts/1.xml
  def update
    @discussion_post = DiscussionPost.find(params[:id])

    respond_to do |format|
      if @discussion_post.update_attributes(params[:discussion_post])
        query_hash = {:web => @discussion_post.web}
        format.html { redirect_to discussion_posts_url(query_hash), :notice => 'DiscussionPost was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @discussion_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /discussion_posts/1
  # DELETE /discussion_posts/1.xml
  def destroy
    @discussion_post = DiscussionPost.find(params[:id])
    @discussion_post.destroy

    respond_to do |format|
      format.html { redirect_to(discussion_posts_url) }
      format.xml  { head :ok }
    end
  end

  protected

  # Grabs web specific posts if @web is accessible. Else all posts.
  def grab_posts
    @discussion_posts = if @web
      @web.discussion_posts
    else
      DiscussionPost.all
    end
    @discussion_posts = @discussion_posts.paginate :page => params[:page], :per_page => 12
  end

end
