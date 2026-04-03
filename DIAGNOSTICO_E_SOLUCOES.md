# 📋 Diagnóstico e Soluções - Sistema de Clínica

## ❌ Problemas Encontrados

### 1. **Entidades sem Getters/Setters**
- **Arquivo**: `Doctor.java`, `Patient.java`, `Appointment.java`
- **Problema**: Faltavam getters, setters e construtores
- **Impacto**: JPA/Hibernate não conseguiam serializar/desserializar objetos JSON
- **Sintoma**: POST retornava sucesso mas nada era salvo; GET retornava vazio `[]`

### 2. **Dependências JJWT Ausentes**
- **Arquivo**: `pom.xml`
- **Problema**: TokenService importava `io.jsonwebtoken` mas não havia dependências
- **Impacto**: Falha na compilação

### 3. **MongoDB Obrigatório ao Iniciar**
- **Problema**: Aplicação tentava conectar ao MongoDB mesmo sem usá-lo
- **Impacto**: Aplicação não iniciava se MongoDB não estivesse rodando

### 4. **Security Habilitada por Padrão**
- **Problema**: Endpoints retornavam 401 Unauthorized
- **Impacto**: Não era possível testar endpoints sem autenticação

## ✅ Soluções Aplicadas

### 1. **Adicionadas Anotações Lombok**

#### Doctor.java
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Size(min = 3)
    private String name;
    
    @NotNull
    private String specialty;
    
    @Email
    private String email;
    
    @ElementCollection
    private List<String> availableTimes;
}
```

#### Patient.java
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    private String name;
    
    @Email
    private String email;
    
    private String phone;
}
```

#### Appointment.java
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    private Doctor doctor;
    
    @ManyToOne
    private Patient patient;
    
    @Future
    private LocalDateTime appointmentTime;
    
    private int status;
    
    @Transient
    public LocalDateTime getEndTime() {
        return appointmentTime.plusHours(1);
    }
}
```

### 2. **Adicionadas Dependências JWT** (pom.xml)
```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.6</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.6</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.6</version>
    <scope>runtime</scope>
</dependency>
```

### 3. **Corrigida TokenService.java**
```java
public class TokenService {
    private final SecretKey key = Keys.hmacShaKeyFor(
        "mySecretKeyThatIsAtLeast32CharactersLong!".getBytes()
    );

    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .signWith(key)
                .compact();
    }

    public String validateToken(String token) {
        return Jwts.parser()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }
}
```

### 4. **Desabilitadas Auto-configurações** (application.properties)
```properties
spring.autoconfigure.exclude=\
  org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration,\
  org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration

server.port=8082

spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.username=sa
spring.datasource.password=

spring.jpa.hibernate.ddl-auto=update

spring.data.mongodb.uri=mongodb://localhost:27017/clinic

spring.thymeleaf.cache=false
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
```

### 5. **Banco de Dados H2** (pom.xml)
```xml
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>
```

## 🔄 Fluxo Correto Agora

```
Frontend (admin.js)
    ↓
POST /doctors {name, specialty}
    ↓
DoctorController.create()
    ↓
DoctorService.save()
    ↓
DoctorRepository.save()
    ↓
Hibernate (com getters/setters) → H2 Database
    ↓
Response JSON com ID gerado
    ↓
Frontend recarrega: GET /doctors
    ↓
DoctorController.getAll()
    ↓
DoctorRepository.findAll()
    ↓
H2 Database retorna lista
    ↓
Frontend renderiza na UI
```

## 📝 Stack Atual

- **Framework**: Spring Boot 4.0.5
- **Database**: H2 (em memória)
- **ORM**: Hibernate
- **Security**: JWT (desabilitado por padrão em dev)
- **Frontend**: HTML + JavaScript vanilla
- **Build**: Maven

## 🚀 Como Testar

### 1. Iniciar a aplicação
```bash
cd C:\projetos\clinic\clinic-system
.\mvnw.cmd spring-boot:run
```

### 2. Acessar o Dashboard
```
http://localhost:8082/templates/admin/adminDashboard.html
```

### 3. Testar API via cURL

**POST - Criar médico:**
```bash
curl -X POST http://localhost:8082/doctors \
  -H "Content-Type: application/json" \
  -d '{"name":"Dr. João Silva","specialty":"Cardiologia"}'
```

**GET - Listar médicos:**
```bash
curl -X GET http://localhost:8082/doctors
```

**GET - Buscar por especialidade:**
```bash
curl -X GET "http://localhost:8082/doctors/search?specialty=Cardiologia"
```

## ✨ Resultado Esperado

✅ POST /doctors salva novo médico no banco de dados
✅ GET /doctors retorna lista com os médicos salvos
✅ Frontend atualiza automaticamente após salvar
✅ Sem erros 401 Unauthorized
✅ Sem necessidade de MongoDB rodando

## 📦 Próximos Passos (Recomendados)

1. **Implementar Paginação** em GET /doctors
2. **Adicionar DELETE** /doctors/{id}
3. **Adicionar UPDATE** /doctors/{id}
4. **Validação de Entrada** mais robusta
5. **Tratamento de Erros** no Frontend
6. **CORS** para production
7. **Autenticação JWT** habilitada em production
8. **Testes Unitários** para Services
9. **Testes de Integração** para Controllers


