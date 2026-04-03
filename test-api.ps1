# Script de Testes - Sistema de Clínica (PowerShell)
# Teste de integração para validar correções

$API_URL = "http://localhost:8082"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "🧪 Testes da API de Médicos" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Teste 1: Listar médicos (vazio inicial)
Write-Host ""
Write-Host "📋 Teste 1: GET /doctors (lista vazia inicial)" -ForegroundColor Yellow
Write-Host "---" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$API_URL/doctors" -Method GET -ErrorAction SilentlyContinue
    $response.Content | ConvertFrom-Json | ConvertTo-Json
    Write-Host "✅ Status: OK (200)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

# Teste 2: Criar Dr. João Silva
Write-Host ""
Write-Host "➕ Teste 2: POST /doctors (criar Dr. João Silva)" -ForegroundColor Yellow
Write-Host "---" -ForegroundColor Gray
$body = @{
    name = "Dr. João Silva"
    specialty = "Cardiologia"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$API_URL/doctors" -Method POST `
        -ContentType "application/json" `
        -Body $body `
        -ErrorAction SilentlyContinue
    $data = $response.Content | ConvertFrom-Json
    $data | ConvertTo-Json
    $doctorId = $data.id
    Write-Host "✅ Status: Criado com sucesso (ID: $doctorId)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

# Teste 3: Criar Dra. Maria Santos
Write-Host ""
Write-Host "➕ Teste 3: POST /doctors (criar Dra. Maria Santos)" -ForegroundColor Yellow
Write-Host "---" -ForegroundColor Gray
$body2 = @{
    name = "Dra. Maria Santos"
    specialty = "Pediatria"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$API_URL/doctors" -Method POST `
        -ContentType "application/json" `
        -Body $body2 `
        -ErrorAction SilentlyContinue
    $response.Content | ConvertFrom-Json | ConvertTo-Json
    Write-Host "✅ Status: Criado com sucesso" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

# Teste 4: Listar médicos (com 2 registros)
Write-Host ""
Write-Host "📋 Teste 4: GET /doctors (lista com 2 médicos)" -ForegroundColor Yellow
Write-Host "---" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$API_URL/doctors" -Method GET -ErrorAction SilentlyContinue
    $data = $response.Content | ConvertFrom-Json
    $data | ConvertTo-Json
    Write-Host "✅ Quantidade de registros: $($data.Count)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

# Teste 5: Buscar por especialidade
Write-Host ""
Write-Host "🔍 Teste 5: GET /doctors/search?specialty=Cardiologia" -ForegroundColor Yellow
Write-Host "---" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "$API_URL/doctors/search?specialty=Cardiologia" -Method GET -ErrorAction SilentlyContinue
    $data = $response.Content | ConvertFrom-Json
    $data | ConvertTo-Json
    Write-Host "✅ Filtro aplicado com sucesso" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}

# Teste 6: Acessar Dashboard
Write-Host ""
Write-Host "🌐 Teste 6: Acessar Admin Dashboard" -ForegroundColor Yellow
Write-Host "---" -ForegroundColor Gray
Write-Host "Acesse: http://localhost:8082/adminDashboard/token123" -ForegroundColor Cyan
Write-Host "e teste a funcionalidade 'Add Doctor' no navegador." -ForegroundColor Cyan

Write-Host ""
Write-Host "✅ Testes Concluídos!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

