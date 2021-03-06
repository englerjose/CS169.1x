# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here
    Movie.create(title: movie["title"], rating: movie["rating"], description:
      movie["rating"], release_date: movie["release_date"])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert /#{e1}.*#{e2}/m =~ page.body # /m allows for multi-line regex
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    rating = "ratings_" + rating.strip
    uncheck.nil? ? check(rating) : uncheck(rating)
  end
end

Then /I should (not )?see movies with the following ratings: (.*)/ do |should_not, rating_list|
 rating_list.split(/,\s*/).each do |rating|
   # Uses a regex below to match only the rating (prevents 'G' matching 'PG')
   if should_not
     assert page.has_no_xpath?(".//*[@id='movies']/tbody/tr/td", :text => /^#{rating}$/)
   else
     assert page.has_xpath?(".//*[@id='movies']/tbody/tr/td", :text => /^#{rating}$/)
   end
 end
end


Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  movie_rows = page.all('table#movies tr').count - 1 # Do not include the labels
  movie_rows.should == 10
end
