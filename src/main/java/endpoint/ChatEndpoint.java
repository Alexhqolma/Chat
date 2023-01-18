package endpoint;

import coder.MessageDecoder;
import coder.MessageEncoder;
import entity.Message;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/chat", decoders = {MessageDecoder.class},
        encoders = {MessageEncoder.class})
public class ChatEndpoint {
    private static List<Session> sessionList = new LinkedList<>();
    private Session session = null;

    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        sessionList.add(session);
    }

    @OnClose
    public void onClose(Session session) {
        sessionList.remove(session);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
    }

    @OnMessage
    public void onMessage(Session session, Message message) {
        sessionList.forEach(s -> {
            if (s == this.session) {
                return;
            }
            try {
                s.getBasicRemote().sendObject(message);
            } catch (IOException | EncodeException e) {
                throw new RuntimeException(e);
            }
        });
    }
}
