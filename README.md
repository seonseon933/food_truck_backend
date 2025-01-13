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
    → 사용자가 최초로 로그인을 할 경우 판매자인지 소비자인지 선택을 할 수 있는 화면이 나옴. <br>

**2. 메인화면(홈 화면)**
![메인화면검색](https://github.com/user-attachments/assets/d231b68d-03aa-442b-9f8b-25caa60d8774)<br>
→ 메인 화면에선 현재 등록된 푸드트럭의 위치를 확인할 수 있다. 검색 창을 누르면 주소를 입력할 수 있는데, 간단한 검색만으로 상세한 주소를 찾을 수 있다. 해당 주소를 클릭할 시 지도의 위치가 해당 위치로 바뀐다.<br>

**3. 마이페이지**
![KakaoTalk_20250113_212039056](https://github.com/user-attachments/assets/68d0f84e-3036-4028-915a-7573a95a52ff)<br>
→ 마이페이지에선 회원의 정보를 확인/수정할 수 있으며, 내 리뷰,  로그아웃, 계정 탈퇴하기를 할 수 있다. 최초 로그인 때 판매자를 선택하였다면 <판매자용>란이 떠 푸드트럭을 생성할 수 있다.<br>
닉네임 아래의 빨간색 선엔 구글 계정이 나와있다.<br>

* 회원정보수정
  ![캡처](https://github.com/user-attachments/assets/0fbf4f19-8153-4dbb-9486-fe9acade3133)<br>
  

