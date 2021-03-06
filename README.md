# このアプリについて

## FingerSmashとは
FingerSmashとは親指をコールと共に上げ、その指を数を当てるゲーム"指スマ"の対戦アプリです。

## 概要
  アプリ名：FingerSmash

  使用言語：Ruby on Rails、JavaScript
  
  主な機能：自動再読み込み、ユーザー登録、ルーム、対戦、ランキング
  
  作業人数：1人
  
  作業日数：10日間

## このアプリを作ろうと思ったきっかけ
プログラミング勉強を初めて1ヶ月。TECH::EXPERTのカリキュラムが終わり、個人アプリの開発期間に入った。
今まで習ったことで何か実装しようと考えた際に、人とは違うことをしてみたかった。
投稿系のアプリと違い、対戦系のアプリは難易度が高そうだったので、チャレンジしてみようと思った。

## 具体的な機能紹介
ユーザー登録機能以外は、わかりやすいように、あえて二画面(対戦形式の画面)で表示しています

### ・ユーザー登録

  deviseを用いて、ユーザー登録機能の実装を行った。
  ログインしていないユーザーはログインページに自動で飛ばされる。

<img width="400" alt="スクリーンショット 2019-12-02 12 51 03" src="https://user-images.githubusercontent.com/57092560/71316922-5c58da80-24bc-11ea-8734-ca95559fc68f.png">

### ・対戦ルーム

    一人のユーザーが対戦ルームの作成を行い、ルーム一覧がトップページに表示される。
    ユーザー好きなルームに入り、ルームオーナーが認めることで、試合が開始する。

<img width="400" alt="スクリーンショット 2019-12-02 12 53 33" src="https://user-images.githubusercontent.com/57092560/71316923-5c58da80-24bc-11ea-88ab-7b8fba307127.png">

### ・対戦機能⑴

    試合が開始すると、一人は攻撃、もう一人は防御ページに移行する。攻撃側は数字当ての入力欄が表示される。
    双方の入力が終わるまで、結果ページには推移しない。


<img width="400" alt="スクリーンショット 2019-12-02 12 53 45" src="https://user-images.githubusercontent.com/57092560/71316924-5cf17100-24bc-11ea-8e17-5d4b5755e0cf.png"><img width="300" alt="スクリーンショット 2019-12-02 12 54 10" src="https://user-images.githubusercontent.com/57092560/71316925-5cf17100-24bc-11ea-9192-595c330bc29f.png">

### ・対戦機能⑵

    結果で数字が当たると、そのユーザーは次のターンから片手になり、２勝すると勝ちページ、２敗すると負けページにそれぞれ移動する。

<img width="400" alt="スクリーンショット 2019-12-02 12 55 11" src="https://user-images.githubusercontent.com/57092560/71316926-5cf17100-24bc-11ea-9e74-bcabe1a6c059.png"><img width="400" alt="スクリーンショット 2019-12-02 12 55 33" src="https://user-images.githubusercontent.com/57092560/71316927-5cf17100-24bc-11ea-8f98-d7d33a196224.png">


### ・ランキング

    ユーザーの勝敗数と勝率をもとに、ランキングが表示される。

<img width="400" alt="スクリーンショット 2019-12-02 13 04 33" src="https://user-images.githubusercontent.com/57092560/71316928-5d8a0780-24bc-11ea-827d-3a43e2ee9c59.png">


## 工夫して実装した機能
見た目よりも、処理で差をつけたっかったので、コントローラーでの処理をこだわりました。

### ・オーナー&ビジター

グループの作成者をオーナー、グループに入ってきたユーザーをビジターと定義し
オーナーのみが、試合開始や次ページへの移行をできるようにすることで、不具合を起こりづらくした。

```controller.rb
@owner = @group.users[0]
@visiter = @group.users[1]
```

```index.html.haml
-if current_user.id == @owner.id
  = f.submit "試合開始" ,class: "group-start-btn"
```

### ・urlへのid付与
urlにidを３種類付与することで、条件分岐を行い対戦状況を把握する。
詳しくは、app/controller/turns_controller.rbのresultアクション内に記述してあります。

```controller.rb

コントローラー

if @total == @attack.call.to_i && @attack.user == @owner
  @result = "あたり"
  @turn_num_next = @turn_num + 101
elsif @total == @attack.call.to_i && @attack.user == @visiter
  @result = "あたり"
  @turn_num_next = @turn_num + 501
else
  @result = "はずれ"
  @turn_num_next = @turn_num + 1
end
```

```index.html.haml
ビュー

- if  @turn_num.to_i >= 1 && @turn_num.to_i <= 99
  .hands
    = render "left_finger"
    = render "right_finger"
  = render "attack_hand"
  = render "form"

- elsif @turn_num.to_i >= 101 && @turn_num.to_i <= 199 && @group.users[1] == current_user
  .hands
    = render "left_finger"
    = render "right_finger"
  = render "attack_hand"    
  = render "form"

- elsif @turn_num.to_i >= 101 && @turn_num.to_i <= 199 && @group.users[0] == current_user  
  .hands
    = render "left_finger"
  = render "attack_hand"    
  = render "form"

- elsif @turn_num.to_i >= 501 && @turn_num.to_i <= 599 && @group.users[1] == current_user
  .hands
    = render "left_finger"
  = render "attack_hand"    
  = render "form"

- elsif @turn_num.to_i >= 501 && @turn_num.to_i <= 599 && @group.users[0] == current_user
  .hands
    = render "left_finger"
    = render "right_finger"
  = render "attack_hand"    
  = render "form"

- elsif @turn_num.to_i >= 601 && @turn_num.to_i <= 700
  .hands
    = render "left_finger"
  = render "attack_hand"    
  = render "form"

```


