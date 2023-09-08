package kitchen_api_services;

import fi.iki.elonen.NanoHTTPD;

/**
 * Created by visual on 22-Aug-17.
 */

public class ServerUtil {
    public static String TAG = ServerUtil.class.getSimpleName();
    public static NanoServer nServer;

    public static boolean startServer(int port) {
        try {
            if (nServer == null) {
                nServer = new NanoServer(port);
            }
            if (!nServer.isAlive()) {
                nServer.start(NanoHTTPD.SOCKET_READ_TIMEOUT, true);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean stopServer() {
        try {
            if (nServer == null) {
                return true;
            }
            if (nServer.isAlive()) {
                nServer.stop();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean isAlive() {
        try {
            if (nServer == null) {
                return false;
            }
            return nServer.isAlive();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
