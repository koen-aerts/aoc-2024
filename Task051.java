import java.io.*;
import java.util.*;

public class Task051 {

    List<String> seeds;
    List<long[]> seedToSoil;
    List<long[]> soilToFert;
    List<long[]> fertToWater;
    List<long[]> waterToLight;
    List<long[]> lightToTemp;
    List<long[]> tempToHumid;
    List<long[]> humidToLoc;

    public Task051() {
        seeds = new ArrayList<String>();
        seedToSoil = new ArrayList<long[]>();
        soilToFert = new ArrayList<long[]>();
        fertToWater = new ArrayList<long[]>();
        waterToLight = new ArrayList<long[]>();
        lightToTemp = new ArrayList<long[]>();
        tempToHumid = new ArrayList<long[]>();
        humidToLoc = new ArrayList<long[]>();
    }

    public void execute() throws Throwable {
        BufferedReader br = new BufferedReader(new FileReader("maps.txt"));
        String line = null;
        List<long[]> currentList = null;
        while ((line = br.readLine()) != null) {
            String input = line.trim();
            if (input.isEmpty()) {
                continue;
            }
            String[] fields = line.split(":");
            if (fields.length == 2) {
                if ("seeds".equals(fields[0])) {
                    seeds = Arrays.asList(fields[1].trim().split(" "));
                }
            } else {
                String[] nums = fields[0].trim().split(" ");
                if (nums.length == 3) {
                    long dest = Long.parseLong(nums[0]);
                    long src = Long.parseLong(nums[1]);
                    long range = Long.parseLong(nums[2]);
                    currentList.add(new long[] {src, src+range-1, dest, dest+range-1});
                } else {
                    if ("seed-to-soil map".equals(fields[0])) {
                        currentList = seedToSoil;
                    } else if ("soil-to-fertilizer map".equals(fields[0])) {
                        currentList = soilToFert;
                    } else if ("fertilizer-to-water map".equals(fields[0])) {
                        currentList = fertToWater;
                    } else if ("water-to-light map".equals(fields[0])) {
                        currentList = waterToLight;
                    } else if ("light-to-temperature map".equals(fields[0])) {
                        currentList = lightToTemp;
                    } else if ("temperature-to-humidity map".equals(fields[0])) {
                        currentList = tempToHumid;
                    } else if ("humidity-to-location map".equals(fields[0])) {
                        currentList = humidToLoc;
                    } else {
                        currentList = null;
                    }
                }
            }
        }
        br.close();

        long minNum = -1;
        for (String seed : seeds) {
            String soil = getNum(seed, seedToSoil);
            String fert = getNum(soil, soilToFert);
            String water = getNum(fert, fertToWater);
            String light = getNum(water, waterToLight);
            String temp = getNum(light, lightToTemp);
            String humid = getNum(temp, tempToHumid);
            String loc = getNum(humid, humidToLoc);
            System.out.println(seed + " --> " + loc);
            long locVal = Long.parseLong(loc);
            if (minNum == -1 || locVal < minNum) {
                minNum = locVal;
            }
        }
        System.out.println("Lowest loc: " + minNum);
    }

    private String getNum(String strVal, List<long[]> mapList) {
        long lonVal = Long.parseLong(strVal);
        for (long[] vals : mapList) {
            if (lonVal >= vals[0] && lonVal <= vals[1]) {
                lonVal = lonVal + vals[2] - vals[0];
                break;
            }
        }
        return Long.toString(lonVal);
    }

    public static void main(String[] args) throws Throwable {
        Task051 task = new Task051();
        task.execute();
    }
}
