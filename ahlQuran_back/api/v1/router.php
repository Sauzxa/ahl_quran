<?php

class Router
{
    private static $instance = null;
    private $routes = []; // [{"endpoint","controller","name_method"}, {} ....]
    private $prefix = '';
    private $basePath = '';

    // Private constructor to prevent direct instantiation
    private function __construct($basePath)
    {
        $this->basePath = $basePath;
    }

    // Prevent cloning of the instance
    private function __clone()
    {
    }

    // Static method to get the single instance of the class
    public static function getInstance($basePath)
    {
        if (self::$instance === null) {
            self::$instance = new self($basePath);
        }
        return self::$instance;
    }

    public function get($path, $callback)
    {
        $this->addRoute('GET', $path, $callback);
    }

    public function post($path, $callback)
    {
        $this->addRoute('POST', $path, $callback);
    }

    public function put($path, $callback)
    {
        $this->addRoute('PUT', $path, $callback);
    }

    public function delete($path, $callback)
    {
        $this->addRoute('DELETE', $path, $callback);
    }

    public function patch($path, $callback)
    {
        $this->addRoute('PATCH', $path, $callback);
    }

    public function options($path, $callback)
    {
        $this->addRoute('OPTIONS', $path, $callback);
    }

    public function head($path, $callback)
    {
        $this->addRoute('HEAD', $path, $callback);
    }

    public function addRoute($method, $path, $callback)
    {
        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'callback' => $callback,
        ];
    }

    public function setPrefix($prefix) {
        $this->prefix = rtrim($prefix, '/');
    }

    public function run()
    {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        $uri    = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '/';

        // Strip basePath & prefix
        foreach ([$this->basePath, $this->prefix] as $strip) {
            if ($strip !== '' && str_starts_with($uri, $strip)) {
                $uri = substr($uri, strlen($strip));
            }
        }
        $uri = '/' . ltrim($uri, '/');

        foreach ($this->routes as $route) {
            if ($route['method'] !== $method) {
                continue;
            }

            // Build a regex from the route path:
            //  - explode on '/'
            //  - for each segment, if it starts with ':' -> replace with '([^/]+)'
            //    otherwise preg_quote() that segment (delimiter '#')
            $parts = [];
            foreach (explode('/', trim($route['path'], '/')) as $segment) {
                if (str_starts_with($segment, ':')) {
                    $parts[] = '([^/]+)';
                } else {
                    $parts[] = preg_quote($segment, '#');
                }
            }
            $pattern = '#^/' . implode('/', $parts) . '$#';

            if (preg_match($pattern, $uri, $matches)) {
                array_shift($matches); // drop full match
                $cb = $route['callback'];

                // $cb is the callback to handle the route.
                // $matches contains the values of the route parameters (e.g., ids from the URL).
                if (is_callable($cb)) {
                    call_user_func_array($cb, $matches);
                } elseif (
                    is_array($cb)
                    && count($cb) === 2
                    && class_exists($cb[0])
                    && method_exists($cb[0], $cb[1])
                ) {
                    call_user_func_array($cb, $matches);
                } else {
                    http_response_code(500);
                    echo "Invalid callback for route {$route['path']}";
                }
                return;
            }
        }

        // No match → 404 JSON
        http_response_code(404);
        header('Content-Type: application/json');
        echo json_encode([
            'error' => 'Route not found',
            'uri'   => $uri,
        ]);
    }
}
?>