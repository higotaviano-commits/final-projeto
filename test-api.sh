#!/bin/bash
# Script de Testes - Sistema de Clínica

echo "============================================"
echo "🧪 Testes da API de Médicos"
echo "============================================"

API_URL="http://localhost:8082"

echo ""
echo "📋 Teste 1: GET /doctors (lista vazia inicial)"
echo "---"
curl -s "$API_URL/doctors" | jq . || echo "[]"

echo ""
echo "➕ Teste 2: POST /doctors (criar Dr. João Silva)"
echo "---"
RESPONSE=$(curl -s -X POST "$API_URL/doctors" \
  -H "Content-Type: application/json" \
  -d '{"name":"Dr. João Silva","specialty":"Cardiologia"}')
echo "$RESPONSE" | jq .
DOCTOR_ID=$(echo "$RESPONSE" | jq -r '.id // empty')
echo "ID do médico criado: $DOCTOR_ID"

echo ""
echo "➕ Teste 3: POST /doctors (criar Dra. Maria Santos)"
echo "---"
RESPONSE2=$(curl -s -X POST "$API_URL/doctors" \
  -H "Content-Type: application/json" \
  -d '{"name":"Dra. Maria Santos","specialty":"Pediatria"}')
echo "$RESPONSE2" | jq .

echo ""
echo "📋 Teste 4: GET /doctors (lista com 2 médicos)"
echo "---"
curl -s "$API_URL/doctors" | jq .

echo ""
echo "🔍 Teste 5: GET /doctors/search?specialty=Cardiologia"
echo "---"
curl -s "$API_URL/doctors/search?specialty=Cardiologia" | jq .

echo ""
echo "✅ Testes Concluídos!"
echo "============================================"

