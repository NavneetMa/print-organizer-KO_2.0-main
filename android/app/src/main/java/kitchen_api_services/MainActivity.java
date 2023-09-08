package kitchen_api_services;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.kitchen_sum_mode_api/server";
    private static final String CHANNEL_KITCHEN_MODE = "com.kitchen_mode_api/server";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        KitchenSumModeApi.configureMethodChannel(flutterEngine);
        KitchenModeApi.configureMethodChannel(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startServer")) {
                                KitchenSumModeApi.configureMethodChannel(flutterEngine);
                                startServer(result);
                            }
                        }
                );

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_KITCHEN_MODE)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startKitchenModeServer")) {
                                startKitchenModeServer(result);
                            }
                        }
                );
    }

    private void startServer(MethodChannel.Result result) {
        ServerUtil.startServer(8444);
        if (ServerUtil.isAlive()) {
            result.success("Server is started");
        } else {
            result.success("Server failed to start");
        }
    }

    private void startKitchenModeServer(MethodChannel.Result result){
        ServerUtil.startServer(8445);
        if (ServerUtil.isAlive()) {
            result.success("Server is started");
        } else {
            result.success("Server failed to start");
        }
    }

}
