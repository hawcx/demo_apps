// VerificationScreen.tsx
import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, Alert } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RouteProp } from '@react-navigation/native';
import { NativeModules } from 'react-native';

// Access HawcxModule from NativeModules
const { HawcxModule } = NativeModules;

// Define your stack param list
type RootStackParamList = {
  Verification: { email: string };
  SignIn: undefined;
};

type VerificationScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Verification'>;
type VerificationScreenRouteProp = RouteProp<RootStackParamList, 'Verification'>;

type Props = {
  navigation: VerificationScreenNavigationProp;
  route: VerificationScreenRouteProp;
};

const VerificationScreen: React.FC<Props> = ({ navigation, route }) => {
  const { email } = route.params; // Email passed from Signup
  const [otp, setOtp] = useState('');
  const [loading, setLoading] = useState(false);
  const [resending, setResending] = useState(false);

  const handleVerifyOTP = () => {
    setLoading(true);
    // Call the handleVerifyOTP method from HawcxModule
    HawcxModule.handleVerifyOTP(email, otp)
      .then(() => {
        // Navigate to SignIn screen on successful OTP verification
        navigation.navigate('SignIn');
        setLoading(false);
      })
      .catch((error: any) => {
        // Show an error message if OTP verification fails
        Alert.alert('OTP Verification Error', error.message || 'Invalid OTP');
        setLoading(false);
      });
  };
  const handleResendOTP = () => {
    setResending(true);
    // Call the method to resend OTP from HawcxModule
    HawcxModule.signUp(email)
      .then(() => {
        Alert.alert('OTP Resent', 'A new OTP has been sent to your email.');
        setResending(false);
      })
      .catch((error: any) => {
        Alert.alert('Resend OTP Error', error.message || 'Failed to resend OTP');
        setResending(false);
      });
  };
  return (
    <View style={styles.container}>
      <Text>Enter the OTP sent to your email:</Text>
      <TextInput
        style={styles.input}
        placeholder="OTP"
        value={otp}
        onChangeText={setOtp}
        keyboardType="number-pad"
      />
      <Button title={loading ? 'Verifying OTP...' : 'Verify OTP'} onPress={handleVerifyOTP} disabled={loading} />
      <Button title={resending ? 'Resending OTP...' : 'Resend OTP'} onPress={handleResendOTP} disabled={resending} />
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
  input: {
    borderWidth: 1,
    padding: 10,
    marginVertical: 12,
    width: '100%',
    color: 'white',
    backgroundColor: 'black',
  },
});

export default VerificationScreen;
