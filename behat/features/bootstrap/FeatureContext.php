<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Hook\Scope\AfterFeatureScope;
use Behat\MinkExtension\Context\MinkContext;
use WembassyContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends WembassyContext
{
  // Define test users and passwords for our testing.

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct()
  {
    $this->users = array(
      'customer' => array(
        'username' => 'customer@customer.com',
        'pass' => 'lol123'
      ),
      'supplier' => array(
        'username' => 'supplier@supplier.com',
        'pass' => 'lol123',
      ),
      'admin' => array(
        'username' => 'admin@admin.com',
        'pass' => 'lol123'
      )
    );

  }

  /**
  * Force the script to wait for jquery.
  */
  protected function jqueryWait($duration = 1000)
  {
  		$this->getSession()->wait($duration, '(0 === jQuery.active && 0 === jQuery(\':animated\').length)');
  }

  /**
   * @Given I am logged in as :arg1
   */
  public function iAmLoggedInAs($arg1)
  {
      throw new PendingException();
  }

  /**
   * @When /^I search for "([^"]*)"$/
   */
  public function iSearchFor($arg1)
  {
    $this->fillField('Search ...', $arg1);
    $this->pressButton('Search');
  }

  /**
   * @Given I am logged in as :arg1
   */
  public function iAmLoggedInAs($arg1)
  {
      if ($user = $this->users[$arg1]) {
        // Open the modal
        $this->getSession()->getPage()->find('css',
          'a[data-target="#login-modal"]')->click()
        $this->jqueryWait(2000);

        // Fill out our form with the user information
        $this->getSession()->getPage()->find('css',
          'input[name="edit-name"]')->setValue($user['username']);

        $this->getSession()->getPage()->find('css',
          'input[name="edit-pass"]')->setValue($user['pass']);
      }
      else {

      }
  }

  /**
   * @When I click the Navigation Hamburger
   */
  public function iClickTheNavigationHamburger()
  {
      throw new PendingException();
  }

  /**
   * @Then I should see the :arg1 link
   */
  public function iShouldSeeTheLink($arg1)
  {
      throw new PendingException();
  }

}
