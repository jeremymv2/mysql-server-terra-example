module DeliveryTerraFormHelpers
  def upgrade_needed?
    true
  end
end

::Chef::Recipe.send(:include, DeliveryTerraFormHelpers)
::Chef::Resource.send(:include, DeliveryTerraFormHelpers)
