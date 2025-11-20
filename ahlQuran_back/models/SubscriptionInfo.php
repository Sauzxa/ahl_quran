<?php 
    require_once '../../db.php';
    


    class SubscriptionInfo {

		/**
		 * The name of the table in the database
		 */
		protected static $tableName = 'subscription_info';

		/** @var mixed $subscription_id */
		public $subscription_id;

		/** @var mixed $student_id */
		public $student_id;

		/** @var mixed $enrollment_date */
		public $enrollment_date;

		/** @var mixed $exit_date */
		public $exit_date;

		/** @var mixed $exit_reason */
		public $exit_reason;

		/** @var mixed $is_exempt_from_payment */
		public $is_exempt_from_payment;

		public $exemption_percentage;

		public function __construct(array $data = []) {
		    foreach ($data as $key => $value) {
		        if (property_exists($this, $key)) {
		            $this->$key = $value;
		        }
		    }
		}

		/** Insert a new record and return the new object. */
		public static function create(DB $db, array $data): self {
		    $conn = $db->getConnection();
		    $columns = array_keys($data);
		    $placeholders = array_fill(0, count($columns), '?');
		    $types = str_repeat('s', count($data));
		    $sql = "INSERT INTO " . self::$tableName .
		           " (" . implode(', ', $columns) . ") VALUES (" . implode(', ', $placeholders) . ")";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param($types, ...array_values($data));
		    $stmt->execute();
		    $data['subscription_id'] = $conn->insert_id;
		    return new self($data);
		}

		/** Find a record by primary key. */
		public static function get(DB $db, int $id): ?self {
		    $conn = $db->getConnection();
		    $sql = "SELECT * FROM " . self::$tableName . " WHERE subscription_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('i', $id);
		    $stmt->execute();
		    $result = $stmt->get_result();
		    $row = $result->fetch_assoc();
		    return $row ? new self($row) : null;
		}

		/** Show all data. */
		public static function getAll(DB $db): array {
		    $conn = $db->getConnection();
		    $sql = "SELECT * FROM " . self::$tableName;
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->execute();
		    $result = $stmt->get_result();
		    $objects = [];
		    while ($row = $result->fetch_assoc()) {
		        $objects[] = new self($row);
		    }
		    return $objects;
		}

		/** Update this record in the database. */
		public function update(DB $db): bool {
		    $conn = $db->getConnection();
		    $fields = get_object_vars($this);
		    $id = $fields['subscription_id'];
		    unset($fields['subscription_id']);
		    $sets = array_map(fn($k) => "$k = ?", array_keys($fields));
		    $types = str_repeat('s', count($fields)) . 'i';
		    $values = array_values($fields);
		    $values[] = $id;
		    $sql = "UPDATE " . self::$tableName .
		           " SET " . implode(', ', $sets) . " WHERE subscription_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param($types, ...$values);
		    return $stmt->execute();
		}

		/** Delete this record from the database. */
		public function delete(DB $db): bool {
		    $conn = $db->getConnection();
		    $id = $this->subscription_id;
		    $sql = "DELETE FROM " . self::$tableName . " WHERE subscription_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('i', $id);
		    return $stmt->execute();
		}

}

