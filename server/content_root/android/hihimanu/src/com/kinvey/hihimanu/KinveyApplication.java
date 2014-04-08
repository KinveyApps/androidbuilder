package com.kinvey.hihimanu;

import com.kinvey.android.Client;

import android.app.Application;

public class KinveyApplication extends Application {
	
	private Client client;
	
	public void onCreate(){
		super.onCreate();
		client = new Client.Builder(getApplicationContext()).build();
	}
	
	public Client getClient(){
		return client;
	}
	

}
