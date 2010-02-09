ActionController::Routing::Routes.draw do |map|
  map.namespace :documentation do |doc|
    doc.resources :features
    doc.resource :features_change, :only => [:show], :collection => [:push, :pull, :commit]
  end
end
