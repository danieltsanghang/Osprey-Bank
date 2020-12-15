# Osprey Bank

> Osprey Bank is an online banking service for scam baiters to bait out scammers. For years, scammers have plagued the internet with malicious use of technology, we are here to stop that!

## Team Members

<ol>
    <li> Mohammad Albinhassan   (mohammad.albinhassan@kcl.ac.uk)
    <li> Gila Pearlman  (gila.pearlman@kcl.ac.uk)
    <li> Tulsi Popat    (tulsi.popat@kcl.ac.uk)
    <li> Jonathan (Jon) Rivera  (jonathan.rivera@kcl.ac.uk)
    <li> Hang (Daniel) Tsang    (hang.tsang@kcl.ac.uk)
</ol>

## Deployed Application URL
>OspreyBank.com

## Languages/Technologies Used
>Ruby on Rails 2.7.1, PostgreSQL, HTML, SCSS, JavaScript and deployed on Heroku

## Local Usage

```ruby
bundle install
yarn install
rake db:migrate
rake db:seed
rails server
```

## References
<ol>
    <li>
        Bootstrap Studio: This was used extensively throughout the development of the UI. Usage included using default themes/templates provided by the application.
    </li>
    <li>
        Rails Cast Episode 228 was used for implementing sortable rows.  http://railscasts.com/episodes/228-sortable-table-columns
    </li>
</ol>

## Notable Features/Routes

<ul>
    <li>
        There are nested resources that provide for a much better user experience. A full list of them can be found using <strong>rails routes</strong> or by viewing the <strong>routes.rb</strong> file. For example, a user can view all transactions from all accounts using the route: <strong> /users/:id/transactions </strong> Similarly, an admin can view all transactions or accounts using the route <strong>/admin/users/:id/transactions</strong> or <strong>/admin/users/:id/accounts</strong>. These nested resources are very useful and convenient.
    </li>
    <li>
        An admin can create fake data for a user through the following route: <strong>insert route here later</strong>
    </li>
</ul>
