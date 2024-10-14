package com.example.demo.activities;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.DialogFragment;
import androidx.lifecycle.ViewModelProvider;
import com.example.demo.R;
import com.example.demo.databinding.ActivityHomeBinding;
import com.example.demo.databinding.ModalTimeLogBinding;
import com.example.demo.fragments.TimeLogDialogFragment;
import com.example.demo.viewmodels.MainViewModel;
import com.hawcx.utils.EncryptedSharedPreferencesUtil;

public class HomeActivity extends AppCompatActivity {

  private MainViewModel viewModel;
  private ActivityHomeBinding binding;
  private ModalTimeLogBinding modalBinding;
  private DialogFragment timeLogDialogFragment;
  private Button logoutButton;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    binding = ActivityHomeBinding.inflate(getLayoutInflater());
    setContentView(binding.getRoot());

    LayoutInflater inflater = LayoutInflater.from(this);
    modalBinding = ModalTimeLogBinding.inflate(inflater);

    viewModel = new ViewModelProvider(this).get(MainViewModel.class);

    binding.setViewModel(viewModel);
    binding.setLifecycleOwner(this);

    modalBinding.setViewModel(viewModel);
    modalBinding.setLifecycleOwner(this);

    logoutButton = binding.logoutButton;
    logoutButton.setOnClickListener(v -> logout());

    // FIXME: Setting it to the current email
    // Related to the L24 in main model view
      String email = EncryptedSharedPreferencesUtil.getString(this, "email");
      Bundle b = getIntent().getExtras();
      String loggedInEmail =  b.getString("lastEmail");
    if (!loggedInEmail.isEmpty()) {
      viewModel.loadData(this, loggedInEmail);
    } else{
      viewModel.loadData(this,email);
    }

    viewModel.getTimeLogShow().observe(this, show -> {
      if (show) {
        showTimeLogDialog();
      } else {
        hideTimeLogDialog();
      }
    });

        viewModel.getTimeLogs().observe(this, timelogs -> {
//            if (timelogs != null) {
//                LinearLayout timeLogsContainer = binding.devicesListContainer.findViewById(R.id.timeLogsContainer);
//                timeLogsContainer.removeAllViews(); // Clear previous views
//                addTimeLogEntry(timeLogsContainer, "Create Cipher", timelogs.getCipherTime());
//                addTimeLogEntry(timeLogsContainer, "Send Cipher API", timelogs.getSendCipherTime());
//                addTimeLogEntry(timeLogsContainer, "Regen M2 Time", timelogs.getRegenM2Time());
//                addTimeLogEntry(timeLogsContainer, "Verify Cipher API", timelogs.getVerifyCipherTime());
//                addTimeLogEntry(timeLogsContainer, "Store Keys", timelogs.getStoreKeyTime());
//                addTimeLogEntry(timeLogsContainer, "Total Time", timelogs.getTotalTime());
//            }
            if (timelogs != null) {
                LinearLayout timeLogsContainer = binding.devicesListContainer.findViewById(R.id.timeLogsContainer);
                timeLogsContainer.removeAllViews(); // Clear previous views
                addTimeLogEntry(timeLogsContainer, "Create Cipher / Add User", timelogs.getCipherTime());
                addTimeLogEntry(timeLogsContainer, "Send Cipher API / H1H2 Time", timelogs.getSendCipherTime());
                addTimeLogEntry(timeLogsContainer, "Regen M2 Time", timelogs.getRegenM2Time());
                addTimeLogEntry(timeLogsContainer, "Verify Cipher API", timelogs.getVerifyCipherTime());
                addTimeLogEntry(timeLogsContainer, "Store Keys", timelogs.getStoreKeyTime());
                addTimeLogEntry(timeLogsContainer, "Total Time", timelogs.getTotalTime());
            }
        });

    modalBinding.closeButton.setOnClickListener(v -> viewModel.hideTimeLogs());
  }

  private void showTimeLogDialog() {
    if (timeLogDialogFragment == null) {
      timeLogDialogFragment = new TimeLogDialogFragment();
    }
    timeLogDialogFragment.show(getSupportFragmentManager(), "TimeLogDialog");
  }

  private void hideTimeLogDialog() {
    if (timeLogDialogFragment != null) {
      timeLogDialogFragment.dismiss();
    }
  }

    private void logout() {
        try {
            // FIXME: Test this in the app before pushing it
//            EncryptedSharedPreferencesUtil.clear(this);
            EncryptedSharedPreferencesUtil.setBoolean(this, "is_logged_out", true);
            Intent intent = new Intent(HomeActivity.this, LoginActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            startActivity(intent);
            finish();
        } catch (Exception e) {
            Log.e("HomeActivity", "Error during logout: ", e);
            Toast.makeText(this, "Logout failed. Please try again.", Toast.LENGTH_SHORT).show();
        }
    }

  private void addTimeLogEntry(LinearLayout container, String label,
                               long time) {
    Log.d("TimeLogEntry", "Label: " + label + ", Time: " + time + " sec");

    if (container == null) {
      Log.e("TimeLogEntry", "Container is null");
      return;
    }

    runOnUiThread(() -> {
      TextView textView = new TextView(this);
      textView.setText(label + ": " + time + " msec");
      textView.setTextSize(14);
      textView.setTextColor(getResources().getColor(android.R.color.black));
      textView.setLayoutParams(new LinearLayout.LayoutParams(
          LinearLayout.LayoutParams.WRAP_CONTENT,
          LinearLayout.LayoutParams.WRAP_CONTENT));
      container.addView(textView);
      Log.d("TimeLogEntry", "TextView added to container");
    });
  }
}
