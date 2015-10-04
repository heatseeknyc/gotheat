require 'csv'
namespace :import do
  desc 'Imports buildings from csv'
  task buildings: :environment do
    # buildings_file = './buildings2.csv'
    buildings_file = Rails.root.join('lib', 'tasks', 'buildings2.csv')
    CSV.foreach(buildings_file, :headers => true) do |row|
      Building.create({
        building: row["address"],
        lat: row["lat"],
        long: row["lon"],
        zip: row["zipcode"],
        city: row["borough"],
        score: row["risk1"]
      })
    end
  end
end
