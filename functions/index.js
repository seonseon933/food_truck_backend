const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();// admin sdk를 통해 firestore인스턴스에 접근.
// firestore관련 함수 사용 가능 & 데베 내의 이벤트 감지하고 반응하는 트리거 함수 작성 가능
// 해당 경로에 리스너를 설치.
exports.cleanUpUserData = functions.firestore.document('Users/{uid}').onDelete(async (snap, context) => {
    const uid = context.params.uid;
    let reviewedTruckIds = [];
    console.log(`${uid} uid 잘 가져옴.`);
    // 해당 사용자가 푸드트럭을 등록한 경우 일괄 삭제
    try {
        const userDoc = snap.data();
        reviewedTruckIds = userDoc.review_create_truckid || []; // 삭제되기 전 사용자 문서에서 필요한 정보 가져오기
        console.log(`${reviewedTruckIds} 잘 가져옴.`);

        // 사용자가 등록한 푸드트럭 삭제
        const userFoodTrucks = await db.collection('FoodTruck').where('user_uid', '==', uid).get();
        console.log(`${userFoodTrucks} uid 잘 가져옴.`);
        for (const FoodTruckDoc of userFoodTrucks.docs) {
            const truckId = FoodTruckDoc.id;
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

            // Users 컬렉션의 필드 'review_create_truckid' 배열에서 해당 foodtruckid 삭제
            const usersreview = await db.collection('Users').where('review_create_truckid', 'array-contains', truckId).get();
            for (const reviewDoc of usersreview.docs) {
                await reviewDoc.ref.update({
                    review_create_truckid: admin.firestore.FieldValue.arrayRemove(truckId)
                });
            }
            // Users 컬렉션의 필드 'favorite_truckid' 배열에서 해당 문서ID 삭제
            const usersfavorite = await db.collection('Users').where('favorite_truckid', 'array-contains', truckId).get();
            for (const favoriteDoc of usersfavorite.docs) {
                await favoriteDoc.ref.update({
                    favorite_truckid: admin.firestore.FieldValue.arrayRemove(truckId)
                });
            }

            // 트럭 이미지 삭제 및 트럭 삭제
            const truckData = FoodTruckDoc.data();
            if (truckData.truck_img) {
                await deleteImg(truckData.truck_img);
            }
            await FoodTruckDoc.ref.delete();
        }

        for (const truckId of reviewedTruckIds) {
            const truckDoc = await db.collection('FoodTruck').doc(truckId).get();
            if (truckDoc.exists) {
                const reviews = await db.collection('FoodTruck').doc(truckId).collection('Review').where('user_uid', '==', uid).get();
                for (const reviewDoc of reviews.docs) {
                    await reviewDoc.ref.delete();
                }
                console.log(`푸드트럭 ID ${truckId}에 대한 사용자의 리뷰 삭제 완료.`);
                await updateAvgRating(db, truckId);
            }
        }

        console.log('사용자가 작성한 모든 리뷰가 삭제되었고, 관련된 푸드트럭들의 평균 평점이 업데이트되었습니다.');

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
        // Users 컬렉션의 필드 'review_create_truckid' 배열에서 해당 foodtruckid 삭제
        const usersreview = await db.collection('Users').where('review_create_truckid', 'array-contains', truckId).get();
        for (const reviewDoc of usersreview.docs) {
            await reviewDoc.ref.update({
                review_create_truckid: admin.firestore.FieldValue.arrayRemove(truckId)
            });
        }
        // Users 컬렉션의 필드 'favorite_truckid' 배열에서 해당 문서ID 삭제
        const usersfavorite = await db.collection('Users').where('favorite_truckid', 'array-contains', truckId).get();
        for (const favoriteDoc of usersfavorite.docs) {
            await favoriteDoc.ref.update({
                favorite_truckid: admin.firestore.FieldValue.arrayRemove(truckId)
            });
        }

    } catch (e) {
        console.log(`js에서 truck의 메뉴,리뷰 재귀 삭제 오류: ${e}`);
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
        console.log(`js에서 이미지 삭제 오류: ${e}`);
    }
}

// 평균 평점 업데이트 함수
async function updateAvgRating(db, foodTruckId) {
    try {
        const reviewSnapshot = await db.collection('FoodTruck').doc(foodTruckId).collection('Review').get();

        if (!reviewSnapshot.empty) {
            let totalRating = 0;
            for (const doc of reviewSnapshot.docs) {
                totalRating += doc.data().Rating;
            }
            const averageRating = totalRating / reviewSnapshot.size;
            await db.collection('FoodTruck').doc(foodTruckId).update({ 'truck_avgrating': averageRating });
        } else {
            await db.collection('FoodTruck').doc(foodTruckId).update({ 'truck_avgrating': 0 });
        }
    } catch (e) {
        console.log('푸드트럭 평균 평점 갱신 오류오류: ', e);
    }
}
