@admin
Feature: Admin email banned list
  In order to prevent the use of certain email addresses in guest comments
  As an an admin
  I want to be able to manage a banned list of email addresses

Scenario: Add email address to banned list
  Given I am logged in as an admin
  Then I should see "Banned List"
  When I follow "Banned List"
  Then I should see "Find banned emails"
    And I should see "Add email address to banned list"
    And I should see "Email"
  When I fill in "Email" with "foo@bar.com"
    And I press "Add To Banned List"
  Then I should see "Email address foo@bar.com added to banned list"
    And the address "foo@bar.com" should be in the banned list

Scenario: Remove email address from blacklist
  Given I am logged in as an admin
    And I have banned the address "foo@bar.com"
  When I follow "Banned List"
    And I fill in "Email to find" with "bar"
    And I press "Search Banned List"
  Then I should see "email found"
    And I should see "foo@bar.com"
  When I follow "Remove"
  Then I should see "Email address foo@bar.com removed from banned list"
    And the address "foo@bar.com" should not be in the banned list

Scenario: Banned email addresses should not be usable in guest comments
  Given I am logged in as an admin
    And I have banned the address "foo@bar.com"
    And I am logged in as "author"
    And I post the work "New Work"
  When I post the comment "I loved this" on the work "New Work" as a guest with email "foo@bar.com"
  Then I should see "has been blocked at the owner's request"
    And I should not see "Comments (1)"
  When I fill in "Guest email" with "someone@bar.com"
    And I press "Comment"
  Then I should see "Comments (1)"

Scenario: Variants of banned email addresses should not be usable
  Given I am logged in as an admin
  When I have banned the address "foo.bar+gloop@googlemail.com"
  Then the address "foobar@gmail.com" should be in the banned list
  When I am logged out
  Then I should not be able to comment with the address "foobar@gmail.com"
    And I should not be able to comment with the address "foobar+baz@gmail.com"
    And I should not be able to comment with the address "foo.bar@gmail.com"
    And I should be able to comment with the address "whee@gmail.com"

Scenario: Banning a user's email should not affect their ability to post comments
  Given the user "author" exists and is activated
    And I am logged in as an admin
    And I have banned the address for user "author"
  When I am logged in as "author"
    And I post the work "New Work"
    And I post a comment "here's a great comment"
  Then I should see "Comment created!"
