import React, { useState } from 'react';
import { View, Text, TextInput, Button, Alert, StyleSheet, TouchableOpacity } from 'react-native';
import { NativeModules } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RouteProp } from '@react-navigation/native';

const { HawcxModule } = NativeModules;

// Define your stack param list
type RootStackParamList = {
  AccountRestore: undefined;
  RestoreVerification: { email: string }; // Pass email for OTP verification
  SignIn: undefined;
};

// Define the props for the screen
type AccountRestoreScreenNavigationProp = StackNavigationProp<RootStackParamList, 'AccountRestore'>;
type AccountRestoreScreenRouteProp = RouteProp<RootStackParamList, 'AccountRestore'>;

type Props = {
  navigation: AccountRestoreScreenNavigationProp;
  route: AccountRestoreScreenRouteProp;
};

const AccountRestoreScreen: React.FC<Props> = ({ navigation }) => {
  const [email, setEmail] = useState('');

  const handleRestoreAccount = () => {
    if (email) {
      // Call the generateOtpForAccountRestore method from HawcxModule
      HawcxModule.generateOtpForAccountRestore(email)
        .then(() => {
          Alert.alert('OTP Sent', 'Please check your email for the OTP to restore your account.');

          // Navigate to RestoreVerification screen after OTP is generated
          navigation.navigate('RestoreVerification', { email });
        })
        .catch((error: any) => {
          Alert.alert('Error', error.message || 'Failed to initiate account restore');
        });
    } else {
      Alert.alert('Error', 'Please enter your email');
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Restore Account</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter your email"
        placeholderTextColor="gray"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        autoCapitalize="none"
      />
      <Button title="Restore Account" onPress={handleRestoreAccount} />

      {/* Link to navigate back to SignIn Screen */}
      <TouchableOpacity onPress={() => navigation.navigate('SignIn')}>
        <Text style={styles.link}>Back to Sign In</Text>
      </TouchableOpacity>

      {/* Link to navigate to RestoreVerification screen */}
      <TouchableOpacity 
        onPress={() => navigation.navigate('RestoreVerification', { email })} 
        disabled={!email} // Disable the link if email is empty
      >
        <Text style={styles.link}>Received OTP? Verify it.</Text>
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

export default AccountRestoreScreen;
