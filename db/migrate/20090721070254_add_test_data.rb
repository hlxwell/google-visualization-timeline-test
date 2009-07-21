class AddTestData < ActiveRecord::Migration
  def self.up
    10000.times do
      Click.create(:duration => Time.local(2009, rand(12)+1, rand(27)+1), :type_id => rand(100)+1)
    end
  end

  def self.down
    Click.delete_all
  end
end
