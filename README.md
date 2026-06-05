# duckia

Backend base con `Node + Express`, MySQL/MariaDB y consumo de MiniMax M2.5 por OpenRouter.

Incluye una interfaz web ligera en `/` para probar el chat y consultar sesiones guardadas.

## Esquema inicial en `duck`

Antes de la lógica de servidor se propone este esquema:

- `llm_conversations`: sesiones de conversación.
- `llm_messages`: mensajes por conversación con métricas de tokens.
- `llm_requests`: bitácora de llamadas al proveedor para diagnóstico y latencia.

El script está en `sql/duck.sql` y crea la base `duck` si no existe.

## Variables de entorno

1. Copia `.env.example` a `.env`.
2. Configura tu clave en `OPENROUTER_API_KEY`.
3. Mantén `DB_DATABASE=duck`.

## Ejecutar

```bash
npm install
npm run dev
```

Para inicializar la base de datos:

```bash
mysql -u root -p duck < sql/duck.sql
```

## Endpoints

### Health

```http
GET /api/health
```

### Frontend de prueba

```http
GET /
```

Abre una interfaz simple para enviar prompts, crear sesiones y revisar historial persistido en `duck`.

### Chat con MiniMax M2.5

```http
POST /api/llm/chat
Content-Type: application/json

{
  "sessionId": "demo-session",
  "historyLimit": 20,
  "prompt": "Dame un resumen técnico de esta API"
}
```

Notas:

- Si `sessionId` ya existe, el endpoint reconstruye contexto desde `duck` y lo reenvia al modelo.
- `historyLimit` limita la cantidad de mensajes historicos usados para controlar costo y latencia.

Respuesta esperada:

```json
{
  "sessionId": "demo-session",
  "model": "minimax/minimax-m2.5-chat",
  "reply": "...",
  "usage": {
    "prompt_tokens": 0,
    "completion_tokens": 0,
    "total_tokens": 0
  }
}
```

### Listar conversaciones

```http
GET /api/llm/conversations?limit=20
```

### Ver mensajes de una conversacion

```http
GET /api/llm/conversations/demo-session/messages?limit=50
```
