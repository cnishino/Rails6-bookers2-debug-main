class ViewCount < ApplicationRecord
  #閲覧者数表示のアソシエーション
  belongs_to :user
  belongs_to :book

end
