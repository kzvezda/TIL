# 다중 선형 회귀 (Multiple Linear Regression) & 원핫인코딩

---

## 1. 개념

### 다중 선형 회귀 (Multiple Linear Regression)

* 정의: 독립 변수($X$)가 2개 이상일 때, 데이터를 가장 잘 설명하는 최적의 평면(초평면)을 찾는 방법

* 공식:
 공식: Y = W1X1 + W2X2 + ... + WnXn + b

* 구성 요소

  * $W$ (Weight): 각 변수의 영향력 (기울기)
  * $b$ (Bias): 모든 입력이 0일 때의 기본값

---

### 원핫인코딩 (One-Hot Encoding)

* 정의: 문자열/범주형 데이터를 0과 1로 이루어진 여러 개의 열로 변환하는 방법
* 이유: 머신러닝 모델은 문자열을 직접 처리할 수 없기 때문

예:

```id="1u3w3u"
Region = Seoul → [0, 1]
Region = Busan → [0, 0]
Region = Incheon → [1, 0]
```

---

### 목적

여러 변수를 동시에 고려하여 실제값($y$)과 예측값($\hat{y}$)의 오차를 최소화

---

## 2. 전체 코드 흐름

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

data = {
    'Size': [25, 32, 18, 45, 28, 30, 22, 35, 40, 27],
    'Rooms': [2, 3, 1, 4, 2, 3, 1, 3, 4, 2],
    'Region': ['Seoul', 'Busan', 'Seoul', 'Incheon', 'Busan', 
               'Seoul', 'Incheon', 'Busan', 'Incheon', 'Seoul'],
    'Price': [500, 450, 300, 700, 410, 550, 320, 490, 620, 510]
}

df = pd.DataFrame(data)

df_encoded = pd.get_dummies(df, columns=['Region'], drop_first=True, dtype=int)

X = df_encoded.drop(columns=['Price'])
y = df_encoded['Price']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=0
)

model = LinearRegression()
model.fit(X_train, y_train)

print("계수:", model.coef_)
print("절편:", model.intercept_)
```

---

## 3. 새로운 데이터 예측

```python
new_data = pd.DataFrame([[32, 3, 0, 1]], columns=X.columns)
pred = model.predict(new_data)

print(f"예측 가격: {pred[0]:.2f}만 원")
```

* 학습 데이터와 동일한 컬럼 구조 유지 필요
* 원핫인코딩 결과를 정확히 반영해야 함

---

## 4. 모델 성능 평가

```python
y_pred = model.predict(X_test)

mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"MSE: {mse:.2f}")
print(f"R2: {r2:.4f}")
```

---

### 수정된 결정계수 (Adjusted R²)

```python
n = X_test.shape[0]
p = X_test.shape[1]

adj_r2 = 1 - ((1 - r2) * (n - 1) / (n - p - 1))
print(f"Adjusted R2: {adj_r2:.4f}")
```

---

## 5. 평가 지표 해석

### MSE (Mean Squared Error)

* 예측값과 실제값 차이의 제곱 평균
* 값이 작을수록 좋음

### R² (결정계수)

* 모델 설명력 (0 ~ 1)
* 1에 가까울수록 좋음

### Adjusted R²

* 변수 개수 증가에 대한 패널티 적용
* 다중 회귀에서 중요한 지표

---

## 6. 유의 사항

### 다중공선성 (Dummy Variable Trap)

* 원핫인코딩 시 모든 범주를 사용하면 문제 발생
* 해결: drop_first=True

### 새로운 데이터 예측

* 학습 데이터와 동일한 컬럼 구조 유지
* 컬럼 순서와 개수 중요

### 데이터 수

* 데이터가 적으면 계수 왜곡 가능
* 충분한 데이터 확보 필요

---

## 7. 시각화 및 분석

### 예측값 vs 실제값

```python
import matplotlib.pyplot as plt

plt.scatter(y_test, y_pred)
plt.xlabel("Actual")
plt.ylabel("Predicted")
plt.title("Actual vs Predicted")
plt.show()
```

---

### 잔차 분석 (Residual Plot)

```python
residuals = y_test - y_pred

plt.scatter(y_pred, residuals)
plt.axhline(y=0, linestyle='--')
plt.xlabel("Predicted")
plt.ylabel("Residuals")
plt.title("Residual Plot")
plt.show()
```

* 잔차가 0을 중심으로 랜덤하게 퍼지면 좋은 모델
