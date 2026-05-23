import com.chocoaura.EmailUtil;

public class TestEmail {
    public static void main(String[] args) {
        System.out.println("Starting email send test...");
        boolean result = EmailUtil.sendOtp("syamahir08@gmail.com", "123456");
        System.out.println("Result: " + result);
    }
}
