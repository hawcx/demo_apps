import React, { useState } from 'react';
import { View, Text, TextInput, Button, Alert, StyleSheet, TouchableOpacity  } from 'react-native';
import { NativeModules } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RouteProp } from '@react-navigation/native';

const { HawcxModule } = NativeModules;

// Define your stack param list
type RootStackParamList = {
  RestoreVerification: { email: string };
  SignIn: undefined;
};

// Define the props for the screen
type RestoreVerificationScreenNavigationProp = StackNavigationProp<RootStackParamList, 'RestoreVerification'>;
type RestoreVerificationScreenRouteProp = RouteProp<RootStackParamList, 'RestoreVerification'>;

type Props = {
  navigation: RestoreVerificationScreenNavigationProp;
  route: RestoreVerificationScreenRouteProp;
};

const RestoreVerificationScreen: React.FC<Props> = ({ navigation, route }) => {
  const { email } = route.params;
  const [otp, setOtp] = useState('');
  const [resending, setResending] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleVerifyOtp = () => {
    if (otp) {
      setLoading(true);
      // Call the verifyOtpForAccountRestore method from HawcxModule
      HawcxModule.verifyOtpForAccountRestore(email, otp)
        .then(() => {
          Alert.alert('Account Restored', 'Your account has been restored successfully!');

          // Navigate back to SignIn screen after OTP is verified
          navigation.replace('SignIn');
          setLoading(false);
        })
        .catch((error: any) => {
          Alert.alert('Error', error.message || 'Failed to verify OTP');
        });
    } else {
      Alert.alert('Error', 'Please enter the OTP');
    }
  };

  const handleResendOTP = () => {
    setResending(true);
    // Call the resendOtpForAccountRestore method from HawcxModule
    HawcxModule.generateOtpForAccountRestore(email)
      .then(() => {
        Alert.alert('OTP Resent', 'A new OTP has been sent to your email.');
        setResending(false);
      })
      .catch((error: any) => {
        Alert.alert('Error', error.message || 'Failed to resend OTP');
        setResending(false);
      });
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Enter OTP</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter the OTP sent to your email"
        placeholderTextColor="gray"
        value={otp}
        onChangeText={setOtp}
        keyboardType="numeric"
      />
      <Button title={loading ? 'Verifying OTP...' : 'Verify OTP'} onPress={handleVerifyOtp} disabled={loading} />

      {/* Resend OTP Button */}
      <TouchableOpacity onPress={handleResendOTP} disabled={resending}>
        <Text style={styles.link}>{resending ? 'Resending OTP...' : 'Resend OTP'}</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 16,
    color: 'white',
    backgroundColor: 'black',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    color: 'white',
    marginBottom: 20,
  },
  input: {
    borderWidth: 1,
    padding: 10,
    marginVertical: 12,
    width: '100%',
    borderRadius: 4,
    borderColor: 'gray',
    color: 'white',
    backgroundColor: 'black',
  },
  link: {
    color: 'blue',
    marginTop: 10,
    textAlign: 'center',
  },
});

export default RestoreVerificationScreen;
