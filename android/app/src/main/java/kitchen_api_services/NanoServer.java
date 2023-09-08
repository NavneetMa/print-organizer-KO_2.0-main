package kitchen_api_services;

import android.content.res.Resources;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;

import fi.iki.elonen.NanoHTTPD;
public class NanoServer extends NanoHTTPD {
    private static final String TAG = NanoServer.class.getSimpleName();
    private static final String MIME_JSON = "application/json";

    private static final String KITCHEN_MODE_API = "/kitchen_mode_api";
    private static final String KITCHEN_SUM_MODE_API = "/kitchen_sum_mode_api";
    private static final String SEND_KOT_TO_KITCHEN_SUM_MODE = "sendKotToKitchenSumMode";
    private static final String HIDE_KOT_ON_KOT_SNOOZE_TIME_ADDED = "hideKotOnKOTSnoozeTimeAdded";
    private static final String resetHiddenKot = "resetHiddenKot";
    private static final String showKotAfterSnoozeTimeIsOver = "showKotAfterSnoozeTimeIsOver";
    private static final String removeItemFromSum = "removeItemFromSum";
    private static final String removeItemFromKot = "removeItemFromKot";
    private static final String dismissKot = "dismissKot";
    private static final String deleteKot = "deleteKot";
    private static final String addUndoKot = "addUndoKot";
    private static final String getAllKotData = "getAllKotData";
    private static final String getSnoozedKotData = "getSnoozedKotData";

    private Matcher matcher;

    public NanoServer(int port) {
        super(port);
    }

    @Override
    public Response serve(IHTTPSession session) {
        try {
            Log.i("NANO SERVER", "serve() - START ");
            Method method = session.getMethod();
            String uri = session.getUri();
            Map<String, String> parms = session.getParms();
            String responseString = execute(session, uri, method, parms);
            Log.i("NANO SERVER", "serve() - END");
            return NanoHTTPD.newFixedLengthResponse(Response.Status.OK, MIME_JSON, responseString);

        } catch (IOException ioe) {
            return NanoHTTPD.newFixedLengthResponse(Response.Status.INTERNAL_ERROR, MIME_PLAINTEXT, "SERVER INTERNAL ERROR: IOException: " + ioe
                    .getMessage());
        } catch (ResponseException re) {
            return NanoHTTPD.newFixedLengthResponse(re.getStatus(), MIME_PLAINTEXT, re.getMessage());
        } catch (NotFoundException nfe) {
            return NanoHTTPD.newFixedLengthResponse(Response.Status.NOT_FOUND, MIME_PLAINTEXT, "Not Found");
        } catch (Exception ex) {
            ex.printStackTrace();
            return NanoHTTPD.newFixedLengthResponse(Response.Status.INTERNAL_ERROR, MIME_HTML, "<html><body><h1>Error</h1>" + ex
                    .toString() + "</body></html>");
        }
    }

    private String execute(IHTTPSession session, String uri, Method method, Map<String, String> parms) throws IOException, ResponseException {
        String responseString = "";
        do {
            Log.i(TAG, "execute() - " + uri + " [" + method + "]");
            if (Method.GET.equals(method)) {
                responseString = handleGet(uri, session, parms);
                break;
            } else if (Method.POST.equals(method)) {
                responseString = handlePost(uri, session, parms);
                break;
            }

            throw new Resources.NotFoundException();

        } while (false);

        return responseString;
    }

    private String handleGet(String uri, IHTTPSession session, Map<String, String> parms) {
        String clientIpAddress = session.getHeaders().get("ipaddr");
        String uniqueIdStr = session.getHeaders().get("unique_id");
        String subTerminalKey = session.getHeaders().get("sub_terminal_key");

        return "";
    }

    private String handlePost(String uri, IHTTPSession session, Map<String, String> parms) throws IOException, ResponseException {

        Map<String, String> files = new HashMap<String, String>();
        JSONObject reqJson;
        try {
            if (uri.startsWith(KITCHEN_SUM_MODE_API)) {
                session.parseBody(files);
                String data = files.get("postData");
                reqJson = new JSONObject(data);
                String[] uriSplitArray = uri.split("/");
                String uriSplit = uriSplitArray[uriSplitArray.length - 1];

                if (uriSplit.equals(SEND_KOT_TO_KITCHEN_SUM_MODE)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                } else if(uriSplit.equals(HIDE_KOT_ON_KOT_SNOOZE_TIME_ADDED)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(resetHiddenKot)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(showKotAfterSnoozeTimeIsOver)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(removeItemFromSum)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(removeItemFromKot)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(dismissKot)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(addUndoKot)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }  else if(uriSplit.equals(deleteKot)) {
                    return ServerController.getInstance().getResponseFromKitchenSumMode(reqJson);
                }
            } else  if (uri.startsWith(KITCHEN_MODE_API)) {
                session.parseBody(files);
                String data = files.get("postData");
                reqJson = new JSONObject(data);
                String[] uriSplitArray = uri.split("/");
                String uriSplit = uriSplitArray[uriSplitArray.length - 1];

                if (uriSplit.equals(getAllKotData)) {
                    return ServerController.getInstance().getResponseFromKitchenMode(reqJson);
                } else  if (uriSplit.equals(getSnoozedKotData)) {
                    return ServerController.getInstance().getResponseFromKitchenMode(reqJson);
                }
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return "";
    }


    private static class NotFoundException extends RuntimeException {

    }
}