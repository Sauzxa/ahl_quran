<?php 
    require_once '../../db.php';
    


    class Lecture {

		/**
		 * The name of the table in the database
		 */
		protected static $tableName = 'lecture';

		/** @var mixed $lecture_id */
		public $lecture_id;

		/** @var mixed $team_accomplishment_id */
		public $team_accomplishment_id;

		/** @var mixed $lecture_name_ar */
		public $lecture_name_ar;

		/** @var mixed $lecture_name_en */
		public $lecture_name_en;

		/** @var mixed $shown_on_website */
		public $shown_on_website;

		/** @var mixed $circle_type */
		public $circle_type;

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
		    $data['lecture_id'] = $conn->insert_id;
		    return new self($data);
		}

		/** Find a record by primary key. */
		public static function get(DB $db, int $id): ?self {
		    $conn = $db->getConnection();
		    $sql = "SELECT * FROM " . self::$tableName . " WHERE lecture_id = ?";
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
		    $id = $fields['lecture_id'];
		    unset($fields['lecture_id']);
		    $sets = array_map(fn($k) => "$k = ?", array_keys($fields));
		    $types = str_repeat('s', count($fields)) . 'i';
		    $values = array_values($fields);
		    $values[] = $id;
		    $sql = "UPDATE " . self::$tableName .
		           " SET " . implode(', ', $sets) . " WHERE lecture_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param($types, ...$values);
		    return $stmt->execute();
		}

		/** Delete this record from the database. */
		public function delete(DB $db): bool {
		    $conn = $db->getConnection();
		    $id = $this->lecture_id;
		    $sql = "DELETE FROM " . self::$tableName . " WHERE lecture_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('i', $id);
		    return $stmt->execute();
		}


		/** Get only lecture_id and lecture_name_ar for all lectures. */
		public static function getIdAndArNameOnly(DB $db): array {
			$conn = $db->getConnection();
			$sql = "SELECT lecture_id, lecture_name_ar FROM " . self::$tableName;
			$stmt = $conn->prepare($sql);
			if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
			$stmt->execute();
			$result = $stmt->get_result();
			
			$lectures = [];
			while ($row = $result->fetch_assoc()) {
				$lectures[] = [
					'lecture_id' => $row['lecture_id'],
					'lecture_name_ar' => $row['lecture_name_ar']
				];
			}
			return $lectures;
		}

}

