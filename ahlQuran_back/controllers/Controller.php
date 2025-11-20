<?php

abstract class Controller
{
    protected static $dbconnection;

    public static function setDbConnection($db)
    {
        self::$dbconnection = $db;
    }
    public static function getAll() {
        self::sendResponse(200, ['message' => 'getAll not implemented']);
    }
    public static function getOne(int ...$id) {    
        self::sendResponse(200, ['message' => 'getOne not implemented']);
    }
    public static function save() {
        self::sendResponse(200, ['message' => 'save not implemented']);
    }
    public static function edit(int ...$id) {
        self::sendResponse(200, ['message' => 'edit not implemented']);
    }
    public static function update(int ...$id) {
        self::sendResponse(200, ['message' => 'update not implemented']);
    }
    public static function delete(int ...$id) {
        self::sendResponse(200, ['message' => 'delete not implemented']);
    }

    protected static function sendResponse(int $statusCode, $data): void
    {
        // Set CORS headers
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
        header('Access-Control-Max-Age: 86400'); // Cache preflight for 24 hours
        
        http_response_code($statusCode);
        header('Content-Type: application/json');
        $json = json_encode($data);
        if ($json === false) {
            var_dump(json_last_error_msg());
        } else {
            echo ($json);
        }
    }

    protected static function getRequestBody() : mixed {
        // Parse JSON input and ensure it is returned as an associative array
        $input = json_decode(file_get_contents('php://input'), true);

        if (!is_array($input)) {
            echo json_encode(['error' => 'Invalid JSON input : '. json_last_error_msg() . ' - ' .$input]);
            return null;
        }

        // Ensure all keys are strings
        $input = array_map('strval', $input);
        return $input;
    }
}