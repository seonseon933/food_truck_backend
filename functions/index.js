/**
 * Import function triggers from their respective submodules:
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");
// 헐 firestore읽기는 문서를 가져온 수로 계산된다 함.. 와..
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
// firestore관련 함수 사용 가능 & 데베 내의 이벤트 감지하고 반응하는 트리거 함수 작성 가능
// 해당 경로에 리스너를 설치.
exports.cleanUpUserData = functions.firestore.document('Users/{uid}').onDelete(async (snap, context) => {
    const uid = context.params.uid;
    const db = admin.firestore(); // admin sdk를 통해 firestore인스턴스에 접근.
    // where : 문서 필터링. 안의 필터링에 해당하는 문서만 반환. 이때 배열 형태로 반환.
    const userFoodTrucks = await db.collection('FoodTruck').where('user_uid', '==', uid).get();
    userFoodTrucks.forEach(async FoddTruckDoc => {
        const truckId = FoddTruckDoc.id;

        const menus = await db.collection('FoodTruck').doc(truckId).collection('Menu').get();
        menus.forEach(menu => {
            menu.ref.delete();
        });
        if (menus.exists) {
            const menusData = menus.data();
            if (menusData.menu_img) {
                await deleteImg(menusData.menu_img);
            }
        }

    });
})

async function deleteImg(oldImgUrl) {
    try {
        const filePath = new URL(oldImgUrl).pathname;
        const decodedFilePath = decodeURIComponent(filePath.substring(
            filePath.indexOf('/o/') + 3).split('?')[0]);
        await admin.storage().bucket().file(decodedFilePath).delete();
    } catch (e) {
        console.log('js에서 이미지 삭제 오류: $e');
    }
}