# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'ttevents/issue_lists' => 'ttevents#issue_lists'
get 'ttevents/new_issue' => 'ttevents#new_issue'
post 'ttevents/create_issue' => 'ttevents#create_issue'
resources :ttevents
patch 'ttevents/:id/with_issue' => 'ttevents#update_with_issue', as: :ttevent_with_issue

get 'ttstatistics/stats_by_month' => 'ttstatistics#stats_by_month'
get 'ttstatistics/stats_by_day' => 'ttstatistics#stats_by_day'
get 'ttstatistics/daily_report' => 'ttstatistics#daily_report'
post 'ttstatistics/daily_report' => 'ttstatistics#daily_report'
get 'ttstatistics' => 'ttstatistics#index'
