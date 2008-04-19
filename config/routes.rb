ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'redirect', :new_url => '/catalog/view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'redirect', :new_url => '/catalog/purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/.html.
  map.root :controller => 'index'

  # See how all your routes lay out with "rake routes"
 
  # Install the default routes as the lowest priority.
  map.connect "/profile/:login_name", :controller => "profile", :action => "view", :requirements => {:login_name => /.*/ }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id/:page'
  map.connect ':controller/:action/:id.:format'
  
  # Old links mapper
  map.connect "/rss/:query", :controller => 'rss', :action => 'index', :requirements => {:query => /.*/}
  map.connect "/akt", :controller => 'redirect', :new_url => '/'
  map.connect "/akt/twoje", :controller => 'redirect', :new_url => '/'
  map.connect "/akt/wszystkie", :controller => 'redirect', :new_url => '/news'
  map.connect "/akt/search", :controller => 'redirect', :new_url => '/news/search'
  map.connect "/akt/egz", :controller => 'redirect', :new_url => '/news/exams'
  map.connect "/dzi", :controller => 'redirect', :new_url => '/deanery'
  map.connect "/dzi/plany", :controller => 'redirect', :new_url => '/deanery/skeds'
  map.connect "/dzi/prakt", :controller => 'redirect', :new_url => '/deanery/experience'
  map.connect "/dzi/przedmioty", :controller => 'redirect', :new_url => '/deanery/subjects'
  map.connect "/dzi/obieralne", :controller => 'redirect', :new_url => '/deanery/eligible'
  map.connect "/dzi/english", :controller => 'redirect', :new_url => '/deanery/english'
  map.connect "/dzi/mpe", :controller => 'redirect', :new_url => '/deanery/iep'
  map.connect "/dzi/deklaracje", :controller => 'redirect', :new_url => '/deanery/declarations'
  map.connect "/dzi/kalendarz", :controller => 'redirect', :new_url => '/deanery/calendar'
  map.connect "/mat", :controller => 'redirect', :new_url => '/materials'
  map.connect "/mat///101//date/1", :controller => 'redirect', :new_url => '/materials/search', :id => ',,101,,'
  map.connect "/mat///102//date/1", :controller => 'redirect', :new_url => '/materials/search', :id => ',,102,,'
  map.connect "/mat///103//date/1", :controller => 'redirect', :new_url => '/materials/search', :id => ',,103,,'
  map.connect "/mat///104//date/1", :controller => 'redirect', :new_url => '/materials/search', :id => ',,104,,'
  map.connect "/mat///105//date/1", :controller => 'redirect', :new_url => '/materials/search', :id => ',,105,,'
  map.connect "/oce", :controller => 'redirect', :new_url => '/materials/grades'
  map.connect "/pro", :controller => 'redirect', :new_url => '/lecturers'
  map.connect "/pro/elektronika", :controller => 'redirect', :new_url => '/lecturers/electronics'
  map.connect "/pro/telekomunikacja", :controller => 'redirect', :new_url => '/lecturers/telecommunication'
  map.connect "/gen", :controller => 'redirect', :new_url => '/students'
  map.connect "/stu", :controller => 'redirect', :new_url => '/students/webpages'
  map.connect "/sty/www", :controller => 'redirect', :new_url => '/students/own_webpage'
  map.connect "/pi", :controller => 'redirect', :new_url => '/students/polls'
  map.connect "/pod", :controller => 'redirect', :new_url => '/postgraduate'
  map.connect "/pod/nsiut_regulamin", :controller => 'redirect', :new_url => '/postgraduate/regulations'
  map.connect "/pod/nsiut_harmonogram", :controller => 'redirect', :new_url => '/postgraduate/schedule'
  map.connect "/pod/nsiut_program", :controller => 'redirect', :new_url => '/postgraduate/program'
  map.connect "/pod/nsiut_plan", :controller => 'redirect', :new_url => '/postgraduate/plan'
  map.connect "/ost/info", :controller => 'redirect', :new_url => '/about'
  map.connect "/ost/eiteam", :controller => 'redirect', :new_url => '/about/eiteam'
  map.connect "/ost/faq", :controller => 'redirect', :new_url => '/about/faq'
  map.connect "/map", :controller => 'redirect', :new_url => '/about/map'
  map.connect "/kon", :controller => 'redirect', :new_url => '/settings/profile'
  map.connect "/dl/:query", :controller => 'redirect', :new_url => '/materials', :requirements => {:query => /.*/}
  map.connect "/mat/:query", :controller => 'redirect', :new_url => '/materials', :requirements => {:query => /.*/}
  map.connect "/for/:query", :controller => 'redirect', :new_url => '/', :requirements => {:query => /.*/}
  map.connect "/hyd/:query", :controller => 'redirect', :new_url => '/', :requirements => {:query => /.*/}
  map.connect "/akt/:query", :controller => 'redirect', :new_url => '/news', :requirements => {:query => /.*/}
end
