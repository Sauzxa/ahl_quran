<?php

abstract class S_Controller
{
    protected static DB $dbconnection;

    public static function setDbConnection($db)
    {
        self::$dbconnection = $db;
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
        $input = json_decode(file_get_contents('php://input'), true);

        if (!is_array($input)) {
            echo json_encode(['error' => 'Invalid JSON input : '. json_last_error_msg() . ' - ' .$input]);
            return null;
        }

        return $input;
    }

    public static function execQuery(string  $query): mixed {
        if (!isset(self::$dbconnection)) {
            self::sendResponse(500, ['error' => 'Database connection not set']);
            return null;
        }
        if (empty($query)) {
            self::sendResponse(400, ['error' => 'Query cannot be empty']);
            return null;
        }
        // Execute the query
        $conn = self::$dbconnection->getConnection();

        // Assume $conn is mysqli
        $result = $conn->query($query);

        if ($result === false) {
            self::sendResponse(500, ['error' => 'Query execution failed', 'details' => $conn->error]);
            return null;
        }

        // If SELECT or similar, fetch results as associative array
        if ($result instanceof mysqli_result) {
            $data = [];
            while ($row = $result->fetch_assoc()) {
                $data[] = $row;
            }
            $result->free();
            return $data;
        } else {
            // For INSERT, UPDATE, DELETE, return affected rows or success message
            self::sendResponse(200, ['message' => 'Query executed successfully', 'affected_rows' => $conn->affected_rows]);
        }
        return null; // Return null for non-select queries
    }

}