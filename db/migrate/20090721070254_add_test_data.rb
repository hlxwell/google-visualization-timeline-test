class AddTestData < ActiveRecord::Migration
  def self.up
    10000.times do
      month = rand(12)+1 
      day = rand(27)+1
      hour = rand(24)
      minus = rand(60)
      puts "#{month} #{day} #{hour} #{minus}"
      Click.create(:duration => Time.local(2009, month, day, hour, minus), :type_id => rand(100)+1)
    end
  end

  def self.down
    Click.delete_all
  end
end
