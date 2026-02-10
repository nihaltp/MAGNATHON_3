import serial
import time
import firebase_admin
from firebase_admin import credentials, firestore

# ---------- CONFIG ----------
SERIAL_PORT = "COM3"
BAUD_RATE = 9600
DOC_ID = "tZ00L2SuCpkHV4knZs6x"

# ---------- FIREBASE ----------
cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

doc_ref = db.collection("coaster").document(DOC_ID)

# ---------- SERIAL ----------
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
time.sleep(2)

print("System Ready...")

score_value = 0
game_active = False


# 🔥 Firestore Listener (Flutter START trigger)
def on_snapshot(doc_snapshot, changes, read_time):
    global game_active, score_value

    for doc in doc_snapshot:
        data = doc.to_dict()

        if data.get("active") == True and not game_active:
            print("Game Started from Flutter!")
            score_value = 0

            # Reset score in Firestore
            doc_ref.update({
                "currScore": 0,
            })

            ser.write(b"START\n")
            game_active = True


# Attach listener
doc_watch = doc_ref.on_snapshot(on_snapshot)


# 🔥 Main Loop (Arduino communication)
while True:
    try:
        if ser.in_waiting:
            data = ser.readline().decode("utf-8").strip().lower()
            print("Arduino:", data)

            # ---- SCORE UPDATE ----
            if data.startswith("score:"):
                try:
                    value = int(data.split(":")[1].strip())
                    score_value = value

                    doc_ref.update({
                        "currScore": score_value
                    })

                except Exception as e:
                    print("Score parse error:", e)

            # ---- STOP FROM ARDUINO ----
            elif data == "stop":
                print("Game Over detected from Arduino")

                doc_ref.update({
                    "active": False,
                    "endTime": firestore.SERVER_TIMESTAMP
                })

                game_active = False
                score_value = 0

    except Exception as e:
        print("Error:", e)
        time.sleep(1)
