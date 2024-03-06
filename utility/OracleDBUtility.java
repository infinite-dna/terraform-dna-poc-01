import java.sql.*;

public class OracleDBUtility {
    // JDBC URL, username, and password of Oracle database
    private static final String JDBC_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USERNAME = "your_username";
    private static final String PASSWORD = "your_password";

    public static void main(String[] args) {
        try {
            // Load the Oracle JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Connect to the Oracle database
            Connection connection = DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
            System.out.println("Connected to Oracle database");

            // Create a statement
            Statement statement = connection.createStatement();

            // Perform insert operations
            int rowsAffected = statement.executeUpdate("INSERT INTO your_table (column1, column2) VALUES ('value1', 'value2')");
            System.out.println(rowsAffected + " row(s) inserted successfully");

            // Perform select operations
            ResultSet resultSet = statement.executeQuery("SELECT * FROM your_table");
            System.out.println("Query executed successfully. Results:");

            // Iterate over the result set
            while (resultSet.next()) {
                // Example: Assuming the table has columns named "column1" and "column2"
                String column1Value = resultSet.getString("column1");
                String column2Value = resultSet.getString("column2");
                System.out.println("Value of column1: " + column1Value + ", Value of column2: " + column2Value);
            }

            // Close the result set, statement, and connection
            resultSet.close();
            statement.close();
            connection.close();
            System.out.println("Connection closed");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}
