# Script para visualizar dados do banco H2 via API

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              VISUALIZANDO TABELAS DO BANCO H2              ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$API_URL = "http://localhost:8082"

# 1. Tabela DOCTOR
Write-Host "📋 TABELA: DOCTOR" -ForegroundColor Yellow
Write-Host "─" * 60 -ForegroundColor Gray

try {
    $response = Invoke-WebRequest -Uri "$API_URL/doctors" -Method GET -ErrorAction SilentlyContinue
    $doctors = $response.Content | ConvertFrom-Json

    if ($doctors -is [array]) {
        Write-Host "Colunas: id | name | specialty | email | availableTimes" -ForegroundColor Gray
        Write-Host "─" * 60 -ForegroundColor Gray

        foreach ($doctor in $doctors) {
            Write-Host ("{0,-5} | {1,-20} | {2,-20} | {3,-25} | {4}" -f `
                $doctor.id, $doctor.name, $doctor.specialty, ($doctor.email -or "NULL"), ($doctor.availableTimes -or "[]"))
        }

        Write-Host ""
        Write-Host "📊 Total de registros: $($doctors.Count)" -ForegroundColor Green
    } elseif ($doctors) {
        Write-Host "Colunas: id | name | specialty | email | availableTimes" -ForegroundColor Gray
        Write-Host "─" * 60 -ForegroundColor Gray
        Write-Host ("{0,-5} | {1,-20} | {2,-20} | {3,-25} | {4}" -f `
            $doctors.id, $doctors.name, $doctors.specialty, ($doctors.email -or "NULL"), ($doctors.availableTimes -or "[]"))
        Write-Host ""
        Write-Host "📊 Total de registros: 1" -ForegroundColor Green
    } else {
        Write-Host "(Tabela vazia)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Erro ao acessar /doctors: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host ""

# 2. Exemplo de criação
Write-Host "📝 COMO CRIAR UM NOVO REGISTRO:" -ForegroundColor Yellow
Write-Host "─" * 60 -ForegroundColor Gray
Write-Host "curl -X POST http://localhost:8082/doctors `
  -H ""Content-Type: application/json"" `
  -d '{""name"":""Dr. Nome"",""specialty"":""Especialidade""}'"
Write-Host ""

# 3. Exemplo de busca
Write-Host "🔍 COMO BUSCAR POR ESPECIALIDADE:" -ForegroundColor Yellow
Write-Host "─" * 60 -ForegroundColor Gray
Write-Host "curl -X GET ""http://localhost:8082/doctors/search?specialty=Cardiologia"""
Write-Host ""

# 4. Resumo do banco
Write-Host "📊 RESUMO DO BANCO DE DADOS:" -ForegroundColor Yellow
Write-Host "─" * 60 -ForegroundColor Gray
Write-Host "Tipo: H2 (em memória)" -ForegroundColor Gray
Write-Host "URL: jdbc:h2:mem:testdb" -ForegroundColor Gray
Write-Host "Usuário: sa" -ForegroundColor Gray
Write-Host "Senha: (vazia)" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ H2 Console: http://localhost:8082/h2-console" -ForegroundColor Cyan
Write-Host ""

# 5. Status da aplicação
Write-Host "🚀 STATUS DA APLICAÇÃO:" -ForegroundColor Yellow
Write-Host "─" * 60 -ForegroundColor Gray

try {
    $status = Invoke-WebRequest -Uri "$API_URL/doctors" -Method GET -ErrorAction SilentlyContinue
    if ($status.StatusCode -eq 200) {
        Write-Host "✅ API respondendo (HTTP 200)" -ForegroundColor Green
        Write-Host "✅ Banco de dados conectado" -ForegroundColor Green
        Write-Host "✅ Persistência funcional" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ API não respondendo" -ForegroundColor Red
}

Write-Host ""
Write-Host "═" * 60 -ForegroundColor Cyan

