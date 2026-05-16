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
import numpy as np  # 숫자 계산과 행렬(숫자 표)을 빠르게 처리해 주는 대중적인 라이브러리
from sklearn.linear_model import LinearRegression

# 1. 데이터 생성 (X는 무조건 2차원 [[ ]] 형태여야 함)
X = np.array([[1], [2], [3], [4], [5]])
y = np.array([15, 30, 50, 65, 85])

# 2. 모델 생성 및 학습
model = LinearRegression()
model.fit(X, y)

# 3. 결과 확인 (기울기와 절편)
print(model.coef_)       # W 값
print(model.intercept_)  # b 값

# 4. 새로운 데이터 예측 (6시간 공부 시)
new_data = np.array([[6]])
pred = model.predict(new_data)

print(f"{pred:.2f}점") # [0]은 배열에서 순수 숫자 알맹이만 빼내는 용도
```

---

### 3. 유의 사항 (Trouble Shooting)
* **X 차원**: `LinearRegression`은 독립변수 `X`를 무조건 2차원 배열 형태로 받음. 안 맞으면 에러남.
* **출력 구조**: `model.predict()` 결과는 무조건 `[85.5]`처럼 대괄호가 묶여서 나옴. 그래서 끝에 `` 붙여서 숫자만 꺼내야 깔끔함.
* **한계**: 데이터가 곡선 형태면 일반 선형 회귀로 해결 불가. 이때는 `PolynomialFeatures(degree=2)` 써서 다항 회귀로 차수 늘려야 함.
