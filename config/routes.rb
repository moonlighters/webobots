ActionController::Routing::Routes.draw do |map|
  map.login   'login', :controller => 'user_sessions', :action => 'new', :conditions => {:method => :get}
  map.connect 'login', :controller => 'user_sessions', :action => 'create', :conditions => {:method => :post}
  map.logout  'logout', :controller => 'user_sessions', :action => 'destroy'

  map.resource :account, :controller => 'users', :except => :destroy
  map.resources :users, :controller => 'users', :only => [:show]
  map.signup 'signup', :controller => 'users', :action => 'new', :conditions => {:method => :get}
  map.connect 'signup', :controller => 'users', :action => 'create', :conditions => {:method => :post}

  map.resources :firmwares, :controller => 'firmwares', :except => :destroy
  map.show_firmware_version "firmwares/:id/versions/:number", :controller => "firmwares",
                                                              :action => "show_version",
                                                              :conditions => {:method => :get}

  map.resources :matches, :only => [:new, :create, :show]

  map.users_rating 'rating/users', :controller => 'rating', :action => 'show_users', :conditions => {:method => :get}
  map.firmwares_rating 'rating/firmwares', :controller => 'rating', :action => 'show_firmwares', :conditions => {:method => :get}

  map.root :controller => 'user_sessions', :action => 'new'
end
