# README

* Ruby Version 2.7.0

* Rails Version 6.0.3

#### Instructions

* Clone the git repository
* Install ruby-2.7.0'
* Run the command `bundle install`
* Run the command `rails dev:cache` to enable caching in dev environment.
* Run the test suite using `rspec` to confirm if the setup is successful.
* Start the rails server using `rails s`
* Test the application by visiting http://localhost:3000/


#### Details

* User Authentication implemented using `devise` gem along with reset password functionality.
* Visit http://localhost:3000/letter_opener to check emails in development mode.
* On the home page details of top 20 active streams are displayed.
* A seprate search page has been created, where logged in user can search for Channel, the result list display thubmnail, title, language and streaming time. These results are also cached into the DB as user search history. This fetaures is implemented using `Ajax`.
* On the same page "I am feeling lucky" (Bonus task) is also covered, user can get the results by clicking on "I am feelng lucky", the results contain all new results which was not part of user histories.
* A logged in User can check his/her search history, the page has query and result histories on this page. **From perfomance perspective this is not the best solution, all these records should be cached/stored into a NoSQL database. I prefered redis for this solution howevr for the time constraint, I am using the same DB.**
* The search results details contains the profile details and a badge indicating if the channel is in top 20 postions.
* Test cases are added for the respective functionalities.

### Limitations
Since the API return the data in a specific order, I have to implement pagination logic for not repeating the results. Also the pagination is no more supported for channel search API - https://discuss.dev.twitch.tv/t/helix-video-request-not-returning-pagination-cursor-field/18199

### TODOs
* Implement Redis for better performance
* User's search history should also moved to Redis or any NoSQL DB for better performance
