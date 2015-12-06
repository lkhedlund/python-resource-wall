#Sinatra-to-Django Transfer notes

###Tasks:
- ~~Move all public files to posting_wall static.~~
- ~~Convert Layout.html to base.html~~
- ~~Finish basic Django features before applying styling~~
- ~~Add comments to models~~
- Add Upvotes and Bookmarks features if number of active users is high enough
- Add article images?
- ~~Add tags to articles~~
- Add article scraper
- Maybe switch to the [bootstrap 3 egg](https://github.com/dyve/django-bootstrap3)

###Notes:
- Not sure about article images given the types of articles being added. Could maybe autofill with a placekitten or something fun.
- Popularity on post_list is by number of comments rather than votes until votes are added.
  - Will need to learn how to count by a single post's comments first

###Sinatra Files to keep:
_Reason for keeping is nested_
- views/articles/index.erb
  - Can use if upvotes and bookmarks are added
-views/articles/show.erb
  - Same reason as above
