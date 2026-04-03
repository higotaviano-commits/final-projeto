import java.sql.*;

public class H2TableViewer {
    public static void main(String[] args) {
        String url = "jdbc:h2:mem:testdb";
        String user = "sa";
        String password = "";

        try {
            Class.forName("org.h2.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);

            System.out.println("╔══════════════════════════════════════════════════════════╗");
            System.out.println("║              TABELAS DO BANCO DE DADOS H2               ║");
            System.out.println("╚══════════════════════════════════════════════════════════╝\n");

            // Listar todas as tabelas
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(null, "PUBLIC", null, new String[]{"TABLE"});

            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                System.out.println("📋 Tabela: " + tableName);
                System.out.println("─".repeat(60));

                // Listar colunas da tabela
                ResultSet columns = metaData.getColumns(null, "PUBLIC", tableName, null);
                System.out.println("Colunas:");
                while (columns.next()) {
                    String columnName = columns.getString("COLUMN_NAME");
                    String columnType = columns.getString("TYPE_NAME");
                    String nullable = "YES".equals(columns.getString("IS_NULLABLE")) ? "✓" : "✗";
                    System.out.println(String.format("  • %-20s %-15s (nullable: %s)", columnName, columnType, nullable));
                }

                // Listar dados da tabela
                System.out.println("\nDados:");
                Statement stmt = conn.createStatement();
                ResultSet data = stmt.executeQuery("SELECT * FROM " + tableName);
                ResultSetMetaData rsMetaData = data.getMetaData();
                int columnCount = rsMetaData.getColumnCount();

                // Header
                for (int i = 1; i <= columnCount; i++) {
                    System.out.print(String.format("%-20s", rsMetaData.getColumnName(i)));
                }
                System.out.println();
                System.out.println("─".repeat(60));

                // Dados
                int rowCount = 0;
                while (data.next()) {
                    for (int i = 1; i <= columnCount; i++) {
                        System.out.print(String.format("%-20s", data.getString(i)));
                    }
                    System.out.println();
                    rowCount++;
                }

                if (rowCount == 0) {
                    System.out.println("(Nenhum registro)");
                } else {
                    System.out.println("\n📊 Total: " + rowCount + " registro(s)\n");
                }

                data.close();
                columns.close();
                System.out.println();
            }

            tables.close();
            conn.close();

        } catch (ClassNotFoundException e) {
            System.err.println("Driver H2 não encontrado!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Erro ao conectar ao banco de dados!");
            e.printStackTrace();
        }
    }
}

