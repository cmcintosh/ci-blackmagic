<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Hook\Scope\AfterFeatureScope;
use Behat\MinkExtension\Context\MinkContext;

/**
 * Defines application features from the specific context.
 */
class WembassyContext extends MinkContext implements Behat\Behat\Context\SnippetAcceptingContext
{

  /**
  * @Then perform a pdiff for :argument
  */
  public function perform_a_pdiff($page) {

    $image_data = $this->getSession()->getDriver()->getScreenshot();
    $current_run_img = "./tmp/{$page}_current.png";
    $last_run_img = "./tmp/{$page}_last.png";
    $pdif_result_img = "./tmp/{$page}_diff.png";

    if (file_exists($current_run_img)) {
      if(file_exists($pdif_result_img)) {
        unlink($pdif_result_img);
      }
      rename($current_run_img, $last_run_img);
      file_put_contents($current_run_img, $image_data);
      shell_exec("vendor/pdiff/perceptualdiff {$last_run_img} {$current_run_img} -output $pdif_result_img");

      if(file_exists($pdif_result_img)) {

      }
    }
    else {
      file_put_contents($current_run_img, $image_data);
    }
  }

}
