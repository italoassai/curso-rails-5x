class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true,  inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy:true

  paginates_per 5


# Scopes são apenas para pesquisas n o banco de dados

scope :_search_subject_, ->(page, subject_id){
  Question.includes(:answers, :subject)
          .where(subject_id: subject_id)
          .page(page)
          }

    scope :_search_, ->(params){
    Question.includes(:answers, :subject)
            .where("lower(description) LIKE ?", "%#{params[:term].downcase}%")
            .page(params[:page])
            }

  scope :order_last, ->(params){
    Question.includes(:answers, :subject).order('created_at desc').page(params[:page])
          }
end
