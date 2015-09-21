package org.pestrada.android_tdd_playground;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.widget.TextView;

import com.cloudant.p2p.listener.HttpListener;
import com.cloudant.sync.datastore.Datastore;
import com.cloudant.sync.datastore.DatastoreManager;

import org.restlet.Component;
import org.restlet.data.Protocol;

import java.io.File;


public class MainActivity extends FragmentActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    File path = getApplicationContext().getDir("datastores", MODE_PRIVATE);
    DatastoreManager manager = new DatastoreManager(path.getAbsolutePath());

    Datastore ds = manager.openDatastore("mydb");
    ds.close();

    Component component = new Component();
    component.getServers().add(Protocol.HTTP, 8182);
    component.getDefaultHost().attachDefault(HttpListener.class);

    try {
        component.start();
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
  }

  public void changeText(View view) {
    TextView textView = (TextView) findViewById(R.id.textView1);
    textView.setText("new text");
  }

}
