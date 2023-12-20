import java.io.*;
import java.util.*;

public class Task152 {

    List<LinkedHashMap<String,Integer>> boxes;

    public Task152() {
        boxes = new ArrayList<LinkedHashMap<String,Integer>>();
        for (int i = 0; i < 256; i++) {
            boxes.add(new LinkedHashMap<String,Integer>());
        }
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
        for (String field : fields) {
            int index = getCode(field);
            LinkedHashMap<String,Integer> box = boxes.get(index);
            int pos = field.indexOf("=");
            if (pos >= 0) {
                String key = field.substring(0,pos);
                if (box.containsKey(key)) {
                    box.replace(key, Integer.valueOf(field.substring(pos+1)));
                } else {
                    box.put(key, Integer.valueOf(field.substring(pos+1)));
                }
            } else {
                pos = field.indexOf("-");
                if (pos >= 0) {
                    String key = field.substring(0,pos);
                    if (box.containsKey(key)) {
                        box.remove(key);
                    }
                }
            }
        }
        long sum = 0;
        for (int i = 0; i < 256; i++) {
            LinkedHashMap<String,Integer> box = boxes.get(i);
            int slot = 1;
            for (Map.Entry<String,Integer> entry : box.entrySet()) {
                String key = entry.getKey();
                int boxVal = (i+1) * slot * entry.getValue().intValue();
                sum += boxVal;
                slot++;
            }
        }

        System.out.println("Sum: " + sum);
    }

    private int getCode(String field) {
        int tot = 0;
        int len = field.length();
        for (int i = 0; i < len; i++) {
            char c = field.charAt(i);
            if (c == '=' || c == '-') break;
            tot += (int) c;
            tot *= 17;
            tot %= 256;
        }
        return tot;
    }

    public static void main(String[] args) throws Throwable {
        Task152 task = new Task152();
        task.execute();
    }
}
