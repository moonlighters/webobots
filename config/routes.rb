ActionController::Routing::Routes.draw do |map|
  map.login   'login', :controller => 'user_sessions', :action => 'new', :conditions => {:method => :get}
  map.connect 'login', :controller => 'user_sessions', :action => 'create', :conditions => {:method => :post}
  map.logout  'logout', :controller => 'user_sessions', :action => 'destroy'

  map.resource :account, :controller => 'users', :except => :destroy
  map.resources :users, :controller => 'users', :only => [:show]
  map.signup 'signup', :controller => 'users', :action => 'new', :conditions => {:method => :get}
  map.connect 'signup', :controller => 'users', :action => 'create', :conditions => {:method => :post}

  map.root :controller => 'user_sessions', :action => 'new'
end
