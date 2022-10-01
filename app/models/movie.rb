class Movie < ActiveRecord::Base

    @@all_ratings = ['G','PG','PG-13','R']

    def self.all_ratings()
        @@all_ratings
    end

    def self.with_ratings(ratings)
        
        self.where(rating: ratings)

    end
end
