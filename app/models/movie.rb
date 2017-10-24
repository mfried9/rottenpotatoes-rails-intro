class Movie < ActiveRecord::Base
    def Movie.all_ratings
        Movie.distinct.pluck(:rating)
    end
end
