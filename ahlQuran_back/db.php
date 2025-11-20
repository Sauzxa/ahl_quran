<?php
class DB {
    private $server;
    private $user;
    private $pass;
    private $db;
    private $conn;
    private static $instance = null;
    
    public function __construct($server, $user, $pass, $db) {
        $this->server = $server;
        $this->user = $user;
        $this->pass = $pass;
        $this->db = $db;
    }
    
    public static function getInstance($server, $user, $pass, $db) {
        if (self::$instance === null) {
            self::$instance = new self($server, $user, $pass, $db);
        }
        return self::$instance;
    }
    
    public function lastInsert() {
        return $this->conn->insert_id;
    }

    public function connect() {
        if ($this->conn === null || !$this->conn->ping()) {
            $this->conn = new mysqli($this->server, $this->user, $this->pass, $this->db);
            
            if ($this->conn->connect_error) {
                throw new RuntimeException(
                    "Database connection failed: " . $this->conn->connect_error,
                    $this->conn->connect_errno
                );
            }
            
            $this->conn->set_charset("utf8mb4"); // Better than utf8 for full Unicode support
            $this->conn->options(MYSQLI_OPT_INT_AND_FLOAT_NATIVE, true); // Better number handling
        }
        
        return $this->conn;
    }
    
    public function getConnection() {
        return $this->connect();
    }
    
    public function beginTransaction() {
        $this->connect();
        $this->conn->begin_transaction();
    }
    
    public function commit() {
        if ($this->conn) {
            $this->conn->commit();
        }
    }
    
    public function rollback() {
        if ($this->conn) {
            $this->conn->rollback();
        }
    }
    
    /*public function __destruct() {
        if ($this->conn) {
            // Only close if not in transaction
            if ($this->conn->thread_id && !$this->conn->autocommit) {
                $this->conn->rollback();
            }
            $this->conn->close();
        }
    }*/
    
    public function isConnected() {
        return $this->conn !== null && $this->conn->ping();
    }
    
    public function escapeString($string) {
        $this->connect();
        return $this->conn->real_escape_string($string);
    }
    
    public function getLastInsertId() {
        return $this->conn ? $this->conn->insert_id : null;
    }
}
