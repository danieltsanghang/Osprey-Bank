# Osprey Bank

> Osprey Bank is an online banking service for scam baiters to bait out scammers. For years, scammers have plagued the internet with malicious use of technology, we are here to stop that!

## Team Name
Team Osprey

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
## Pre-populated Users
### There are two types of users on the application, a regular user and an admin. 1 Admin and 1 User is provided. With a single admin, you can create as many other admins or users as you want. Essentially, given 1 admin account you can do anything on the website. To login, click the "Login" button at the top right corner of the home page, or visit the URL <strong>/login</strong>. The admin and user details for login:

### Admin:
<strong>username:</strong> admin <br>
<strong>password:</strong> Password12345 <br>

### User:
<strong>username:</strong> seinfeld <br>
<strong>password:</strong> Password12345 <br>

<br>

### Note: There is a fake data generator an admin can access from the admin dashboard by clicking the button "Fake User Generator" or by visiting the route "/admin/generator/new". All users generated using this will have a default password of <strong>Password12345</strong>. The admin can change this password later by clicking the "Edit Password" button on the User index page or User show page, or by visiting the route <strong>/admin/users/:id/edit_password</strong>

<br>

## Notable Features/Routes

<ul>
    <li>
        There are nested resources that provide for a much better user experience. A full list of them can be found using <strong>rails routes</strong> or by viewing the <strong>routes.rb</strong> file. For example, a user can view all transactions from all accounts using the route: <strong> /transactions </strong> or for a specific account using <strong>/accounts/:id/transactions</strong>. Similarly, an admin can view all transactions or accounts for a specific user using the route <strong>/admin/users/:id/transactions</strong> or <strong>/admin/users/:id/accounts</strong>. These nested resources are very useful and convenient.
    </li>
    <li>
        An admin can create fake data on the website using following route: <strong>admin/generator/new</strong>, and can create fake transactions for specific users through the following route: <strong>admin/generator/new?userid=:id</strong>. <strong>Note:</strong> to create transactions for a specifc user, that user must have an account. Also, when generating transactions, if the admin selects 100 transactions to create, the generator will create 100 sent transactions and 100 received transactions for each account a user has, so 200 in total for each account.
    </li>
</ul>

## References
<ol>
    <li>
        Bootstrap Studio: This was used extensively throughout the development of the UI. Usage included using default themes/templates/stock images provided by the application.
    </li>
    <li>
        Bootstrap: Bootstrap was used significantly throughout the UI
    </li>
    <li>
        Font Awesome: This was used throughout the website for icons, such as in the admin dashboard page, or in the error pages.
    </li>
    <li>
        Rails Cast Episode 228 was used for implementing sortable rows.  http://railscasts.com/episodes/228-sortable-table-columns
    </li>
    <li>
        Images:
        <ol>
            <li>
            https://siftware.com/wp-content/uploads/2020/09/happy-customer-alt.png
            </li>
            <li>
            https://www.okgv.com/wp-content/uploads/2019/08/OlsonKulkoskiGallowayVesely-1035146258.jpg
            </li>
            <li>
            https://img.freepik.com/free-photo/happy-senior-woman_256588-835.jpg?size=626&ext=jpg&ga=GA1.2.548558842.1600041600
            </li>
            <li>
            https://cdn.ps.emap.com/wp-content/uploads/sites/3/2019/12/stock-image-of-young-girl-woman-student-440x330.jpg
            </li>
        </ol>
    </li>
</ol>
