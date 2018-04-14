ActiveAdmin.register StuUser do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  filter :schno
  filter :name
  filter :collegename, as: :select
  filter :majorname

  index do
    selectable_column
    column :name
    column :grade
    column :college
    column :collegename
    column :majorname
    column :classesname
    column :cardcode
    column :schno
    column :created_at
    actions
  end
end
