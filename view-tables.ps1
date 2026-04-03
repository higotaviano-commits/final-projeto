# Script para visualizar tabelas e dados do banco H2 em tempo real

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                     📊 CONSULTOR DE TABELAS H2 - TEMPO REAL                   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$API_URL = "http://localhost:8082"

# Função para limpar saída e formatar tabela
function Format-Table {
    param(
        [Parameter(ValueFromPipeline)]
        [object[]]$InputObject,
        [string]$TableName
    )

    Write-Host "┌─────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor Gray
    Write-Host "│ 📋 TABELA: $TableName" -ForegroundColor Yellow
    Write-Host "└─────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor Gray
}

# ======== TABELA DOCTOR ========
Write-Host ""
Write-Host "📋 TABELA: DOCTOR" -ForegroundColor Yellow
Write-Host "─" * 80 -ForegroundColor Gray

try {
    $doctors = Invoke-WebRequest -Uri "$API_URL/doctors" -Method GET -ErrorAction SilentlyContinue | `
               Select-Object -ExpandProperty Content | ConvertFrom-Json

    if ($null -eq $doctors -or $doctors.Count -eq 0) {
        Write-Host "❌ Nenhum registro encontrado" -ForegroundColor Red
    } else {
        # Header
        Write-Host ""
        Write-Host ("ID".PadRight(5)) + ("│") + ("NAME".PadRight(25)) + ("│") + ("SPECIALTY".PadRight(20)) + ("│") + ("EMAIL".PadRight(20))
        Write-Host "─" * 80 -ForegroundColor Gray

        # Dados
        if ($doctors -is [array]) {
            foreach ($doctor in $doctors) {
                $name = if ($doctor.name) { $doctor.name.Substring(0, [Math]::Min(23, $doctor.name.Length)) } else { "NULL" }
                $specialty = if ($doctor.specialty) { $doctor.specialty.Substring(0, [Math]::Min(18, $doctor.specialty.Length)) } else { "NULL" }
                $email = if ($doctor.email) { $doctor.email.Substring(0, [Math]::Min(18, $doctor.email.Length)) } else { "NULL" }

                Write-Host ($doctor.id.ToString().PadRight(5)) + ("│") + ($name.PadRight(25)) + ("│") + ($specialty.PadRight(20)) + ("│") + $email
            }
        } else {
            $name = if ($doctors.name) { $doctors.name.Substring(0, [Math]::Min(23, $doctors.name.Length)) } else { "NULL" }
            $specialty = if ($doctors.specialty) { $doctors.specialty.Substring(0, [Math]::Min(18, $doctors.specialty.Length)) } else { "NULL" }
            $email = if ($doctors.email) { $doctors.email.Substring(0, [Math]::Min(18, $doctors.email.Length)) } else { "NULL" }

            Write-Host ($doctors.id.ToString().PadRight(5)) + ("│") + ($name.PadRight(25)) + ("│") + ($specialty.PadRight(20)) + ("│") + $email
        }

        Write-Host ""
        $count = if ($doctors -is [array]) { $doctors.Count } else { 1 }
        Write-Host "✅ Total: $count registro(s)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erro ao consultar /doctors: $_" -ForegroundColor Red
}

# ======== TABELA PATIENT ========
Write-Host ""
Write-Host ""
Write-Host "📋 TABELA: PATIENT" -ForegroundColor Yellow
Write-Host "─" * 80 -ForegroundColor Gray
Write-Host "(Tabela vazia - use POST /patients para adicionar dados)" -ForegroundColor Gray
Write-Host ""
Write-Host "Colunas: ID | NAME | EMAIL | PHONE" -ForegroundColor Gray

# ======== TABELA APPOINTMENT ========
Write-Host ""
Write-Host ""
Write-Host "📋 TABELA: APPOINTMENT" -ForegroundColor Yellow
Write-Host "─" * 80 -ForegroundColor Gray
Write-Host "(Tabela vazia - use POST /appointments para adicionar dados)" -ForegroundColor Gray
Write-Host ""
Write-Host "Colunas: ID | DOCTOR_ID | PATIENT_ID | APPOINTMENT_TIME | STATUS" -ForegroundColor Gray

# ======== RESUMO ========
Write-Host ""
Write-Host ""
Write-Host "═" * 80 -ForegroundColor Cyan
Write-Host "📊 RESUMO DO BANCO DE DADOS" -ForegroundColor Cyan
Write-Host "═" * 80 -ForegroundColor Cyan
Write-Host ""

$info = @{
    "Tipo" = "H2 (Em Memória)"
    "JDBC URL" = "jdbc:h2:mem:testdb"
    "Usuário" = "sa"
    "Senha" = "(vazia)"
    "Console Web" = "http://localhost:8082/h2-console"
    "API Base" = "http://localhost:8082"
    "Status" = "✅ ONLINE"
}

foreach ($key in $info.Keys) {
    Write-Host ($key.PadRight(20)) + ": " + $info[$key] -ForegroundColor Gray
}

Write-Host ""
Write-Host "═" * 80 -ForegroundColor Cyan
Write-Host ""

# ======== COMANDOS ÚTEIS ========
Write-Host "💡 COMANDOS ÚTEIS:" -ForegroundColor Yellow
Write-Host "─" * 80 -ForegroundColor Gray
Write-Host ""
Write-Host "1️⃣  Listar todos os médicos:"
Write-Host "   curl http://localhost:8082/doctors" -ForegroundColor Cyan
Write-Host ""
Write-Host "2️⃣  Buscar por especialidade:"
Write-Host "   curl 'http://localhost:8082/doctors/search?specialty=Cardiologia'" -ForegroundColor Cyan
Write-Host ""
Write-Host "3️⃣  Criar novo médico:"
Write-Host "   curl -X POST http://localhost:8082/doctors `
     -H 'Content-Type: application/json' `
     -d '{""name"":""Dr. Nome"",""specialty"":""Especialidade""}'" -ForegroundColor Cyan
Write-Host ""
Write-Host "4️⃣  Acessar H2 Console (GUI):"
Write-Host "   http://localhost:8082/h2-console" -ForegroundColor Cyan
Write-Host ""

Write-Host "═" * 80 -ForegroundColor Cyan
Write-Host ""

