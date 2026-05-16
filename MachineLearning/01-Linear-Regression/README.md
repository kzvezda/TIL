# 단순 선형 회귀 (Simple Linear Regression)

### 1. 개념
* **정의**: 데이터들을 가장 잘 대변하는 최적의 직선 1개 찾기
* **공식**: $Y = WX + b$
  * $W$ (Weight): 기울기 (영향력)
  * $b$ (Bias): Y절편 (기본값)
* **목표**: 실제 정답($y$)과 예측값($\hat{y}$)의 오차(MSE)를 최소로 만드는 $W$, $b$ 구하기

---

### 2. 기본 구현 코드 (Scikit-Learn)

```python
import numpy as np  # 숫자 계산과 행렬(숫자 표)을 빠르게 처리해 주는 라이브러리
import matplotlib.pyplot as plt # 데이터 시각화(그래프) 라이브러리
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split # 데이터 분리 도구

# 1. 데이터 생성
X = np.array([[1], [2], [3], [4], [5], [6], [7], [8], [9], [10]])
y = np.array([15, 30, 50, 65, 85, 90, 95, 100, 105, 110])

# 2. 데이터 세트 분리
# Train Set (훈련용 데이터): 모델을 공부시킬 때 사용 (통상 70~80%)
# Test Set (시험용 데이터): 모델의 최종 실력을 평가할 때 사용 (통상 20~30%)
# ※ random_state=0는 재실행해도 똑같이 무작위 분리되도록 고정하는 값
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

# 3. 모델 생성 및 학습 (반드시 훈련 데이터 X_train만 넣어야 함!)
model = LinearRegression()
model.fit(X_train, y_train)

# 4. 결과 확인 (기울기와 절편)
print(model.coef_)       # W 값
print(model.intercept_)  # b 값

# 5. 새로운 데이터 예측 (6시간 공부 시)
# ※ 예측 데이터도 무조건 2차원 [[ ]] 형태여야 함
new_data = np.array([[6]])
pred = model.predict(new_data)
print(f"{pred:.2f}점") # [0]은 배열에서 순수 숫자 알맹이만 빼내는 용도

# 6. 데이터 시각화
plt.scatter(X_train, y_train, color='blue', label='Train Data') # 실제 데이터 점
plt.plot(X_train, model.predict(X_train), color='red', label='Regression Line') # 모델이 예측한 직선
plt.title('Study Hours vs Score') # 제목
plt.xlabel('Hours')               # X축 이름
plt.ylabel('Score')               # Y축 이름
plt.legend()                      # 설명 상자 표시
plt.show()                        # 그래프 출력
```

---

### 3. 유의 사항 (Trouble Shooting)
* **X 차원**: `LinearRegression`은 독립변수 `X`를 무조건 2차원 배열 형태로 받음. 안 맞으면 에러남. 예측할 때(`new_data`)도 마찬가지.
* **출력 구조**: `model.predict()` 결과는 무조건 `[85.5]`처럼 대괄호가 묶여서 나옴. 그래서 끝에 `` 붙여서 숫자만 꺼내야 깔끔함.
* **데이터 분리 이유**: 문제집(Train)과 시험 문제(Test)를 분리해서 모델의 실제 실력을 정확하게 검증하기 위함.
* **한계**: 데이터가 곡선 형태면 일반 선형 회귀로 해결 불가. 이때는 `PolynomialFeatures(degree=2)` 써서 다항 회귀로 차수 늘려야 함.
