import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendAnnouncement = functions.firestore
  .document("announcements")
  .onCreate(async (snapshot) => {
    const announcement = snapshot.data();

    const payload = {
      notification: {
        title: "New Announcement!",
        body: `${announcement.title} is ready for adoption`,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    return announcement.groups.length === 0
      ? Promise.all(
          announcement.tutorials.map((tutorialId) =>
            fcm.sendToTopic(`T${tutorialId}`, payload)
          )
        )
      : Promise.all(
          announcement.groups.map((groupId) =>
            fcm.sendToTopic(`G${groupId}`, payload)
          )
        );
  });
