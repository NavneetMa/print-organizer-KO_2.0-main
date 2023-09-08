package kitchen_api_services;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.text.DateFormat;
import java.util.Date;


/**
 * Created by visual on 5/30/2017.
 */

public class ServerController {
    private final static String TAG = ServerController.class.getSimpleName();
    private static volatile ServerController singleInstance = null;
    private Gson gson;

    private ServerController() {

        GsonBuilder builder = new GsonBuilder().setDateFormat("dd.MM.yyyy HH:mm:ss");

        /// Register an adapter to manage the date types as long values
        builder.registerTypeAdapter(Date.class, new JsonDeserializer<Date>() {
            public Date deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
                try {
                    return new Date(json.getAsJsonPrimitive().getAsLong());
                } catch (NumberFormatException nfe) {
                    try {
                        DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.DEFAULT, DateFormat.DEFAULT);
                        return formatter.parse(json.getAsString());
                    } catch (Exception e) {
                        return null;
                    }

                }
            }
        });
        gson = builder.create();
    }

    public static ServerController getInstance() {
        if (singleInstance == null) {
            synchronized (ServerController.class) {
                if (singleInstance == null) {
                    singleInstance = new ServerController();
                }
            }
        }
        return singleInstance;
    }

    public String getResponseFromKitchenSumMode(JSONObject reqJson) {
        JSONObject resObject = new JSONObject();
        try {
            resObject.put("code",0);
            resObject.put("message","Method not found");
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        try {
            return KitchenSumModeApi.getResponseFromKitchenSumMode(reqJson);
        } catch (Exception e) {
            e.printStackTrace();
            return resObject.toString();
        }
    }

    public String getResponseFromKitchenMode(JSONObject reqJson) {
        JSONObject resObject = new JSONObject();
        try {
            resObject.put("code",0);
            resObject.put("message","Method not found");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        try {
            return KitchenModeApi.getResponseFromKitchenMode(reqJson);
        } catch (Exception e) {
            e.printStackTrace();
            return resObject.toString();
        }
    }
}
