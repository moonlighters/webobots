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

  map.with_options :controller => "matches", :path_prefix => "match" do |m|
    m.match_choose_yours "choose_yours/enemy/:enemy_id", :action => 'choose_yours', :conditions => {:method => :get}
    m.match "show/:id", :action => 'show', :conditions => {:method => :get}
    m.create_match "new", :action => 'create', :conditions => {:method => :post}
  end

  map.root :controller => 'user_sessions', :action => 'new'
end
