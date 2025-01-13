# [뿍 팀] FFOODD 앱 

# 1. 프로젝트 개요
* **주제 소개**<br>
  광주 내의 푸드트럭의 위치, 판매 시간 등의 정보를 소비자들이 간편하게 등록 및 확인할 수 있게끔 서비스를 제공하는 어플이다.
* **개발 목적**<br>
  지도 어플을 통해 음식점들의 위치와 메뉴를 쉽게 확인할 수 있지만, 이동 판매를 하는 푸드트럭은 지도에 등록되어 있지 않아 언제 어디서 무엇을 파는지 알기 어렵다. 이로 인해 소비자들은 종종 사장님이나 지역 커뮤니티에 문의해야 하는 번거로움이 있다. 이러한 불편을 해소하기 위해 어플을 통해 푸드트럭 정보를 제공하고자 한다.

# 2. 개발 환경
![image](https://github.com/user-attachments/assets/b094a2bc-1870-40f3-bf73-9775d8a5ca67)

# 3. 데이터 구조
<details>
<summary>데이터 구조 펼치기</summary>
<div markdown="1">

  <pre>
  <code>
    Users (Collection)
    |
    └── userDocID (Document)
    ├── user_email: ""
    ├── user_img: ""
    ├── user_name: ""
    ├── user_img_source: ""
    ├── review_create_truckid: [] 
    ├── favorite_truckid: [] 
    └── user_type : boolean 

    FoodTruck (Collection)
    |
    └── foodTruckDocID (Document)
    ├── user_uid : ""
        ├── truck_name: ""
        ├── truck_description: ""
        ├── truck_create_date : ""
        ├── truck_schedule: ""
        ├── truck_phone: ""
        ├── truck_img : ""
        ├── truck_tag : ""
        ├── truck_latitude :  double
        ├── truck_longitude : double
        ├── truck_avgrating : double
        └── truck_payment: { 
            ├── cash: boolean
            ├── card: boolean
            ├── bankTransfer: boolean
            ├── bankName: ""
            ├── accountName: ""
            └── accountNumber: ""
        }
    
    Menu (Collection)
    |
    └── menuDocID (Document)
        ├── menu_name: ""
        ├── truck_description: ""
        ├── menu_price: ""
        └── menu_img: ""
    
    Review (Collection)
    |
    └── reviewDocID (Document)
        ├── review_create_date: ""
        ├── user_uid: ""
        ├── user_name: ""
        ├── user_img : ""
        ├── Rating : double
        ├── review_context : ""
        └── update: int
  </code>
  </pre>

</div>
</details>

# 4. 역할 분담
* 선혜린[백엔드]
* 송민경[백엔드]
* 임건우[프론트엔드]
* 노수민 [프론트엔드]

# 5. 개발 기간
2024.03.04 ~ 2024.06.23

# 6. 기능
**1. 초기화면**
* 로그인 화면
  * 회원이 아닌 경우 & 로그아웃을 한 유저인 경우
     ![로그인전체](https://github.com/user-attachments/assets/a17d56ed-0875-4ff4-9610-8a174be9ac9f)<br>
    → 기존 회원인 유저라면 로그인 화면이 나오지 않고 바로 메인 화면으로 이동이 됨. <br>
    → 회원이 아닌 유저라면 구글 로그인 화면이 나오고, 구글 계정이 없는 사용자는 구글 회원가입 창으로 넘어가게 된다.<br>
  * 최초 로그인 시<br>
    → 사용자가 최초로 로그인을 할 경우 판매자인지 소비자인지 선택을 할 수 있는 화면이 나옴. <br><br>
    

**2. 메인화면(홈 화면)**

![메인화면검색](https://github.com/user-attachments/assets/d231b68d-03aa-442b-9f8b-25caa60d8774)<br>
→ 메인 화면에선 현재 등록된 푸드트럭의 위치를 확인할 수 있다. 검색 창을 누르면 주소를 입력할 수 있는데, 간단한 검색만으로 상세한 주소를 찾을 수 있다. 해당 주소를 클릭할 시 지도의 위치가 해당 위치로 바뀐다.<br><br>


**3. 마이페이지**

<img src="https://github.com/user-attachments/assets/8d0653b4-1589-4a02-96dc-455bec77f09a" width="300" height="460"><br>
→ 마이페이지에선 회원의 정보를 확인/수정할 수 있으며, 내 리뷰,  로그아웃, 계정 탈퇴하기를 할 수 있다. 최초 로그인 때 판매자를 선택하였다면 <판매자용>란이 떠 푸드트럭을 생성할 수 있다.<br>
닉네임 아래의 빨간색 선엔 구글 계정이 나와있다.<br>

* 회원정보수정<br>
  ![캡처](https://github.com/user-attachments/assets/0fbf4f19-8153-4dbb-9486-fe9acade3133)<br>
  → 회원정보수정에선 닉네임과 프로필 사진을 변경할 수 있다.<br><br>
* 푸드트럭 등록<br>
  ![푸드트럭등록1](https://github.com/user-attachments/assets/db7417d2-5c4e-4809-8643-09b0b920941b)<br>
  → 푸드트럭 생성하기를 누르면 메인화면처럼 지도와 주소 검색 창이 나온다.<br><br>
  <img src="https://github.com/user-attachments/assets/5b6e55ab-226d-45ca-a789-ec6fbac1e6e9" width="250" height="470"><br>
  → 푸드트럭 이미지, 이름, 전화 번호, 음식 태그, 판매 시간, 결제 방법(현금, 카드, 계좌이체)를 적거나 선택할 수 있다.<br>
  <img src="https://github.com/user-attachments/assets/31ef369b-bac1-471e-ad22-d7f66365e858" width="250" height="470"><br><br>
  → 등록을 완료하면 푸드트럭 리스트에서 확인이 가능하다. <br>

**4. 메뉴 등록**

판매자는 자신이 생성한 푸드트럭에서 메뉴를 등록/수정/삭제할 수 있다. 입력으로는 사진, 이름, 가격, 소개가 있다.<br>
![메뉴등록전체](https://github.com/user-attachments/assets/2a5648f2-8685-4237-bb53-a7538cd38dac) <br>

**5. 찜 & 리뷰 작성**
* 찜 기능<br>
![짬](https://github.com/user-attachments/assets/58b981c7-560c-4009-b805-ed45be2e0fcf)<br>
→ 소비자는 마음에 드는 푸드트럭에 찜을 누를 수 있다. Wishlist탭을 누르면 자신이 찜한 푸드트럭들을 볼 수 있다.<br>
![Wishlist](https://github.com/user-attachments/assets/f2fb555b-dba9-446e-a1fd-8744d8ece681)<br><br>

* 리뷰 기능<br>
![리뷰](https://github.com/user-attachments/assets/2e6e69c8-2c9b-4738-a44b-ccd1956d7817)<br>
→ 소비자는 푸드트럭에 리뷰를 작성하여 다른 사용자들과 푸드트럭에 대해 공유할 수 있다. 사용자들이 올린 별점의 평균이 푸드트럭의 메인에 별 모양으로 표시된다.<br>





