ActionController::Routing::Routes.draw do |map|
  # user_sessions
  map.with_options :controller => 'user_sessions' do |sessions|
    sessions.login   'login',  :action => 'new',     :conditions => {:method => :get}
    sessions.connect 'login',  :action => 'create',  :conditions => {:method => :post}
    sessions.logout  'logout', :action => 'destroy'
  end

  # users
  map.resource :account, :controller => 'users', :only => [:show, :edit, :update]
  map.resources :users, :only => [:index, :show], :member => {:firmwares => :get} do |user|

    user.matches 'matches', :controller => 'matches', :action => 'all_for_user', :conditions => {:method => :get}

    # firmwares
    user.resources :firmwares, :except => :destroy, :member => {:code => :get} do |fw|
      fw.matches 'matches', :controller => 'matches', :action => 'all_for_firmware', :conditions => {:method => :get}
    end
    user.firmware_version 'firmwares/:id/versions/:number', :controller => 'firmwares', :action => 'show_version', :conditions => {:method => :get}
    user.firmware_versions 'firmwares/:id/versions', :controller => 'firmwares', :action => 'index_versions', :conditions => {:method => :get}

  end
  map.with_options :controller => 'users' do |users|
    users.signup  'signup', :action => 'new', :conditions => {:method => :get}
    users.connect 'signup', :action => 'create', :conditions => {:method => :post}
  end

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
  map.resource :doc, :controller => 'doc', :only => [],
               :member => {:waffle_language => :get, :runtime_library => :get, :tour => :get, :tutorial => :get}

  # root
  map.root :controller => 'welcome', :action => 'root'
end
