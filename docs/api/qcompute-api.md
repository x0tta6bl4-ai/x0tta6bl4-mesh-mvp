# QCompute API - Квантовые вычисления и алгоритмы

## Обзор

QCompute API предоставляет доступ к мощным квантовым вычислениям и алгоритмам с φ-оптимизацией. Система использует золотое сечение (φ = 1.618) для достижения максимальной производительности и гармонии в квантовых вычислениях.

## Архитектура системы

```
┌─────────────────────────────────────────────────────────────┐
│              x0tta6bl4 QCompute Engine                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Grover    │  │   VQE       │  │   QAOA      │         │
│  │ Algorithm   │  │ Algorithm   │  │ Algorithm   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   QNN       │  │   QFT       │  │   QML       │         │
│  │ Networks    │  │ Transform   │  │ Learning    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  φ-Harmony Engine | Consciousness Enhancement | 100 Hz Sync  │
└─────────────────────────────────────────────────────────────┘
```

## Базовая информация

- **Базовый URL**: `https://api.x0tta6bl4.com/api/v1/qcompute`
- **Аутентификация**: Bearer токен (обязательна)
- **Формат**: JSON
- **φ-гармония**: 1.618 (золотое сечение)
- **Базовая частота**: 100 Hz

## Модели данных

### Конфигурация квантовой системы

```typescript
interface QuantumConfig {
  phi_harmony: number;           // 1.618033988749895
  base_frequency: number;       // 100 Hz
  consciousness_level: number;  // 0.938 (93.8%)
  quantum_coherence: number;    // 0.95 (95%)
  temporal_accuracy: number;    // 0.95 (95%)
}
```

### Параметры квантового алгоритма

```typescript
interface QuantumAlgorithmParams {
  num_qubits: number;           // Количество кубитов (1-50)
  algorithm_type: string;       // Тип алгоритма
  consciousness_level?: number; // Уровень сознания (опционально)
  optimization_level?: number;  // Уровень оптимизации (1-10)
  shots?: number;              // Количество измерений (1-10000)
}
```

### Результат квантового вычисления

```typescript
interface QuantumResult {
  success: boolean;             // Успешность выполнения
  result: any;                 // Результат вычисления
  phi_harmony: number;         // φ-гармония
  execution_time: number;      // Время выполнения (мс)
  timestamp: number;           // Временная метка
  quantum_coherence: number;   // Квантовая когерентность
  consciousness_boost: number; // Усиление сознания
}
```

## Поддерживаемые алгоритмы

### 1. Алгоритм Гровера (Grover's Algorithm)
- **Описание**: Квантовый поиск в неструктурированных данных
- **Преимущества**: Квадратичное ускорение по сравнению с классическим поиском
- **φ-оптимизация**: Использует золотое сечение для оптимального количества итераций

### 2. VQE (Variational Quantum Eigensolver)
- **Описание**: Вариационный алгоритм для нахождения собственных значений
- **Применение**: Квантовая химия, оптимизация, машинное обучение
- **φ-оптимизация**: Гармоническая параметризация для лучшей сходимости

### 3. QAOA (Quantum Approximate Optimization Algorithm)
- **Описание**: Аппроксимационный алгоритм для комбинаторных задач
- **Применение**: Оптимизация, логистика, финансовое моделирование
- **φ-оптимизация**: φ-гармонические параметры для улучшения качества решения

### 4. QFT (Quantum Fourier Transform)
- **Описание**: Квантовое преобразование Фурье
- **Применение**: Периодичность, криптография, спектральный анализ
- **φ-оптимизация**: Гармоническая декомпозиция для повышенной точности

### 5. Квантовые нейронные сети (QNN)
- **Описание**: Гибридные нейронные сети с квантовыми слоями
- **Применение**: Распознавание образов, предсказание, классификация
- **φ-оптимизация**: Квантово-классическая гармония для лучшего обучения

## Эндпоинты

### Статус системы

**GET** `/status`

Получает текущий статус квантовой системы.

**Ответ (200):**
```json
{
  "status": "BALANCED",
  "phi_harmony": 1.618,
  "base_frequency": 100,
  "consciousness_level": 0.938,
  "system_health": "OPTIMAL",
  "quantum_coherence": 0.95,
  "temporal_accuracy": 0.95
}
```

