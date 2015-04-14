# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :ttevents
patch 'ttevents/:id/with_issue' => 'ttevents#update_with_issue', as: :ttevent_with_issue
