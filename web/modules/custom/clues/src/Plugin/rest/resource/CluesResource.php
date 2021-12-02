<?php

namespace Drupal\clues\Plugin\rest\resource;

use Drupal\rest\Plugin\ResourceBase;
use Drupal\rest\ResourceResponse;


/**
 * Provides a Demo Resource
 *
 * @RestResource(
 *   id = "clues",
 *   label = @Translation("clues"),
 *   uri_paths = {
 *     "canonical" = "/api/cluedo/guess"
 *   }
 * )
 */
    
class CluesResource extends ResourceBase {

   public function post() {
    $content = json_decode(file_get_contents('php://input'), true);
    $key = \Drupal::request()->query->get('key');
    $weaponGuess = $content['weapon'];
    $roomGuess = $content['room'];
    $suspectGuess = $content['suspect'];
        
        
    $response = ['message' => $key];

 $nodes = \Drupal::entityTypeManager()
 ->getStorage('node')
 ->loadByProperties([
 'field_key' => $key,
 'type' => 'game'
 ]);
    $result = reset($nodes);
 $weapon = $result->get('field_weapon')->target_id;
 $room = $result->get('field_room')->target_id;
 $weapon = $result->get('field_suspect')->target_id;
       
 $fault = [];
 $correct = 0;
       
if($weapon != $weaponGuess){
   array_push($fault, $weaponGuess);
 } else{
     $correct++;
 }
  if($room != $roomGuess) {
      array_push($fault, $roomGuess);
  } else{
      $correct++;
      
           
      }
  if($suspect != $suspectGuess) {
      array_push($fault, $suspectGuess);
       } else{
           $correct++;
      }
    
   shuffle($fault);
    $incorrect = $fault[0];
    return new ResourceResponse(['num_correct' => $correct, 'incorrect' =>$incorrect ]);
        
  }
}
