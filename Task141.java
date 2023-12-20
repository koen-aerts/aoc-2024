import java.io.*;
import java.util.*;

public class Task141 {

    List<List<Character>> rocks;
    public Task141() {
        rocks = new ArrayList<List<Character>>();
    }

    public void execute() throws Throwable {
        BufferedReader br = new BufferedReader(new FileReader("rocks.txt"));
        String line = null;
        String[] fields = null;
        List<long[]> currentList = null;
        while ((line = br.readLine()) != null) {
            String input = line.trim();
            if (input.isEmpty()) {
                continue;
            }
            int len = input.length();
            List<Character> row = new ArrayList<Character>();
            for (int i = 0; i < len; i++) {
                row.add(input.charAt(i));
            }
            rocks.add(row);
        }
        br.close();
        boolean rocksMoved = true;
        while (rocksMoved) {
            rocksMoved = false;
            for (int i = 0; i < rocks.size()-1; i++) {
                List<Character> thisRow = rocks.get(i);
                List<Character> nextRow = rocks.get(i+1);
                for (int j = 0; j < thisRow.size(); j++) {
                    if (thisRow.get(j) == '.' && nextRow.get(j) == 'O') {
                        thisRow.set(j, 'O');
                        nextRow.set(j, '.');
                        rocksMoved = true;
                    }
                }
            }
        }
        int totLoad = 0;
        for (int i = 0; i < rocks.size(); i++) {
            List<Character> thisRow = rocks.get(i);
            for (int j = 0; j < thisRow.size(); j++) {
                if (thisRow.get(j) == 'O') {
                    totLoad += rocks.size() - i;
                }
                System.out.print(thisRow.get(j));
            }
            System.out.println();
        }

        System.out.println("Sum: " + totLoad);
    }

    public static void main(String[] args) throws Throwable {
        Task141 task = new Task141();
        task.execute();
    }
}