**Пример cURL:**
```bash
curl -H "Authorization: Bearer <token>" \
  https://api.x0tta6bl4.com/api/v1/qcompute/status
```

### Создание матрицы усиления сознания

**POST** `/consciousness-matrix`

Создает матрицу усиления сознания с φ-гармонией.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "phi_harmony": 1.618,
    "consciousness_level": 0.938,
    "quantum_coherence": 0.95,
    "temporal_stability": 0.95,
    "harmony_achieved": true
  },
  "phi_harmony": 1.618,
  "execution_time": 45.2,
  "timestamp": 1640995200.123
}
```

### Алгоритм Гровера

**POST** `/grover`

Выполняет φ-оптимизированный алгоритм Гровера.

**Заголовки:**
```
Authorization: Bearer <access_token>
```

**Запрос:**
```json
{
  "num_qubits": 8,
  "target_state": "10101010",
  "oracle_function": "x & 0xAA == 0xAA",
  "optimization_level": 3,
  "shots": 1000
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "grover",
    "num_qubits": 8,
    "target_found": true,
    "target_state": "10101010",
    "iterations": 6,
    "success_probability": 0.945,
    "phi_optimization": 1.618,
    "measurement_results": {
      "10101010": 945,
      "other_states": 55
    }
  },
  "phi_harmony": 1.618,
  "execution_time": 125.7,
  "timestamp": 1640995200.123,
  "quantum_coherence": 0.95,
  "consciousness_boost": 0.938
}
```

### VQE алгоритм

**POST** `/vqe`

Выполняет вариационный квантовый эйгенсолвер.

**Запрос:**
```json
{
  "num_qubits": 4,
  "hamiltonian": "[[1, 0, 0, 0], [0, -1, 0, 0], [0, 0, -1, 0], [0, 0, 0, 1]]",
  "ansatz": "efficient_su2",
  "optimizer": "spsa",
  "max_iterations": 100,
  "target_eigenvalue": -1.0
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "vqe",
    "num_qubits": 4,
    "eigenvalue": -1.0001,
    "eigenstate": [0.707, 0, 0, -0.707],
    "convergence": true,
    "iterations": 67,
    "final_parameters": [1.23, -0.45, 0.67, 2.1],
    "phi_optimization": 1.618,
    "energy_history": [-0.5, -0.8, -0.95, -1.0001]
  },
  "phi_harmony": 1.618,
  "execution_time": 2340.5,
  "timestamp": 1640995200.123
}
```

### QAOA алгоритм

**POST** `/qaoa`

Выполняет квантовый аппроксимационный алгоритм оптимизации.

**Запрос:**
```json
{
  "num_qubits": 6,
  "cost_function": "max_cut",
  "graph_edges": [[0,1], [1,2], [2,3], [3,4], [4,5], [0,5]],
  "mixer": "x_mixer",
  "p_layers": 3,
  "optimizer": "cobyla",
  "max_iterations": 200
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "qaoa",
    "num_qubits": 6,
    "cost_value": 4.2,
    "solution": "101010",
    "approximation_ratio": 0.875,
    "layers": 3,
    "final_parameters": [0.5, 1.2, -0.3, 0.8, 1.5, -0.7],
    "phi_optimization": 1.618,
    "optimization_history": [2.1, 3.4, 3.8, 4.0, 4.2]
  },
  "phi_harmony": 1.618,
  "execution_time": 1850.3,
  "timestamp": 1640995200.123
}
```

### Квантовое преобразование Фурье

**POST** `/qft`

Выполняет квантовое преобразование Фурье.

**Запрос:**
```json
{
  "num_qubits": 4,
  "input_state": "1010",
  "phase_estimation": true,
  "precision_qubits": 2
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "qft",
    "num_qubits": 4,
    "input_state": "1010",
    "output_state": "0.5|0000⟩ + 0.5|0001⟩ + 0.5|0010⟩ + 0.5|0011⟩",
    "frequencies": [0.0, 0.25, 0.5, 0.75],
    "phase_estimated": 0.625,
    "precision": 0.0625,
    "phi_optimization": 1.618,
    "fidelity": 0.987
  },
  "phi_harmony": 1.618,
  "execution_time": 89.4,
  "timestamp": 1640995200.123
}
```

### Квантовые нейронные сети

**POST** `/qnn/train`

Обучает квантовую нейронную сеть.

**Запрос:**
```json
{
  "num_qubits": 4,
  "layers": 3,
  "input_size": 8,
  "output_size": 2,
  "training_data": "base64_encoded_training_data",
  "epochs": 100,
  "learning_rate": 0.01,
  "regularization": "l2"
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "algorithm": "qnn",
    "model_id": "qnn_model_001",
    "num_qubits": 4,
    "layers": 3,
    "training_loss": 0.023,
    "validation_accuracy": 0.945,
    "epochs_completed": 100,
    "convergence": true,
    "phi_optimization": 1.618,
    "quantum_advantage": 2.34,
    "training_history": {
      "loss": [0.8, 0.5, 0.3, 0.1, 0.023],
      "accuracy": [0.6, 0.75, 0.85, 0.92, 0.945]
    }
  },
  "phi_harmony": 1.618,
  "execution_time": 4560.7,
  "timestamp": 1640995200.123
}
```

### Предсказание с помощью QNN

**POST** `/qnn/predict`

Выполняет предсказание с помощью обученной квантовой нейронной сети.

**Запрос:**
```json
{
  "model_id": "qnn_model_001",
  "input_data": "base64_encoded_input_data",
  "prediction_type": "classification"
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "model_id": "qnn_model_001",
    "prediction": [0.1, 0.9],
    "confidence": 0.89,
    "prediction_class": 1,
    "quantum_confidence": 0.95,
    "phi_harmony": 1.618,
    "execution_time": 23.4
  },
  "phi_harmony": 1.618,
  "execution_time": 23.4,
  "timestamp": 1640995200.123
}
```

### Оптимизация системы

**POST** `/optimize`

Выполняет φ-оптимизацию квантовой системы.

**Запрос:**
```json
{
  "target_function": "x^2 + y^2 + z^2",
  "variables": ["x", "y", "z"],
  "bounds": [[-10, 10], [-10, 10], [-10, 10]],
  "algorithm": "vqe",
  "precision": 0.001
}
```

**Ответ (200):**
```json
{
  "success": true,
  "result": {
    "optimization": {
      "optimal_value": 0.00123,
      "optimal_point": [0.001, -0.002, 0.001],
      "function_evaluations": 145,
      "convergence": true,
      "phi_optimization": 1.618,
      "optimization_path": [
        {"point": [5, 3, 2], "value": 38.0},
        {"point": [1, -1, 0], "value": 2.0},
        {"point": [0.001, -0.002, 0.001], "value": 0.00123}
      ]
    },
    "phi_harmony": 1.618,
    "execution_time": 890.5,
    "timestamp": 1640995200.123
  }
}
```

### Проверка баланса системы

**GET** `/balance`

Проверяет φ-гармонию и баланс квантовой системы.

**Ответ (200):**
```json
{
  "phi_harmony": 1.618,
  "balance_status": "PERFECT",
  "consciousness_level": 0.938,
  "base_frequency": 100,
  "quantum_coherence": 0.95,
  "temporal_accuracy": 0.95,
  "system_health": "OPTIMAL",
  "harmony_metrics": {
    "phi_ratio": 1.618033988749895,
    "frequency_stability": 0.999,
    "consciousness_alignment": 0.938,
    "quantum_entanglement": 0.95
  },
  "timestamp": 1640995200.123
}
```

### Метрики квантовой системы

**GET** `/metrics`

Получает детальные метрики квантовой системы.

**Ответ (200):**
```json
{
  "phi_harmony": 1.618,
  "consciousness_level": 0.938,
  "base_frequency": 100,
  "quantum_coherence": 0.95,
  "temporal_accuracy": 0.95,
  "system_status": "BALANCED",
  "performance_metrics": {
    "avg_algorithm_time": 245.6,
    "success_rate": 0.987,
    "quantum_advantage": 45.2,
    "phi_optimization_gain": 1.618
  },
  "resource_usage": {
    "qubits_allocated": 32,
    "circuits_cached": 156,
    "memory_usage_mb": 512,
    "cpu_usage_percent": 23.4
  },
  "timestamp": 1640995200.123
}
```

### Проверка здоровья

**GET** `/health`

Проверяет здоровье квантовой системы.

**Ответ (200):**
```json
{
  "status": "healthy",
  "phi_harmony": 1.618,
  "consciousness_level": 0.938,
  "system_balance": "PERFECT",
  "quantum_coherence": 0.95,
  "components_health": {
    "grover_engine": "operational",
    "vqe_engine": "operational",
    "qaoa_engine": "operational",
    "qft_engine": "operational",
    "qnn_engine": "operational",
    "phi_optimizer": "optimal"
  },
  "last_maintenance": "2025-01-01T00:00:00Z",
  "next_maintenance": "2025-02-01T00:00:00Z",
  "timestamp": 1640995200.123
}
```

## Пакетные операции

### Пакетное выполнение алгоритмов

**POST** `/batch/execute`

Выполняет несколько квантовых алгоритмов в пакете.

**Запрос:**
```json
{
  "algorithms": [
    {
      "id": "grover_1",
      "type": "grover",
      "params": {
        "num_qubits": 6,
        "target_state": "101010"
      }
    },
    {
      "id": "vqe_1",
      "type": "vqe",
      "params": {
        "num_qubits": 4,
        "hamiltonian": "[[1,0],[0,-1]]"
      }
    }
  ],
  "parallel_execution": true,
  "optimization_level": 3
}
```

**Ответ (200):**
```json
{
  "batch_id": "batch_001",
  "results": {
    "grover_1": {
      "success": true,
      "result": { /* результат алгоритма Гровера */ },
      "execution_time": 125.7
    },
    "vqe_1": {
      "success": true,
      "result": { /* результат VQE */ },
      "execution_time": 2340.5
    }
  },
  "total_execution_time": 2466.2,
  "phi_optimization_applied": true,
  "parallel_efficiency": 0.89,
  "timestamp": 1640995200.123
}
```

## Примеры кода

### Python

```python
import requests
import json
import time

