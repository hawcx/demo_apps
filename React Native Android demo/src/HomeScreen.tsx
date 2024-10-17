import React, { useState, useEffect } from 'react';
import { View, Text, Image, StyleSheet, Alert, FlatList, TouchableOpacity, Linking } from 'react-native';
import { NativeModules } from 'react-native';

const { HawcxModule } = NativeModules;
const logo = require('../assets/images/logo-white.png');

const notifications = [
  { id: '1', text: 'New login from Android device on April 27, 2024' },
  { id: '2', text: 'Security update available' },
  { id: '3', text: 'Passwordless authentication now live' },
];

const HomeScreen = () => {
  const [username, setUsername] = useState('');

  // Fetch the last logged-in user on component mount
  useEffect(() => {
    const fetchUsername = async () => {
      try {
        const user = await HawcxModule.getLastUser();
        setUsername(user);
      } catch (error) {
        Alert.alert('Error', 'Failed to retrieve the username');
      }
    };

    fetchUsername();
  }, []);

  const handleSupportLink = () => {
    Linking.openURL('https://docs.hawcx.com/');
  };

  return (
    <FlatList
      ListHeaderComponent={
        <>
          <View style={styles.container}>
            <View style={styles.contentWrapper}>
              <Text style={styles.greeting}>{username ? `Hi ${username}!` : 'Hi User!'}</Text>
              <Image source={logo} style={styles.logo} />
              <Text style={styles.tagline}>Keep your data secure with Hawcx</Text>
            </View>
          </View>

          {/* Key Features Section */}
          <View style={[styles.section, { backgroundColor: 'black' }]}>
            <Text style={styles.sectionTitle}>✨ Explore Hawcx Features ✨</Text>
            <View style={styles.features}>
              <View style={styles.featureCard}>
                <Text style={styles.featureTitle}>Seamless Login</Text>
                <Text style={styles.featureDescription}>Access your account without passwords.</Text>
              </View>
              <View style={styles.featureCard}>
                <Text style={styles.featureTitle}>Enhanced Security</Text>
                <Text style={styles.featureDescription}>Add extra layers of security to your account.</Text>
              </View>
              <View style={styles.featureCard}>
                <Text style={styles.featureTitle}>Your Data</Text>
                <Text style={styles.featureDescription}>Monitor your login activities and security metrics.</Text>
              </View>
              <View style={styles.featureCard}>
                <Text style={styles.featureTitle}>Mobile Integration</Text>
                <Text style={styles.featureDescription}>Seamlessly integrate with your mobile devices.</Text>
              </View>
            </View>
          </View>

          {/* Notification Title */}
          <View style={[styles.section, { backgroundColor: 'black' }]}>
            <Text style={styles.sectionTitle}>✨ Notification ✨</Text>
          </View>
        </>
      }
      data={notifications}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => (
        <View style={styles.notificationCard}>
          <Text style={styles.notificationText}>{item.text}</Text>
        </View>
      )}
      ListFooterComponent={
        <View style={styles.supportBanner}>
          <TouchableOpacity onPress={handleSupportLink}>
            <Text style={styles.supportText}>Need Help? Visit our Support Center</Text>
          </TouchableOpacity>
        </View>
      }
      style={{ backgroundColor: 'black' }}
    />
  );
};

const styles = StyleSheet.create({
  scrollContainer: {
    padding: 15,
  },
  container: {
    flex: 1,
    backgroundColor: 'black',
    paddingHorizontal: 10,
    paddingTop:25
  },
  contentWrapper: {
    borderColor: 'white',
    borderWidth: 1,
    padding: 10,
    marginBottom: 20,
    alignItems: 'center',
  },
  greeting: {
    fontSize: 18,
    color: 'white',
    marginBottom: 20,
    textAlign: 'center',
  },
  logo: {
    width: 180,
    height: 180,
    resizeMode: 'contain',
    marginBottom: 20,
  },
  tagline: {
    fontSize: 18,
    color: 'white',
    textAlign: 'center',
    marginBottom: 10,
  },
  section: {
    width: '100%',
    marginBottom: 2,
    paddingVertical: 2,
    paddingHorizontal: 10,
    backgroundColor: 'gray',
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#fff',
    marginBottom: 15,
    textAlign: 'center',
  },
  features: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  featureCard: {
    width: '48%',
    backgroundColor: '#333',
    padding: 15,
    marginBottom: 15,
    borderRadius: 10,
  },
  featureTitle: {
    fontSize: 16,
    fontWeight: '500',
    color: '#00AEEF',
    marginBottom: 5,
  },
  featureDescription: {
    fontSize: 14,
    color: 'white',
  },
  notificationCard: {
    backgroundColor: '#333',
    padding: 15,
    marginHorizontal: 10,
    marginBottom: 10,
    borderRadius: 10,
  },
  notificationText: {
    fontSize: 14,
    color: 'white',
  },
  supportBanner: {
    backgroundColor: 'black',
    padding: 20,
    borderRadius: 10,
    alignItems: 'center',
    marginBottom: 20,
    marginHorizontal: 10,
  },
  supportText: {
    fontSize: 16,
    color: '#fff',
    marginBottom: 10,
    textAlign: 'center',
  },
});

export default HomeScreen;
