# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'ttevents/issue_lists' => 'ttevents#issue_lists'
resources :ttevents
patch 'ttevents/:id/with_issue' => 'ttevents#update_with_issue', as: :ttevent_with_issue

get 'ttstatistics/stats_by_month' => 'ttstatistics#stats_by_month'
get 'ttstatistics/stats_by_day' => 'ttstatistics#stats_by_day'
get 'ttstatistics' => 'ttstatistics#index'
