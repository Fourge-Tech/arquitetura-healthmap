# CareOS (Tabia Health) — API Reference

Artefatos de exploração e integração da API CareOS gerados durante análise para a POC Tabia IS.

---

## Swagger UI

Visualização interativa de todos os endpoints da API CareOS.

🔗 **https://fourge-tech.github.io/arquitetura-healthmap/swagger-tabia.html**

- Fonte: `openapi-careos-simple.json` (OpenAPI 3.0.1, fornecido pela Tabia Health)
- Autenticação: header `api-key`
- Ambiente de produção: `https://app.tabia.health`
- Ambiente de staging: `https://staging.tabia.health`

> O Swagger é somente visualização — requests reais devem ser feitos via Postman ou curl (CORS bloqueia chamadas diretas do browser).

---

## Collection Postman — Tabia IS

Arquivo: `Tabia-IS.postman_collection.json`

### Como importar

1. Abra o Postman
2. **Import** → selecione o arquivo `Tabia-IS.postman_collection.json`
3. A `api-key` já está pré-configurada nas variáveis da collection

### Variáveis da collection

| Variável | Valor padrão |
|---|---|
| `baseUrl` | `https://app.tabia.health` |
| `apiKey` | chave de acesso Tabia |

### Endpoints mapeados

| Pasta | Método | Endpoint |
|---|---|---|
| **Patient** | GET | `/apiv1/patient` |
| | GET | `/apiv1/patient/{id}` |
| | GET | `/apiv1/patient/{id}/data-on-current-organization` |
| **Event** | GET | `/apiv1/event` |
| | POST | `/apiv1/event` |
| | GET | `/apiv1/event-metric` |
| **Individual Care Plan** | GET | `/apiv1/individual-care-plan` |
| | POST | `/apiv1/individual-care-plan/batch` |
| **Pathway** | GET | `/apiv1/pathway` |
| **Task** | GET | `/apiv1/task` |
| | POST | `/apiv1/task` |
| | POST | `/apiv1/task/{id}/status` |
| **Message** | POST | `/apiv1/message/send` |
| **Survey** | GET | `/apiv1/survey/{id}` |
| | GET | `/apiv1/survey/{id}/details` |
| | GET | `/apiv1/survey/{id}/stats` |
| | GET | `/apiv1/survey/{id}/applications` |
| | POST | `/apiv1/survey/{id}/applications` |
| | GET | `/apiv1/surveydata/{uid}` |
| **Appointment** | GET | `/apiv1/appointment-no-show-risk/stats` |
| **User** | GET | `/apiv1/user` |
| | GET | `/apiv1/user/search` |

---

## Achados da exploração real da API

Testes realizados com chave de acesso em `https://app.tabia.health`:

### `tabiaScore` vem na listagem de pacientes ✅

O campo `tabiaScore` — incluindo `severity` — é retornado diretamente em `GET /apiv1/patient`, sem necessidade de chamar o detalhe. Isso elimina a necessidade de endpoint dedicado de risco.

```json
"tabiaScore": {
  "severity": 0.857,
  "severityRaw": 1.0,
  "timeliness": 0.571,
  "assertiveness": 1.0,
  "responsiveness": 0.733
}
```

### `extensions` é campo esparso ⚠️

O campo `extensions: Map<String,String>` (onde seria armazenado o CPF via `extensions.cpf`) não aparece no JSON quando vazio — é omitido. Os pacientes de teste não possuem extensões gravadas.

### Busca por CPF — pendente confirmação Tabia ❓

O parâmetro `search` de `GET /apiv1/patient` existe, mas não está documentado se suporta busca por campos de `extensions`. Pergunta pendente para a Tabia:

> *"O parâmetro `search` ou `structuredSearch` suporta filtrar pacientes por `extensions.cpf`?"*

### Spec `openapi-careos-simple.json` é versão reduzida ⚠️

Não há endpoints de criação/atualização de paciente (`POST /apiv1/patient`, `PUT /apiv1/patient/{id}`) no spec fornecido. O spec completo deve ser solicitado à Tabia para cobrir o fluxo de cadastro com CPF.

---

## curl de referência

```bash
# Listar pacientes
curl -X GET "https://app.tabia.health/apiv1/patient?page=0&size=10" \
  -H "api-key: <sua-chave>" \
  -H "Accept: application/json"

# Detalhe do paciente
curl -X GET "https://app.tabia.health/apiv1/patient/448266" \
  -H "api-key: <sua-chave>" \
  -H "Accept: application/json"

# Busca por CPF (a validar)
curl -X GET "https://app.tabia.health/apiv1/patient?search=00000000000" \
  -H "api-key: <sua-chave>" \
  -H "Accept: application/json"
```
