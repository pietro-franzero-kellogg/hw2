# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!

# Rubric
# 
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)

# Submission
# 
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the 
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======

# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========

# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Delete existing data, so you'll start fresh each time this script is run.
# Use `Model.destroy_all` code.
Studio.destroy_all
Movie.destroy_all
Actor.destroy_all
Role.destroy_all

# Generate models and tables, according to the domain model.

# rails generate model Studio
# rails generate model Movie
# rails generate model Actor
# rails generate model Role

# rails db:migrate

# Insert data into the database that reflects the sample data shown above.
# Do not use hard-coded foreign key IDs.
studios = Studio.insert_all(
    [
        {name: "Warner Bros."}
    ]
)
# puts Studio.all.inspect

movies = [
    {title: "Batman Begins", 
    year_released: 2005, 
    rated: "PG-13", 
    studio: "Warner Bros."},

    {title: "The Dark Knight", 
    year_released: 2008, 
    rated: "PG-13", 
    studio: "Warner Bros."},

    {title: "The Dark Knight Rises", 
    year_released: 2012, 
    rated: "PG-13", 
    studio: "Warner Bros."}
]

for movie in movies
    studio = Studio.find_by(name: movie[:studio])
    movie[:studio_id] = studio[:id]
    movie.delete(:studio)
end

movies = Movie.insert_all(movies)
# puts Movie.all.inspect

actors = Actor.insert_all(
    [
        {name: "Christian Bale"},
        {name: "Michael Caine"},
        {name: "Liam Neeson"},
        {name: "Katie Holmes"},
        {name: "Gary Oldman"},
        {name: "Heath Ledger"},
        {name: "Aaron Eckhart"},
        {name: "Maggie Gyllenhaal"},
        {name: "Tom Hardy"},
        {name: "Joseph Gordon-Levitt"},
        {name: "Anne Hathaway"}
    ]
)
# puts Actor.all.inspect

roles = [
    {title: "Batman Begins", actor: "Christian Bale", character_name: "Bruce Wayne"},
    {title: "Batman Begins", actor: "Michael Caine", character_name: "Alfred"},
    {title: "Batman Begins", actor: "Liam Neeson", character_name: "Ra's Al Ghul"},
    {title: "Batman Begins", actor: "Katie Holmes", character_name: "Rachel Dawes"},
    {title: "Batman Begins", actor: "Gary Oldman", character_name: "Commissioner Gordon"},
    {title: "The Dark Knight", actor: "Christian Bale", character_name: "Bruce Wayne"},
    {title: "The Dark Knight", actor: "Heath Ledger", character_name: "Joker"},
    {title: "The Dark Knight", actor: "Aaron Eckhart", character_name: "Harvey Dent"},
    {title: "The Dark Knight", actor: "Michael Caine", character_name: "Alfred"},
    {title: "The Dark Knight", actor: "Maggie Gyllenhaal", character_name: "Rachel Dawes"},
    {title: "The Dark Knight Rises", actor: "Christian Bale", character_name: "Bruce Wayne"},
    {title: "The Dark Knight Rises", actor: "Gary Oldman", character_name: "Commissioner Gordon"},
    {title: "The Dark Knight Rises", actor: "Tom Hardy", character_name: "Bane"},
    {title: "The Dark Knight Rises", actor: "Joseph Gordon-Levitt", character_name: "John Blake"},
    {title: "The Dark Knight Rises", actor: "Anne Hathaway", character_name: "Selina Kyle"}
]

for role in roles
    movie = Movie.find_by(title: role[:title])
    role[:movie_id] = movie[:id]
    role.delete(:title)

    actor = Actor.find_by(name: role[:actor])
    role[:actor_id] = actor[:id]
    role.delete(:actor)
end

roles = Role.insert_all(roles)
# puts Role.all.inspect

# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
for movie in Movie.all
    studio = Studio.find_by(id: movie[:studio_id])
    puts "-- #{movie[:title]}\t#{movie[:year_released]}\t#{movie[:rated]}\t#{studio[:name]}"
end

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""

# Query the cast data and loop through the results to display the cast output for each movie.
for role in Role.all
    movie = Movie.find_by(id: role[:movie_id])
    actor = Actor.find_by(id: role[:actor_id])
    puts "-- #{movie[:title]}\t#{actor[:name]}\t#{role[:character_name]}"
end
