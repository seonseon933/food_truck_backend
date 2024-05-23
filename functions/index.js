// 헐 firestore읽기는 문서를 가져온 수로 계산된다 함.. 와..
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();// admin sdk를 통해 firestore인스턴스에 접근.
// firestore관련 함수 사용 가능 & 데베 내의 이벤트 감지하고 반응하는 트리거 함수 작성 가능
// 해당 경로에 리스너를 설치.
exports.cleanUpUserData = functions.firestore.document('Users/{uid}').onDelete(async (snap, context) => {
    const uid = context.params.uid;
    // where : 문서 필터링. 안의 필터링에 해당하는 문서만 반환. 이때 배열 형태로 반환.
    // 해당 사용자가 푸드트럭을 등록한 경우 일괄 삭제
    try {
        const userFoodTrucks = await db.collection('FoodTruck').where('user_uid', '==', uid).get();
        for (const FoodTruckDoc of userFoodTrucks.docs) {
            const truckId = FoodTruckDoc.id;
            const menus = await db.collection('FoodTruck').doc(truckId).collection('Menu').get();
            for (const menuDoc of menus.docs) {
                const menuData = menuDoc.data();
                if (menuData.menu_img) {
                    await deleteImg(menuData.menu_img);
                }
                await menuDoc.ref.delete();
            }
            // 리뷰 삭제
            const reviews = await db.collection('FoodTruck').doc(truckId).collection('Review').get();
            for (const reviewDoc of reviews.docs) {
                await reviewDoc.ref.delete();
            }
            // 트럭 이미지 삭제 및 트럭 삭제
            const truckData = FoodTruckDoc.data();
            if (truckData.truck_img) {
                await deleteImg(truckData.truck_img);
            }
            await FoodTruckDoc.ref.delete();
        }
        // 해당 유저가 작성한 리뷰 일괄 삭제
        const userDoc = await db.collection('Users').doc(uid).get();
        const reviewedTruckIds = userDoc.data()?.review_create_truckid || [];  // 사용자 문서에서 리뷰가 작성된 푸드트럭ID 배열 가져옴

        for (const truckId of reviewedTruckIds) {
            const truckExists = (await db.collection('FoodTruck').doc(truckId).get()).exists;
            if (truckExists) {
                const reviews = await db.collection('FoodTruck').doc(truckId).collection('Review').where('user_uid', '==', uid).get();
                const deletePromises = reviews.docs.map(review => review.ref.delete());
                await Promise.all(deletePromises);
            }
        }

    } catch (e) {
        console.log(`js에서 truck의 메뉴, 리뷰 재귀 삭제 오류: ${e}`);
    }
})

// foodtruck 삭제했을 때, menu&review 재귀 삭제
exports.cleanUpTruckData = functions.firestore.document('FoodTruck/{truckid}').onDelete(async (snap, context) => {
    const truckId = context.params.truckid;
    try {
        // 메뉴 삭제
        const menus = await db.collection('FoodTruck').doc(truckId).collection('Menu').get();
        for (const menuDoc of menus.docs) {
            const menuData = menuDoc.data();
            if (menuData.menu_img) {
                await deleteImg(menuData.menu_img);
            }
            await menuDoc.ref.delete();
        }
        // 리뷰 삭제 
        const reviews = await db.collection('FoodTruck').doc(truckId).collection('Review').get();
        for (const reviewDoc of reviews.docs) {
            await reviewDoc.ref.delete();
        }

    } catch (e) {
        console.log('js에서 truck의 메뉴,리뷰 재귀 삭제 오류: ${e}');
    }

})


async function deleteImg(oldImgUrl) {
    try {
        const filePath = new URL(oldImgUrl).pathname;
        const decodedFilePath = decodeURIComponent(filePath.substring(
            filePath.indexOf('/o/') + 3).split('?')[0]);

        if (decodedFilePath != "defaultimg.jpg") {
            await admin.storage().bucket().file(decodedFilePath).delete();
        }
    } catch (e) {
        console.log('js에서 이미지 삭제 오류: ${e}');
    }
}