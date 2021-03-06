class NodesController < ApplicationController
  
  include Seek::IndexPager

  include Seek::AssetsCommon

  before_filter :find_assets, :only => [ :index ]
  before_filter :find_and_authorize_requested_item, :except => [ :index, :new, :create, :request_resource,:preview, :test_asset_url, :update_annotations_ajax]
  before_filter :find_display_asset, :only=>[:show, :download]

  include Seek::Publishing::PublishingCommon

  include Seek::BreadCrumbs
  include Seek::Doi::Minting

  include Seek::IsaGraphExtensions

  def new_version
    if handle_upload_data(true)
      comments=params[:revision_comments]


      respond_to do |format|
        if @node.save_as_new_version(comments)

          flash[:notice]="New version uploaded - now on version #{@node.version}"
        else
          flash[:error]="Unable to save new version"          
        end
        format.html {redirect_to @node }
      end
    else
      flash[:error]=flash.now[:error] 
      redirect_to @node
    end
    
  end

  # PUT /Nodes/1
  def update
    update_annotations(params[:tag_list], @node) if params.key?(:tag_list)
    update_sharing_policies @node
    update_relationships(@node,params)

    respond_to do |format|
      if @node.update_attributes(node_params)
        flash[:notice] = "#{t('Node')} metadata was successfully updated."
        format.html { redirect_to node_path(@node) }
        format.json { render json: @node }
      else
        format.html { render action: 'edit' }
        format.json { render json: json_api_errors(@node), status: :unprocessable_entity }
      end
    end
  end

  private

  def node_params
    params.require(:node).permit(:title, :description, { project_ids: [] }, :license, :other_creators,
                                { special_auth_codes_attributes: [:code, :expiration_date, :id, :_destroy] },
                                { creator_ids: [] }, { assay_assets_attributes: [:assay_id] }, { scales: [] },
                                { publication_ids: [] })
  end

  alias_method :asset_params, :node_params

end
