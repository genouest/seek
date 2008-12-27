class InstitutionsController < ApplicationController
  
  before_filter :login_required
  before_filter :is_user_admin_auth, :except=>[:index, :show]
  
  # GET /institutions
  # GET /institutions.xml
  def index
    @institutions = Institution.find(:all, :order=>:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @institutions }
    end
  end

  # GET /institutions/1
  # GET /institutions/1.xml
  def show
    @institution = Institution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @institution }
    end
  end

  # GET /institutions/new
  # GET /institutions/new.xml
  def new
    @institution = Institution.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @institution }
    end
  end

  # GET /institutions/1/edit
  def edit
    @institution = Institution.find(params[:id])
  end

  # POST /institutions
  # POST /institutions.xml
  def create
    @institution = Institution.new(params[:institution])

    respond_to do |format|
      if @institution.save
        flash[:notice] = 'Institution was successfully created.'
        format.html { redirect_to(@institution) }
        format.xml  { render :xml => @institution, :status => :created, :location => @institution }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /institutions/1
  # PUT /institutions/1.xml
  def update
    @institution = Institution.find(params[:id])

    # extra check required to see if any avatar was actually selected (or it remains to be the default one)
    avatar_id = params[:institution].delete(:avatar_id).to_i
    @institution.avatar_id = ((avatar_id.kind_of?(Fixnum) && avatar_id > 0) ? avatar_id : nil)

    respond_to do |format|
      if @institution.update_attributes(params[:institution])
        flash[:notice] = 'Institution was successfully updated.'
        format.html { redirect_to(@institution) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /institutions/1
  # DELETE /institutions/1.xml
  def destroy
    @institution = Institution.find(params[:id])
    @institution.destroy

    respond_to do |format|
      format.html { redirect_to(institutions_url) }
      format.xml  { head :ok }
    end
  end
end
