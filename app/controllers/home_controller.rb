class HomeController < ApplicationController
  skip_before_filter :require_login

  def home
    render Rails.root.join('public', 'index.html').to_s
  end
end
