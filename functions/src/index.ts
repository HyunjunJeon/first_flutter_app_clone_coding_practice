import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// cloud functions 를 돌려주는 서버에 기본적으로 ffmpeg 패키지가 포함되어 있음
export const onVideoCreated = functions.firestore
    .document("videos/{videoId}")
    .onCreate(async (snapshot, context) => {
        const spawn = require('child-process-promise').spawn;
        const video = snapshot.data();
        await spawn("ffmpeg", [
            "-i",
            video.fileUrl,
            "-ss",
            "00:00:01.000",
            "-vframes",
            "1",
            "-vf",
            "scale=150:-1",
            `/tmp/${snapshot.id}.jpg`,
        ]);
        const storage = admin.storage();
        const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
            destination: `thumbnails/${snapshot.id}.jpg`
        });
        await file.makePublic();
        await snapshot.ref.update({"thumbnailUrl": file.publicUrl()});

        const database = admin.firestore();
        database.collection("users").doc(video.creatorUid)
                .collection("videos").doc(snapshot.id)
                .set({thumbnailUrl: file.publicUrl(), videoId: snapshot.id});
    });

export const onLikedCreated = functions.firestore
    .document("likes/{likeId}")
    .onCreate(async (snapshot, context) => {
        const db = admin.firestore();
        const [videoId, _] = snapshot.id.split("000");
        await db.collection("videos").doc(videoId).update({likes: admin.firestore.FieldValue.increment(1)});
        // https://firebase.google.com/docs/reference/admin/node/firebase-admin.messaging.messaging
        const video = (await (db.collection("videos").doc(videoId).get())).data();
        if(video) {
            const creatorUid = video.creatorUid;
            const user = (await db.collection("users").doc(creatorUid).get()).data();
            if(user) {
                const token = user.token;
                await admin.messaging().sendToDevice(token, {
                    data: {
                        screen: "123",
                    },
                    notification: {
                        title: "someone liked your video",
                        body: "Like + 1 ! congrats! 😍"
                    },
                });
            }
        }
    });



export const onLikedRemoved = functions.firestore
    .document("likes/{likeId}")
    .onDelete(async (snapshot, context) => {
        const db = admin.firestore();
        const [videoId, _] = snapshot.id.split("000");
        await db.collection("videos").doc(videoId).update({likes: admin.firestore.FieldValue.increment(-1)});
    });



