<?php 
    require_once '../../db.php';
    


    class ExamStudent {

		/**
		 * The name of the table in the database
		 */
		protected static $tableName = 'exam_student';

		/** @var mixed $exam_id */
		public $exam_id;

		/** @var mixed $student_id */
		public $student_id;

		/** @var mixed $appreciation_id */
		public $appreciation_id;

		/** @var mixed $point_hifd */
		public $point_hifd;

		/** @var mixed $point_tajwid_applicative */
		public $point_tajwid_applicative;

		/** @var mixed $point_tajwid_theoric */
		public $point_tajwid_theoric;

		/** @var mixed $point_performance */
		public $point_performance;

		/** @var mixed $point_deduction_tal9ini */
		public $point_deduction_tal9ini;

		/** @var mixed $point_deduction_tanbihi */
		public $point_deduction_tanbihi;

		/** @var mixed $point_deduction_tajwidi */
		public $point_deduction_tajwidi;

		/** @var mixed $date_take_exam */
		public $date_take_exam;

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
		    $data['exam_id'] = $conn->insert_id;
		    return new self($data);
		}

		/** Find a record by primary key. */
		public static function get(DB $db, int $idExam, int $idStudent): ?self {
			$conn = $db->getConnection();
			$sql = "SELECT * FROM " . self::$tableName . " WHERE exam_id = ? AND student_id = ?";
			$stmt = $conn->prepare($sql);
			if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
			$stmt->bind_param('ii', $idExam, $idStudent);
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
			$idExam = $fields['exam_id'];
			$idStudent = $fields['student_id'];
			unset($fields['exam_id']);
			unset($fields['student_id']);
			$sets = array_map(fn($k) => "$k = ?", array_keys($fields));
			$types = str_repeat('s', count($fields)) . 'ii';
			$values = array_values($fields);
			$values[] = $idExam;
			$values[] = $idStudent;
			$sql = "UPDATE " . self::$tableName .
				   " SET " . implode(', ', $sets) . " WHERE exam_id = ? AND student_id = ?";
			$stmt = $conn->prepare($sql);
			if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
			$stmt->bind_param($types, ...$values);
			return $stmt->execute();
		}

		/** Delete this record from the database. */
		public function delete(DB $db): bool {
		    $conn = $db->getConnection();
		    $sql = "DELETE FROM " . self::$tableName . " WHERE exam_id = ? AND student_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('ii', $this->exam_id, $this->student_id);
		    return $stmt->execute();
		}

}

