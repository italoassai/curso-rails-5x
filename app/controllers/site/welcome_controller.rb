class Site::WelcomeController < SiteController
  def index
    @questions = Question.order_last(params)
  end
end
