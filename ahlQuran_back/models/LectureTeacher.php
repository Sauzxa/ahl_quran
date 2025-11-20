<?php 
    require_once '../../db.php';
    


    class LectureTeacher {

		/**
		 * The name of the table in the database
		 */
		protected static $tableName = 'lecture_teacher';

		/** @var mixed $teacher_id */
		public $teacher_id;

		/** @var mixed $lecture_id */
		public $lecture_id;

		/** @var mixed $lecture_date */
		public $lecture_date;

		/** @var mixed $attendance_status */
		public $attendance_status;

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
		    $data['teacher_id'] = $conn->insert_id;
		    return new self($data);
		}

		/** Find a record by primary key. */
		public static function get(DB $db, int $lecture_id, int $teacher_id): ?self {
		    $conn = $db->getConnection();
		    $sql = "SELECT * FROM " . self::$tableName . " WHERE  lecture_id = ? AND teacher_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('ii', $lecture_id, $teacher_id);
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
		    $teacher_id = $fields['teacher_id'];
		    unset($fields['teacher_id']);
			$lecture_id = $fields['lecture_id'];
		    unset($fields['lecture_id']);
		    $sets = array_map(fn($k) => "$k = ?", array_keys($fields));
		    $types = str_repeat('s', count($fields)) . 'i';
		    $values = array_values($fields);
		    $values[] = $teacher_id;
			$values[] = $lecture_id;
		    $sql = "UPDATE " . self::$tableName .
		           " SET " . implode(', ', $sets) . " WHERE teacher_id = ? AND lecture_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param($types, ...$values);
		    return $stmt->execute();
		}

		/** Delete this record from the database. */
		public function delete(DB $db): bool {
		    $conn = $db->getConnection();
		    $sql = "DELETE FROM " . self::$tableName . " WHERE teacher_id = ? AND lecture_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('ii', $this->teacher_id, $this->lecture_id);
		    return $stmt->execute();
		}

		/** Delete this record from the database. */
		public function deleteById(DB $db, $teacher_id, $lecture_id): bool {
			$conn = $db->getConnection();
			$where = [];
			$params = [];
			$types = '';
			if (isset($teacher_id)) {
				$where[] = "teacher_id = ?";
				$params[] = $teacher_id;
				$types .= 'i';
			}
			if (isset($lecture_id)) {
				$where[] = "lecture_id = ?";
				$params[] = $lecture_id;
				$types .= 'i';
			}
			if (empty($where)) {
				throw new \InvalidArgumentException("At least one of teacher_id or lecture_id must be provided.");
			}
			$sql = "DELETE FROM " . self::$tableName . " WHERE " . implode(' AND ', $where);
			$stmt = $conn->prepare($sql);
			if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
			$stmt->bind_param($types, ...$params);
			return $stmt->execute();
		}

}

