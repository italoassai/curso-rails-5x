module SiteHelper

 def msg_jumbotron
case params[:action]
when 'index'
    "Últimas perguntas cadastradas"
when 'questions'
  "Resultados para o termo \"#{params[:term]}\"... "

when 'subject'
    "Mostrando questões relacionadas ao assunto \"#{params[:subject]}\"..."

end
end
  end
