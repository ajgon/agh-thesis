ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'index'

  # See how all your routes lay out with "rake routes"
 
  # Install the default routes as the lowest priority.
  map.connect "/profile/:login_name", :controller => "profile", :action => "view", :requirements => {:login_name => /.*/ }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id/:page'
  map.connect ':controller/:action/:id.:format'
  
  # Old links mapper
  map.connect "/akt", :controller => 'index', :action => 'index'
  map.connect "/akt/twoje", :controller => 'index', :action => 'index'
  map.connect "/akt/wszystkie", :controller => 'news', :action => 'index'
  map.connect "/akt/search", :controller => 'news', :action => 'search'
  map.connect "/akt/egz", :controller => 'news', :action => 'exams'
  map.connect "/dzi", :controller => 'deanery', :action => 'index'
  map.connect "/dzi/plany", :controller => 'deanery', :action => 'skeds'
  map.connect "/dzi/prakt", :controller => 'deanery', :action => 'experience'
  map.connect "/dzi/przedmioty", :controller => 'deanery', :action => 'subjects'
  map.connect "/dzi/obieralne", :controller => 'deanery', :action => 'eligible'
  map.connect "/dzi/english", :controller => 'deanery', :action => 'english'
  map.connect "/dzi/mpe", :controller => 'deanery', :action => 'iep'
  map.connect "/dzi/deklaracje", :controller => 'deanery', :action => 'declarations'
  map.connect "/dzi/kalendarz", :controller => 'deanery', :action => 'calendar'
  map.connect "/mat", :controller => 'materials', :action => 'index'
  map.connect "/mat///101//date/1", :controller => 'materials', :action => 'search', :id => ',,101,,'
  map.connect "/mat///102//date/1", :controller => 'materials', :action => 'search', :id => ',,102,,'
  map.connect "/mat///103//date/1", :controller => 'materials', :action => 'search', :id => ',,103,,'
  map.connect "/mat///104//date/1", :controller => 'materials', :action => 'search', :id => ',,104,,'
  map.connect "/mat///105//date/1", :controller => 'materials', :action => 'search', :id => ',,105,,'
  map.connect "/oce", :controller => 'materials', :action => 'grades'
  map.connect "/pro", :controller => 'lecturers', :action => 'index'
  map.connect "/pro/elektronika", :controller => 'lecturers', :action => 'electronics'
  map.connect "/pro/telekomunikacja", :controller => 'lecturers', :action => 'telecommunication'
  map.connect "/gen", :controller => 'students', :action => 'index'
  map.connect "/stu", :controller => 'students', :action => 'webpages'
  map.connect "/sty/www", :controller => 'students', :action => 'own_webpage'
  map.connect "/pi", :controller => 'students', :action => 'polls'
  map.connect "/pod", :controller => 'postgraduate', :action => 'index'
  map.connect "/pod/nsiut_regulamin", :controller => 'postgraduate', :action => 'regulations'
  map.connect "/pod/nsiut_harmonogram", :controller => 'postgraduate', :action => 'schedule'
  map.connect "/pod/nsiut_program", :controller => 'postgraduate', :action => 'program'
  map.connect "/pod/nsiut_plan", :controller => 'postgraduate', :action => 'plan'
  map.connect "/ost/info", :controller => 'about', :action => 'index'
  map.connect "/ost/eiteam", :controller => 'about', :action => 'eiteam'
  map.connect "/ost/faq", :controller => 'about', :action => 'faq'
  map.connect "/map", :controller => 'about', :action => 'map'
  map.connect "/kon", :controller => 'settings', :action => 'profile'
  map.connect "/dl/:query", :controller => 'materials', :action => 'index', :requirements => {:query => /.*/}
  map.connect "/mat/:query", :controller => 'materials', :action => 'index', :requirements => {:query => /.*/}
  map.connect "/for/:query", :controller => 'index', :action => 'index', :requirements => {:query => /.*/}
  map.connect "/hyd/:query", :controller => 'index', :action => 'index', :requirements => {:query => /.*/}
end
