FactoryBot.define do
  factory :form do
    status { :draft }
    target_audience { :students }
    association :school_class
    association :form_template
  end
end
