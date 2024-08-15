package com.example.demo.fragments;

public class TimeLogs {
    private long cipherTime;
    private long sendCipherTime;
    private long regenM2Time;
    private long verifyCipherTime;
    private long storeKeyTime;
    private long totalTime;

    public TimeLogs(long cipherTime, long sendCipherTime, long regenM2Time, long verifyCipherTime, long storeKeyTime, long totalTime) {
        this.cipherTime = cipherTime;
        this.sendCipherTime = sendCipherTime;
        this.regenM2Time = regenM2Time;
        this.verifyCipherTime = verifyCipherTime;
        this.storeKeyTime = storeKeyTime;
        this.totalTime = totalTime;
    }

    public long getCipherTime() {
        return cipherTime;
    }

    public long getSendCipherTime() {
        return sendCipherTime;
    }

    public long getRegenM2Time() {
        return regenM2Time;
    }

    public long getVerifyCipherTime() {
        return verifyCipherTime;
    }

    public long getStoreKeyTime() {
        return storeKeyTime;
    }

    public long getTotalTime() {
        return totalTime;
    }
}