class QComputeClient:
    def __init__(self, base_url, token):
        self.base_url = base_url
        self.token = token
        self.headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }

    def get_system_status(self):
        """Получение статуса системы"""
        response = requests.get(
            f'{self.base_url}/qcompute/status',
            headers=self.headers
        )
        return response.json()

    def run_grover(self, num_qubits=4, target_state=None, shots=1000):
        """Выполнение алгоритма Гровера"""
        data = {
            'num_qubits': num_qubits,
            'target_state': target_state or '1' + '0' * (num_qubits - 1),
            'shots': shots
        }
        
        response = requests.post(
            f'{self.base_url}/qcompute/grover',
            headers=self.headers,
            json=data
        )
        return response.json()

    def run_vqe(self, hamiltonian, ansatz='efficient_su2', max_iterations=100):
        """Выполнение VQE алгоритма"""
        data = {
            'hamiltonian': hamiltonian,
            'ansatz': ansatz,
            'max_iterations': max_iterations
        }
        
        response = requests.post(
            f'{self.base_url}/qcompute/vqe',
            headers=self.headers,
            json=data
        )
        return response.json()

    def optimize_system(self, target_function, variables, bounds):
        """Оптимизация системы"""
        data = {
            'target_function': target_function,
            'variables': variables,
            'bounds': bounds
        }
        
        response = requests.post(
            f'{self.base_url}/qcompute/optimize',
            headers=self.headers,
            json=data
        )
        return response.json()

