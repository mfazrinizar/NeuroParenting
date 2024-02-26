<?php
// Set true for production, set false for sandbox
$headers = getallheaders();

// check if the "Is-Production" key exists in the headers
if (array_key_exists('Is-Production', $headers)) {
    // set $is_production based on the "Is-Production" key in the headers
    $is_production = $headers['Is-Production'] === 'true';
} else {
    // default to true if "Is-Production" is not in the headers
    $is_production = true;
}

// Set your server key (Note: Server key for sandbox and production mode are different)
$server_key = $is_production ? 'your-production-key' : 'your-sandbox-key';

$api_url = $is_production ? 
  'https://api.midtrans.com/v2/' : 
  'https://api.sandbox.midtrans.com/v2/';

// Check if method is not HTTP POST, display 404
if( $_SERVER['REQUEST_METHOD'] !== 'POST'){
  http_response_code(404);
  echo "Page not found or wrong HTTP request method is used"; exit();
}

// Get the JSON body from the request
$request_body = file_get_contents('php://input');
$data = json_decode($request_body, true);

// Get the order_id from the JSON data
$order_id = $data['order_id'];

// Call the cancel API
$cancel_result = cancelAPI($api_url, $server_key, $order_id);

// Set the response http status code
http_response_code($cancel_result['http_code']);

// Then print out the response body
echo $cancel_result['body'];

/**
 * Call cancel API using Curl
 * @param string  $api_url
 * @param string  $server_key
 * @param string  $order_id
 */
function cancelAPI($api_url, $server_key, $order_id){
  $ch = curl_init();
  $curl_options = array(
    CURLOPT_URL => $api_url . $order_id . '/cancel',
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_POST => 1,
    CURLOPT_HEADER => 0,
    // Add header to the request, including Authorization generated from server key
    CURLOPT_HTTPHEADER => array(
      'Content-Type: application/json',
      'Accept: application/json',
      'Authorization: Basic ' . base64_encode($server_key . ':')
    ),
  );
  curl_setopt_array($ch, $curl_options);
  $result = array(
    'body' => curl_exec($ch),
    'http_code' => curl_getinfo($ch, CURLINFO_HTTP_CODE),
  );
  return $result;
}
