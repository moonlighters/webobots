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
  map.resources :firmwares, :controller => 'firmwares', :except => :destroy, :collection => { :all => :get }
  map.firmware_version 'firmwares/:id/versions/:number', :controller => 'firmwares', :action => 'show_version', :conditions => {:method => :get}
  map.firmware_versions 'firmwares/:id/versions', :controller => 'firmwares', :action => 'index_versions', :conditions => {:method => :get}

  # matches
  map.resources :matches, :only => [:new, :create, :show, :index],
                          :collection => {:all => :get}, :member => {:play => :get}

  # rating
  map.with_options :controller => 'rating', :conditions => {:method => :get}, :path_prefix => 'rating' do |rating|
    rating.users_rating 'users', :action => 'show_users'
    rating.firmwares_rating 'firmwares', :action => 'show_firmwares'
  end

  # root
  map.root :controller => 'user_sessions', :action => 'new'
end
