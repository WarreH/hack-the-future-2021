<?php

namespace Drupal\token\Plugin\rest\resource;

use Drupal\rest\Plugin\ResourceBase;
use Drupal\rest\ResourceResponse;


/**
 * Provides a Demo Resource
 *
 * @RestResource(
 *   id = "token",
 *   label = @Translation("token"),
 *   uri_paths = {
 *     "canonical" = "/session/token"
 *   }
 * )
 */
    
class TokenResource extends ResourceBase {

     /**
   * Responds to entity GET requests.
   * @return \Drupal\rest\ResourceResponse
   */
    
    public function get() {
    $response = ['message' => 'Hello, this is a rest service'];
    return new ResourceResponse($response);
    }
    
  
}
