# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    title "MyString"
    name "MyString"
    street "MyString"
    zip_city "MyString"
    email "MyString"
    msg_from "MyString"
    msg_to "MyString"
    body "MyText"
  end
end
