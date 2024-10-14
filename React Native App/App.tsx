import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import SignupScreen from './src/SignupScreen';
import VerificationScreen from './src/VerificationScreen';
import HomeScreen from './src/HomeScreen';
import SignInScreen from './src/SignInScreen';
import AccountRestoreScreen from './src/AccountRestoreScreen';
import RestoreVerificationScreen from './src/RestoreVerificationScreen';

type RootStackParamList = {
  Signup: undefined;
  Verification: { email: string };
  Home: undefined;
  SignIn: undefined;
  AccountRestore: undefined;
  RestoreVerification: { email: string };
};

const Stack = createStackNavigator<RootStackParamList>();

const App = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Signup">
        <Stack.Screen name="Signup" component={SignupScreen} />
        <Stack.Screen name="Verification" component={VerificationScreen} />
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="SignIn" component={SignInScreen} />
        <Stack.Screen name="AccountRestore" component={AccountRestoreScreen} />
        <Stack.Screen name="RestoreVerification" component={RestoreVerificationScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;
