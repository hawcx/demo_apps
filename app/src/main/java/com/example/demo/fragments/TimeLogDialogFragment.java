package com.example.demo.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.DialogFragment;
import androidx.lifecycle.ViewModelProvider;

import com.example.demo.R;
import com.example.demo.databinding.ModalTimeLogBinding;
import com.example.demo.viewmodels.MainViewModel;

public class TimeLogDialogFragment extends DialogFragment {

    private MainViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        ModalTimeLogBinding binding = DataBindingUtil.inflate(inflater, R.layout.modal_time_log, container, false);
        viewModel = new ViewModelProvider(requireActivity()).get(MainViewModel.class);
        binding.setViewModel(viewModel);
        binding.setLifecycleOwner(this);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        LinearLayout timeLogsContainer = view.findViewById(R.id.timeLogsContainer);

        viewModel.getTimeLogs().observe(getViewLifecycleOwner(), timelogs -> {
            if (timelogs != null) {
                addTimeLogEntry(timeLogsContainer, "Create Cipher", timelogs.getCipherTime());
                addTimeLogEntry(timeLogsContainer, "Send Cipher API", timelogs.getSendCipherTime());
                addTimeLogEntry(timeLogsContainer, "Regen M2 Time", timelogs.getRegenM2Time());
                addTimeLogEntry(timeLogsContainer, "Verify Cipher API", timelogs.getVerifyCipherTime());
                addTimeLogEntry(timeLogsContainer, "Store Keys", timelogs.getStoreKeyTime());
                addTimeLogEntry(timeLogsContainer, "Total Time", timelogs.getTotalTime());
            }
        });
    }

    private void addTimeLogEntry(LinearLayout container, String label, long time) {
        TextView textView = new TextView(getContext());
        textView.setText(label + ": " + time / 1000 + " sec");
        textView.setTextSize(14);
        textView.setTextColor(getResources().getColor(android.R.color.black));
        textView.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));
        container.addView(textView);
    }
}