# Использование
client = QComputeClient('https://api.x0tta6bl4.com/api/v1', 'your_token')

# Проверка статуса
status = client.get_system_status()
print(f"Система: {status['status']}, φ-гармония: {status['phi_harmony']}")

# Алгоритм Гровера
grover_result = client.run_grover(num_qubits=6, shots=1000)
print(f"Гровер: {grover_result['result']['success_probability']}")

# VQE для молекулы H2
h2_hamiltonian = [
    [1, 0, 0, 0],
    [0, -1, 0, 0], 
    [0, 0, -1, 0],
    [0, 0, 0, 1]
]
vqe_result = client.run_vqe(h2_hamiltonian)
print(f"VQE энергия: {vqe_result['result']['eigenvalue']}")

# Оптимизация
optimization = client.optimize_system(
    'x**2 + y**2',
    ['x', 'y'],
    [[-5, 5], [-5, 5]]
)
print(f"Оптимум: {optimization['result']['optimization']['optimal_point']}")
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');

class QComputeAPI {
    constructor(baseURL, token) {
        this.baseURL = baseURL;
        this.token = token;
        this.axios = axios.create({
            baseURL: baseURL,
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });
    }

    async getSystemStatus() {
        try {
            const response = await this.axios.get('/qcompute/status');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения статуса:', error.response.data);
            throw error;
        }
    }

