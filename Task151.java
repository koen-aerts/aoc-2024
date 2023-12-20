import java.io.*;
import java.util.*;

public class Task151 {

    public Task151() {
    }

    public void execute() throws Throwable {
        BufferedReader br = new BufferedReader(new FileReader("hash.txt"));
        String line = null;
        String[] fields = null;
        List<long[]> currentList = null;
        while ((line = br.readLine()) != null) {
            String input = line.trim();
            if (input.isEmpty()) {
                continue;
            }
            if (fields == null) {
                fields = line.split(",");
            }
        }
        br.close();
        long sum = 0;
        for (String field : fields) {
            sum += getCode(field);
        }

        System.out.println("Sum: " + sum);
    }

    private int getCode(String field) {
        int tot = 0;
        int len = field.length();
        for (int i = 0; i < len; i++) {
            char c = field.charAt(i);
            tot += (int) c;
            tot *= 17;
            tot %= 256;
        }
        return tot;
    }

    public static void main(String[] args) throws Throwable {
        Task151 task = new Task151();
        task.execute();
    }
}
