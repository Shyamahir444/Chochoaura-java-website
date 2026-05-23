import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class SetupAdmin {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chocoaura", "root", "");
            Statement stmt = con.createStatement();
            
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS admins (" +
                               "id INT AUTO_INCREMENT PRIMARY KEY, " +
                               "username VARCHAR(50) NOT NULL UNIQUE, " +
                               "password VARCHAR(255) NOT NULL)");
                               
            stmt.executeUpdate("INSERT IGNORE INTO admins (username, password) VALUES ('admin@chocoaura.com', 'admin123')");
            
            System.out.println("Admins table created and default admin inserted successfully.");
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