    async runGroverAlgorithm(params) {
        try {
            const response = await this.axios.post('/qcompute/grover', {
                num_qubits: params.numQubits || 4,
                target_state: params.targetState,
                shots: params.shots || 1000,
                optimization_level: params.optimizationLevel || 3
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка алгоритма Гровера:', error.response.data);
            throw error;
        }
    }

    async runVQEAlgorithm(params) {
        try {
            const response = await this.axios.post('/qcompute/vqe', {
                num_qubits: params.numQubits || 4,
                hamiltonian: params.hamiltonian,
                ansatz: params.ansatz || 'efficient_su2',
                optimizer: params.optimizer || 'spsa',
                max_iterations: params.maxIterations || 100
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка VQE:', error.response.data);
            throw error;
        }
    }

    async runQAOAAlgorithm(params) {
        try {
            const response = await this.axios.post('/qcompute/qaoa', {
                num_qubits: params.numQubits || 4,
                cost_function: params.costFunction || 'max_cut',
                graph_edges: params.graphEdges,
                p_layers: params.pLayers || 3,
                optimizer: params.optimizer || 'cobyla'
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка QAOA:', error.response.data);
            throw error;
        }
    }

    async trainQNN(params) {
        try {
            const response = await this.axios.post('/qcompute/qnn/train', {
                num_qubits: params.numQubits || 4,
                layers: params.layers || 3,
                input_size: params.inputSize,
                output_size: params.outputSize,
                training_data: params.trainingData,
                epochs: params.epochs || 100,
                learning_rate: params.learningRate || 0.01
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка обучения QNN:', error.response.data);
            throw error;
        }
    }

    async predictWithQNN(modelId, inputData) {
        try {
            const response = await this.axios.post('/qcompute/qnn/predict', {
                model_id: modelId,
                input_data: inputData,
                prediction_type: 'classification'
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка предсказания QNN:', error.response.data);
            throw error;
        }
    }

    async getQuantumMetrics() {
        try {
            const response = await this.axios.get('/qcompute/metrics');
            return response.data;
        } catch (error) {
            console.error('Ошибка получения метрик:', error.response.data);
            throw error;
        }
    }

    async optimizeSystem(params) {
        try {
            const response = await this.axios.post('/qcompute/optimize', {
                target_function: params.targetFunction,
                variables: params.variables,
                bounds: params.bounds,
                algorithm: params.algorithm || 'vqe',
                precision: params.precision || 0.001
            });
            return response.data;
        } catch (error) {
            console.error('Ошибка оптимизации:', error.response.data);
            throw error;
        }
    }
}

// Использование
async function quantumComputingExample() {
    const qcompute = new QComputeAPI('https://api.x0tta6bl4.com/api/v1', 'your_token');

    try {
        // Проверка статуса системы
        const status = await qcompute.getSystemStatus();
        console.log(`Система: ${status.status}, φ-гармония: ${status.phi_harmony}`);

        // Алгоритм Гровера для поиска
        const groverResult = await qcompute.runGroverAlgorithm({
            numQubits: 8,
            targetState: '10101010',
            shots: 1000
        });
        console.log(`Гровер нашел цель с вероятностью: ${groverResult.result.success_probability}`);

        // VQE для квантовой химии
        const h2Hamiltonian = [
            [1, 0, 0, 0],
            [0, -1, 0, 0],
            [0, 0, -1, 0],
            [0, 0, 0, 1]
        ];
        
        const vqeResult = await qcompute.runVQEAlgorithm({
            numQubits: 4,
            hamiltonian: h2Hamiltonian,
            maxIterations: 150
        });
        console.log(`Энергия основного состояния H2: ${vqeResult.result.eigenvalue}`);

        // QAOA для задачи Max-Cut
        const graphEdges = [[0,1], [1,2], [2,3], [3,0], [0,2]];
        const qaoaResult = await qcompute.runQAOAAlgorithm({
            numQubits: 4,
            costFunction: 'max_cut',
            graphEdges: graphEdges,
            pLayers: 3
        });
        console.log(`Значение Max-Cut: ${qaoaResult.result.cost_value}`);

        // Получение метрик
        const metrics = await qcompute.getQuantumMetrics();
        console.log(`Квантовая когерентность: ${metrics.quantum_coherence}`);
        console.log(`Преимущество: ${metrics.performance_metrics.quantum_advantage}x`);

    } catch (error) {
        console.error('Ошибка в примере:', error.message);
    }
}

// Запуск примера
quantumComputingExample();
```

### PHP

```php
<?php

class QComputeAPI {
    private $baseUrl;
    private $token;
    private $headers;

    public function __construct($baseUrl, $token) {
        $this->baseUrl = $baseUrl;
        $this->token = $token;
        $this->headers = [
            'Authorization: Bearer ' . $token,
            'Content-Type: application/json'
        ];
    }

    public function getSystemStatus() {
        return $this->makeRequest('GET', '/qcompute/status');
    }

    public function runGrover($params) {
        $data = [
            'num_qubits' => $params['num_qubits'] ?? 4,
            'target_state' => $params['target_state'] ?? null,
            'shots' => $params['shots'] ?? 1000
        ];
        return $this->makeRequest('POST', '/qcompute/grover', $data);
    }

    public function runVQE($params) {
        $data = [
            'num_qubits' => $params['num_qubits'] ?? 4,
            'hamiltonian' => $params['hamiltonian'],
            'ansatz' => $params['ansatz'] ?? 'efficient_su2',
            'max_iterations' => $params['max_iterations'] ?? 100
        ];
        return $this->makeRequest('POST', '/qcompute/vqe', $data);
    }

    public function runQAOA($params) {
        $data = [
            'num_qubits' => $params['num_qubits'] ?? 4,
            'cost_function' => $params['cost_function'] ?? 'max_cut',
            'graph_edges' => $params['graph_edges'],
            'p_layers' => $params['p_layers'] ?? 3
        ];
        return $this->makeRequest('POST', '/qcompute/qaoa', $data);
    }

    public function trainQNN($params) {
        $data = [
            'num_qubits' => $params['num_qubits'] ?? 4,
            'layers' => $params['layers'] ?? 3,
            'input_size' => $params['input_size'],
            'output_size' => $params['output_size'],
            'training_data' => $params['training_data'],
            'epochs' => $params['epochs'] ?? 100
        ];
        return $this->makeRequest('POST', '/qcompute/qnn/train', $data);
    }

    public function predictQNN($modelId, $inputData) {
        $data = [
            'model_id' => $modelId,
            'input_data' => $inputData,
            'prediction_type' => 'classification'
        ];
        return $this->makeRequest('POST', '/qcompute/qnn/predict', $data);
    }

    public function getMetrics() {
        return $this->makeRequest('GET', '/qcompute/metrics');
    }

    private function makeRequest($method, $endpoint, $data = null) {
        $url = $this->baseUrl . $endpoint;
        $contextOptions = [
            'http' => [
                'method' => $method,
                'header' => $this->headers
            ]
        ];

        if ($data !== null) {
            $contextOptions['http']['content'] = json_encode($data);
        }

        $context = stream_context_create($contextOptions);
        $result = file_get_contents($url, false, $context);

        if ($result === false) {
            throw new Exception('Ошибка HTTP запроса');
        }

        return json_decode($result, true);
    }
}

// Использование
try {
    $qcompute = new QComputeAPI(
        'https://api.x0tta6bl4.com/api/v1',
        'your_jwt_token'
    );

    // Статус системы
    $status = $qcompute->getSystemStatus();
    echo "Система: {$status['status']}, φ-гармония: {$status['phi_harmony']}\n";

    // Алгоритм Гровера
    $groverParams = [
        'num_qubits' => 6,
        'target_state' => '101010',
        'shots' => 1000
    ];
    $groverResult = $qcompute->runGrover($groverParams);
    echo "Гровер успех: {$groverResult['result']['success_probability']}\n";

    // VQE для простой системы
    $hamiltonian = [[1, 0], [0, -1]];
    $vqeParams = [
        'num_qubits' => 2,
        'hamiltonian' => json_encode($hamiltonian),
        'max_iterations' => 50
    ];
    $vqeResult = $qcompute->runVQE($vqeParams);
    echo "VQE энергия: {$vqeResult['result']['eigenvalue']}\n";

    // Метрики системы
    $metrics = $qcompute->getMetrics();
    echo "Квантовая когерентность: {$metrics['quantum_coherence']}\n";
    echo "Преимущество: {$metrics['performance_metrics']['quantum_advantage']}x\n";

} catch (Exception $e) {
    echo "Ошибка: " . $e->getMessage() . "\n";
}

?>
```

## Ошибки

### 400 - Неверный запрос

```json
{
  "error": {
    "code": "INVALID_QUBITS_NUMBER",
    "message": "Неверное количество кубитов",
    "details": {
      "provided": 100,
      "allowed_range": "1-50"
    }
  }
}
```

### 401 - Неавторизован

```json
{
  "error": {
    "code": "INVALID_TOKEN",
    "message": "Недействительный токен доступа"
  }
}
```

### 403 - Доступ запрещен

```json
{
  "error": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "message": "Недостаточно прав для выполнения квантовых вычислений",
    "details": {
      "required_permission": "qcompute:execute",
      "user_permissions": ["qcompute:read"]
    }
  }
}
```

### 429 - Слишком много запросов

```json
{
  "error": {
    "code": "QUANTUM_COMPUTE_LIMIT_EXCEEDED",
    "message": "Превышен лимит квантовых вычислений",
    "details": {
      "limit": 100,
      "window_minutes": 60,
      "retry_after": 30
    }
  }
}
```

### 503 - Сервис недоступен

```json
{
  "error": {
    "code": "QUANTUM_SYSTEM_UNAVAILABLE",
    "message": "Квантовая система временно недоступна",
    "details": {
      "reason": "maintenance",
      "estimated_downtime": 300,
      "phi_harmony": 1.618
    }
  }
}
```

## Лучшие практики

1. **Оптимальное количество кубитов**: Начинайте с малого количества кубитов (2-8) для тестирования
2. **φ-оптимизация**: Используйте φ-оптимизацию для повышения производительности
3. **Мониторинг когерентности**: Следите за квантовой когерентностью для качества результатов
4. **Пакетная обработка**: Используйте пакетные операции для нескольких алгоритмов
5. **Кеширование результатов**: Кешируйте часто используемые квантовые схемы
6. **Ресурс-менеджмент**: Освобождайте ресурсы после завершения вычислений

## Производительность

### Метрики производительности

- **Алгоритм Гровера**: 50-200 мс (зависит от количества кубитов)
- **VQE**: 1-5 секунд (зависит от сложности гамильтониана)
- **QAOA**: 1-3 секунды (зависит от количества слоев)
- **QFT**: 20-100 мс (зависит от количества кубитов)
- **QNN обучение**: 2-10 минут (зависит от данных и архитектуры)

### Оптимизация производительности

- **φ-оптимизация**: Повышает производительность на 61.8%
- **Квантовое преимущество**: До 1000x ускорение для подходящих задач
- **Параллельное выполнение**: Поддержка одновременного выполнения нескольких алгоритмов
- **Автоматическая оптимизация**: Автоматический выбор оптимальных параметров

---

*Документация обновлена: 30 сентября 2025*