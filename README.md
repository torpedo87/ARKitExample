#  ARKit
- Integrate iOS device camera and motion features to produce augmented reality experiences in your app or game.
- A9 프로세서 이상을 요구하므로 아이폰 6s 이후의 기기부터 가능
- tracking + scene understanding + rendering
- AR app template 을 사용하여 프로젝트를 생성하면 자동으로 art.scnassets 폴더가 생성되어 있다 (3D asset)
- .scn 파일은 scene 관련 파일이다. 클릭하면 scene editor 가 나온다. 유니티의 scene 파일을 접해봤다면 친숙할 것이다



## SceneKit
- 3D renderer framework
- Create 3D games and add 3D content to apps using high-level scene descriptions. Easily add animations, physics simulation, particle effects, and realistic physically based rendering.
- SceneKit Scene Editor 를 제공하여 scene 속성을 쉽게 변경하는 것을 도와준다
- SCNNode : A structural element of a scene graph, representing a position and transform in a 3D coordinate space, to which you can attach geometry, lights, cameras, or other displayable content.
- hitTest : Searches for real-world objects or AR anchors in the captured camera image corresponding to a point in the SceneKit view.
- pointOfView: sceneView의 point of view


## 3D model import 
- 다운로드한 3d 모델파일을 art.scnassets 폴더에 넣기
- 3d 모델 포맷의 파일 선택해서 .scn 으로 convert 하기 (Editro 메뉴 - convert ......)


## AR template configuration
- ARSCNView : A view for displaying AR experiences that augment the camera view with 3D SceneKit content.
- plist : camera authrization for privacy
- 디폴트값으로 스토리보드 컨트롤러에 ARSCNView 가 베이스 뷰로 되어있다. User Interaction을 하기 위해서는 베이스뷰를 UIView로 해줘야한다 따라서 기존의 SCNView를 지우고 UIView를 베이스로 올리고 그 위에 다시 ARSCNView를 올리는 것이 좋다

