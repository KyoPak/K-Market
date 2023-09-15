# K-Market ReadME

- User가 상품을 등록하고 수정하고 삭제할 수 있는 거래 App입니다.
- 상품 등록 당시의 User의 위치를 저장하고 다른 User에게 보여줍니다.
- Clean Architecture을 도입한 만큼 Unit Test에 집중하였습니다.

Refactoring 전 프로젝트가 보고 싶으시면 아래 링크를 눌러주세요.

[OpenMarket](https://github.com/KyoPak/Open-Market)

## 목차
1. [실행 화면](#실행-화면)
2. [폴더 구조](#폴더-구조)
3. [타임라인](#타임라인)
4. [기술적 도전](#기술적-도전)
5. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)

## 실행 화면

|Main|Banner|상품위치|
|:---:|:--:|:--:|
|<img width = "300px" img src= "https://user-images.githubusercontent.com/59204352/228113115-947ada98-ea54-46b1-99df-0379c32601ca.gif">|<img width = "300px" img src= "https://user-images.githubusercontent.com/59204352/228112728-16868ae6-2617-4f32-8cbc-1f0282a86d2f.gif">|<img width = "300px" img src= "https://i.imgur.com/XXlZTc5.jpg" >|


|등록  |수정  |삭제 |
|:---:|:--:|:--:|
|![](https://i.imgur.com/Ctghd9g.gif)|![](https://i.imgur.com/gyaNrkR.gif)|![](https://i.imgur.com/fvDvIBb.gif)|


## 폴더 구조

<details>
<summary> 
펼쳐보기
</summary>

```
K-Market
├── K-Market
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   ├── GoogleService-Info.plist
│   │   └── Info.plist
│   └── Source
│       ├── Application
│       │   ├── AppDelegate.swift
│       │   └── SceneDelegate.swift
│       ├── Coordinator
│       │   ├── AddCoordinator.swift
│       │   ├── Coordinator.swift
│       │   ├── DetailCoordinator.swift
│       │   ├── EditCoordinator.swift
│       │   └── ListCoordinator.swift
│       ├── DIContainer
│       │   ├── SceneDIContainer.swift
│       │   └── ServiceDIContainer.swift
│       ├── Data
│       │   ├── ImageTemporaryStorage
│       │   │   └── CacheService.swift
│       │   ├── LocationStorage
│       │   │   └── FireBaseService.swift
│       │   ├── ProductStorage
│       │   │   ├── Infra
│       │   │   │   ├── HTTPMethod.swift
│       │   │   │   ├── Request
│       │   │   │   │   ├── CustomRequest.swift
│       │   │   │   │   ├── DeleteDataRequest.swift
│       │   │   │   │   ├── DeleteURIRequest.swift
│       │   │   │   │   ├── EditPatchRequest.swift
│       │   │   │   │   ├── FetchDetailRequest.swift
│       │   │   │   │   ├── FetchListRequest.swift
│       │   │   │   │   ├── LoadImageRequest.swift
│       │   │   │   │   └── PostDataRequest.swift
│       │   │   │   └── Util
│       │   │   │       └── Extension
│       │   │   │           ├── Data+Extension.swift
│       │   │   │           ├── URLComponents+Extension.swift
│       │   │   │           └── URLRequest+Extension.swift
│       │   │   └── NetworkService.swift
│       │   └── Repository
│       │       ├── DefaultLocationRepository.swift
│       │       ├── DefaultProductRepository.swift
│       │       └── DefaultWrapperDataRepository.swift
│       ├── Domain
│       │   ├── Entity
│       │   │   ├── LocationData.swift
│       │   │   ├── PostProduct.swift
│       │   │   ├── PostResponse.swift
│       │   │   ├── Product.swift
│       │   │   ├── ProductPage.swift
│       │   │   ├── UniqueProduct.swift
│       │   │   └── WrapperData.swift
│       │   ├── RepositoryInterface
│       │   │   ├── LocationRepository.swift
│       │   │   ├── ProductRepository.swift
│       │   │   └── WrapperDataRepository.swift
│       │   ├── Translator
│       │   │   └── DecodeManager.swift
│       │   └── UseCase
│       │       ├── CheckWrapperDataUseCase.swift
│       │       ├── DeleteLocationUseCase.swift
│       │       ├── DeleteProductUseCase.swift
│       │       ├── FetchLocationUseCase.swift
│       │       ├── FetchProductDetailUseCase.swift
│       │       ├── FetchProductListUseCase.swift
│       │       ├── LoadImageUseCase.swift
│       │       ├── PatchProductUseCase.swift
│       │       ├── PostLocationUseCase.swift
│       │       ├── PostProductUseCase.swift
│       │       └── Protocol
│       │           └── Fetchable.swift
│       ├── Present
│       │   ├── AddScene
│       │   │   ├── View
│       │   │   │   ├── AddView.swift
│       │   │   │   ├── AddViewController.swift
│       │   │   │   └── UploadImageCell.swift
│       │   │   └── ViewModel
│       │   │       └── AddViewModel.swift
│       │   ├── CommonUploadScene
│       │   │   ├── Cell
│       │   │   └── UploadView.swift
│       │   ├── DetailScene
│       │   │   ├── View
│       │   │   │   ├── Cell
│       │   │   │   │   └── DetailImageCell.swift
│       │   │   │   ├── DetailViewController.swift
│       │   │   │   └── ProductInfoView.swift
│       │   │   └── ViewModel
│       │   │       └── DetailViewModel.swift
│       │   ├── EditScene
│       │   │   ├── View
│       │   │   │   ├── EditView.swift
│       │   │   │   └── EditViewController.swift
│       │   │   └── ViewModel
│       │   │       └── EditViewModel.swift
│       │   └── MainScene
│       │       ├── View
│       │       │   ├── Cell
│       │       │   │   ├── BannerCollectionViewCell.swift
│       │       │   │   ├── CollectionCell.swift
│       │       │   │   ├── GridCollectionViewCell.swift
│       │       │   │   └── ListCollectionViewCell.swift
│       │       │   ├── HeaderView.swift
│       │       │   ├── ListViewController.swift
│       │       │   └── SectionHeaderView.swift
│       │       └── ViewModel
│       │           ├── ListViewModel.swift
│       │           └── ProductCellViewModel.swift
│       └── Util
│           ├── Error
│           │   └── NetworkError.swift
│           ├── Extension
│           │   ├── Formatter+Extension.swift
│           │   ├── UIImage+Extension.swift
│           │   ├── UILabel+Extension.swift
│           │   ├── UIStackView+Extension.swift
│           │   └── UITextField+Extension.swift
│           ├── Protocol
│           │   ├── AlertPresentable.swift
│           │   └── UseIdentifiable.swift
│           └── Type
│               └── Observabel.swift
└── K-MarketTests
	├── Data
	│   ├── Mock
	│   │   └── MockNetwork.swift
	│   ├── NetworkServiceTest.swift
	│   ├── ProductRepositoryTest.swift
	│   └── WrapperDataRepositoryTest.swift
	├── Domain
	│   ├── DeleteLocationUseCaseTest.swift
	│   ├── FetchLocationUseCaseTest.swift
	│   ├── Mock
	│   │   └── MockLocationRepository.swift
	│   └── PostLocationUseCaseTest.swift
	└── Present
	    ├── AddViewModelTest.swift
	    ├── DetailViewModelTest.swift
	    ├── EditViewModelTest.swift
	    ├── ListViewModelTest.swift
	    └── Mock
	       ├── MockUseCase.swift
	       └── StubProvider.swift
```
</details>

##  타임라인

<details>
<summary> 
펼쳐보기
</summary>

![](https://i.imgur.com/E32CiaK.png)
 
</details>



## 기술적 도전

### ⚙️ FireBase Remote DB 추가
<details>
<summary> 
펼쳐보기
</summary>

리팩토링 전 프로젝트에서는 아카데미에서 제공하는 서버만을 사용하였지만, 개인적으로 User의 상품 등록 시의 위치도 함께 저장하여 보여주는 새로운 기능을 구현하고 싶었습니다. 
때문에 상품ID와 User의 위치를 별도로 저장하기 위해 FireBase를 사용하였습니다.
    
</details>

### ⚙️ Banner View
<details>
<summary> 
펼쳐보기
</summary>

기존의 CollectionView 뿐만 아니라 Banner CollectionView를 구현하여 User에게 보여주고 싶었습니다.
현재는 최신 상품 5개를 User에게 추가적으로 표시해주지만, 추후에 User의 위치를 기반으로 상품들을 보여주는 기능으로 확장할 수 있다고 생각합니다.
    
Section에 따라서 다른 Layout이 적용되게끔 구현하였으며, Banner가 아닌 main Section에서는 segmentedControl이 list인지 grid인지에 따라서 Cell의 모양이 다르게 표시되게끔 구현하였습니다.


</details>

### ⚙️ DI Container
<details>
<summary> 
펼쳐보기
</summary>

다른 프로젝트에서 Coordinator Pattern을 사용하여 해당 `View`의 Coordinator에서 화면이동에 대한 책임과 이동할 `View`의 `ViewModel`에 UseCase를 생성하여 주입해주는 책임을 가지게끔 구현하였었습니다.
하지만 Coordinator에서 책임을 분리하여 화면 이동만을 담당하고, 의존성 주입은 DIContainer 객체가 담당하게끔 구현하고 싶었습니다.

DIContainer에서 `ViewModel`에서 필요한 UseCase, `UseCase`에서 필요한 Repository를 생성하여 주입해주다 보니 객체 간의 책임이 조금 더 명확해지고 분리되었다고 느껴졌습니다.
그리고 추후에 `CacheRepository`를 추가하였을 때도 코드가 크게 변경되는 일 없었고 이러한 경험을 바탕으로 확장성이 보다 향상되었다는 것을 느낄 수 있었습니다.
    
</details>

### ⚙️ ViewModel Input, Output 추상화
<details>
<summary> 
펼쳐보기
</summary>

`ViewModel`에서 Input과 Output에 대한 프로토콜을 정의하여 사용하였습니다. 
프로젝트를 하면서 직접적으로 느끼지는 못했지만 프로토콜을 Input과 Output으로 나눔으로서 SOLID의 SRP원칙을 보다 지킬 수 있었고, 추후에 ISP 원칙도 만족을 시킬 수 있을 것이라고 생각됩니다. 

Input과 Output으로 나누면서 `View`에서 `ViewModel`로 요청을 하는 메서드들의 종류가 명확하게 구분이 되면서 가독성이 향상되었다고 느껴졌습니다.
    
</details>


## 트러블 슈팅 및 고민


### 🔥 Layout 변경 시 반영이 안되는 문제 
    
<details>
<summary> 
펼쳐보기
</summary>
Layout을 list에서 Grid로 변경할 경우, list의 레이아웃 형태가 남아있는 오류가 발생하였습니다. Grid에서 List로 레이아웃을 변경한다면 Grid의 레이아웃의 형태가 남아있었습니다.
해당 오류를 2가지로 해결할 수 있었습니다. 

`reloadSection()`을 사용하는 방법과 `reloadData()`을 사용하는 방법이 있었습니다.

`reloadSection()`을 사용해본 결과 애니메이션 효과와 함께 정상적으로 레이아웃이 바뀔 수 있었습니다. 하지만 레이아웃이 바뀔 때, 애니메이션 효과가 오히려 부자연스러워 간단한 `reloadData()`로 해당 문제를 해결하였습니다.

(물론 `reloadSection()`에 애니메이션 효과를 false로 할 수 있었습니다.)

</details>

### 🔥 CollectionView Section 사용 시 정상적인 데이터가 보여지지 않는 경우 
    
<details>
<summary> 
펼쳐보기
</summary>
Banner에 전체 상품 중에서 최신 5개 상품이 추가적으로 나타나도록 구현했습니다. 
그 과정에서 Banner Section과 main Section에 중복된 상품Data가 표기되어 오류가 발생하였고 해당 오류의 원인은

`DiffableDataSource`의 Item이 Unique하지 않다는 오류였습니다.
따라서 기존의 Product를 `UniqueProduct`타입으로 감싸 Data의 중복에러를 해결할 수 있었습니다.

</details>

### 🔥 확장성있는 URLRequest 구현방법
<details>
<summary> 
펼쳐보기
</summary>

상황에 맞는 `URLRequest`를 구현하는 방식을 고민하였습니다. 기존에는 `enum`타입을 사용하여 분기처리를 거듭하며 `URLRequest`를 구성하였지만,
해당 방법은 새로운 `URLRequest`가 추가된다면 분기가 계속해서 늘어나 확장성이 떨어진다고 생각하였습니다.

그래서 `CustomRequest`라는 프로토콜을 정의하여 상황 별 모든 Request가 해당 프로토콜을 채택하게 한 후, 상황 별 Request를 모두 구현해주었습니다. 
새로운 URLRequest가 추가된다면 추가구현이 필요하지만, 리팩토링 전 enum으로 구현했을 때와 달리 기존의 코드를 수정하지 않아도 되어 확장성과 유지보수성이 높아진 느낌을 받을 수 있었습니다.

</details>
