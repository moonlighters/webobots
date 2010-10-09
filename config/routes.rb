ActionController::Routing::Routes.draw do |map|
  # user_sessions
  map.with_options :controller => 'user_sessions' do |sessions|
    sessions.login   'login',  :action => 'new',     :conditions => {:method => :get}
    sessions.connect 'login',  :action => 'create',  :conditions => {:method => :post}
    sessions.logout  'logout', :action => 'destroy'
  end

  # users
  map.resource :account, :controller => 'users', :only => [:show, :edit, :update]
  map.resources :users, :controller => 'users', :only => [:show, :index]
  map.with_options :controller => 'users' do |users|
    users.signup  'signup', :action => 'new', :conditions => {:method => :get}
    users.connect 'signup', :action => 'create', :conditions => {:method => :post}
  end

  # firmwares
  map.resources :firmwares, :controller => 'firmwares', :except => :destroy, :collection => { :all => :get }, :member => {:code => :get}
  map.firmware_version 'firmwares/:id/versions/:number', :controller => 'firmwares', :action => 'show_version', :conditions => {:method => :get}
  map.firmware_versions 'firmwares/:id/versions', :controller => 'firmwares', :action => 'index_versions', :conditions => {:method => :get}

  # matches
  map.resources :matches, :only => [:new, :create, :show, :index],
                          :collection => {:all => :get}, :member => {:play => :get}

  # rating
  map.resource :rating, :controller => 'rating',
    :only => [], :member => {:users => :get, :firmwares => :get}

  # admin
  map.resource :admin, :controller => 'admin', :only => :show, :member => {:stats => :get} do |admin|
    admin.resources :invites, :only => [:index, :create, :destroy]
  end

  # comments
  map.resources :comments, :only => [:index, :create, :destroy], :collection => { :all => :get }

  # doc
  map.with_options :controller => 'doc', :path_prefix => 'doc' do |doc|
    %w{ waffle_language runtime_library }.each do |action|
      doc.send( "#{action}_doc", action, :action => action, :conditions => {:method => :get} )
    end
  end

  # quick tour
  map.tour 'tour', :controller => 'welcome', :action => 'tour'

  # tutorial
  map.resource :tutorial, :controller => 'tutorial', :only => :show

  # root
  map.root :controller => 'welcome', :action => 'root'
end
