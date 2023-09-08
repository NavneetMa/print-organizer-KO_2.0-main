package kitchen_api_services;

import android.os.Handler;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONException;
import org.json.JSONObject;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class KitchenSumModeApi {
    private static MethodChannel methodChannel;
    private static String channelName = "com.kitchen_sum_mode_api";
    private static Handler handler;
    public static void configureMethodChannel(FlutterEngine flutterEngine) {
        handler = new Handler();
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channelName);
    }
    private static volatile String data = null;
    static String methodName = null;
    static String object = null;

    public static String getResponseFromKitchenSumMode(JSONObject object) {
        data = null;
        return getData(object);
    }

    private static String getData(JSONObject jsonObject) {
        try {
            object = jsonObject.getString("data");
            methodName = jsonObject.getString("methodName");
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        handler.post(new Runnable() {
            @Override
            public void run() {
                methodChannel.invokeMethod(methodName, object, new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        data = result.toString();
                    }

                    @Override
                    public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                        JSONObject resObject = new JSONObject();
                        try {
                            resObject.put("code",0);
                            resObject.put("message",errorMessage);
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }

                        data = resObject.toString();
                    }

                    @Override
                    public void notImplemented() {
                        JSONObject resObject = new JSONObject();
                        try {
                            resObject.put("code",0);
                            resObject.put("message","Method not found");
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                        data = resObject.toString();
                    }
                });
            }
        });
        while (data==null) {

        }
        return data;
    }
}
