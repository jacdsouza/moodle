@mod @mod_lti
Feature: Make an LTI only available to specific course categories
  In order to restrict which courses a tool can be used in
  As an administrator
  I need to be able to select which course category the tool is available in

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Terry1    | Teacher1 | teacher1@example.com |
    And the following "categories" exist:
      | name  | category | idnumber |
      | Cat 1 | 0        | CAT1     |
      | Cat 2 | 0        | CAT2     |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | CAT1 |
      | Course 2 | C2 | CAT2 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | teacher1 | C2 | editingteacher |

  @javascript
  Scenario: Tool is set to "Show as preconfigured tool when adding an external tool"
    When I log in as "admin"
    And I navigate to "Plugins > Activity modules > External tool > Manage tools" in site administration
    And I follow "Manage preconfigured tools"
    And I follow "Add preconfigured tool"
    And I expand all fieldsets
    And I set the following fields to these values:
      | Tool name | Teaching Tool 1 |
      | Tool configuration usage | Show as preconfigured tool when adding an external tool |
      | Cat 1 | 1 |
    And I set the field "Tool URL" to local url "/mod/lti/tests/fixtures/tool_provider.php"
    And I press "Save changes"
    And I log out

    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "External tool" to section "1"
    Then "Teaching Tool 1" "text" should exist in the "Preconfigured tool" "select"

    Given I am on site homepage
    And I am on "Course 2" course homepage with editing mode on
    And I add a "External tool" to section "1"
    Then "Teaching Tool 1" "text" should not exist in the "Preconfigured tool" "select"
    And I log out

  @javascript
  Scenario: Tool is set to "Show in activity chooser and as preconfigured tool"
    When I log in as "admin"
    And I navigate to "Plugins > Activity modules > External tool > Manage tools" in site administration
    And I follow "Manage preconfigured tools"
    And I follow "Add preconfigured tool"
    And I expand all fieldsets
    And I set the following fields to these values:
      | Tool name | Teaching Tool 2 |
      | Tool configuration usage | Show in activity chooser and as a preconfigured tool |
      | Cat 1 | 1 |
    And I set the field "Tool URL" to local url "/mod/lti/tests/fixtures/tool_provider.php"
    And I press "Save changes"
    And I log out

    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I open the activity chooser
    Then I should see "Teaching Tool 2" in the "Add an activity or resource" "dialogue"

    Given I am on site homepage
    And I am on "Course 2" course homepage with editing mode on
    And I open the activity chooser
    Then I should not see "Teaching Tool 2" in the "Add an activity or resource" "dialogue"
    Given I am on site homepage
    And I log out

  @javascript
  Scenario: Tool is set to "Do not show; use only when a matching tool URL is entered"
    When I log in as "admin"
    And I navigate to "Plugins > Activity modules > External tool > Manage tools" in site administration
    And I follow "Manage preconfigured tools"
    And I follow "Add preconfigured tool"
    And I expand all fieldsets
    And I set the following fields to these values:
      | Tool name | Teaching Tool 3 |
      | Tool configuration usage | Do not show; use only when a matching tool URL is entered |
      | Cat 1 | 1 |
    And I set the field "Tool URL" to local url "/mod/lti/tests/fixtures/tool_provider.php"
    And I press "Save changes"
    And I log out

    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "External tool" to section "1"
    And I set the field "Tool URL" to local url "/mod/lti/tests/fixtures/tool_provider.php"
    And I wait "10" seconds
    Then I should see "Using tool configuration: Teaching Tool 3"

    Given I am on site homepage
    And I am on "Course 2" course homepage with editing mode on
    And I add a "External tool" to section "1"
    And I set the field "Tool URL" to local url "/mod/lti/tests/fixtures/tool_provider.php"
    And I wait "10" seconds
    Then I should not see "Using tool configuration: Teaching Tool 3"
    Then I should see "Tool configuration not found for this URL"
    And I log out
