# 다중 선형 회귀 (Multiple Linear Regression) & 원핫인코딩

## 1. 개념
* **정의**: 독립 변수($X$)가 **2개 이상**일 때, 데이터들을 가장 잘 대변하는 최적의 초평면(데이터 공간) 찾기
* **공식**: $Y = W_1X_1 + W_2X_2 + \dots + W_nX_n + b$
  * $W$ (Weight): 각 독립 변수의 기울기 (해당 변수가 결과에 미치는 영향력)
  * $b$ (Bias): Y절편 (모든 $X$가 0일 때의 기본값)
* **원핫인코딩 (One-Hot Encoding)**: 문자열 or 범주형 데이터(ex. 지역, 성별)를 모델이 인식할 수 있도록 0과 1로만 이루어진 여러 개의 열로 변환하는 기법
* **목적**: 수치형 데이터와 범주형 데이터를 모두 포함한 여러 요인을 동시에 고려하여 실제 정답($y$)과 예측값($\hat{y}$)의 오차(MSE)를 최소로 만들기

## 2. 기본 구현 코드 (Scikit-Learn)
```python
import pandas as pd # 데이터프레임(엑셀 형태 표)을 다루는 라이브러리
from sklearn.model_selection import train_test_split # 데이터 분리 도구
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score # 평가 지표 도구

# 1. 범주형 변수가 포함된 데이터 생성
data = {
    'Size': [25, 32, 18, 45, 28, 30, 22, 35, 40, 27],        # 수치형 1 (방 크기)
    'Rooms': [2, 3, 1, 4, 2, 3, 1, 3, 4, 2],                 # 수치형 2 (방 개수)
    'Region': ['Seoul', 'Busan', 'Seoul', 'Incheon', 'Busan', 
               'Seoul', 'Incheon', 'Busan', 'Incheon', 'Seoul'], # 범주형 (지역)
    'Price': [500, 450, 300, 700, 410, 550, 320, 490, 620, 510] # 타겟 Y (가격)
}
df = pd.DataFrame(data)

# 2. 원핫인코딩 적용 (문자 데이터를 0과 1로 변환)
# ※ drop_first=True는 다중공선성(Dummy Variable Trap)을 막기 위해 첫 번째 범주를 삭제함
# ※ dtype=int는 True/False 대신 1/0으로 깔끔하게 출력하기 위함
df_encoded = pd.get_dummies(df, columns=['Region'], drop_first=True, dtype=int)

# 3. 독립변수(X)와 종속변수(y) 분리
X = df_encoded.drop(columns=['Price']) # Price 열만 제외하고 전부 X로 사용
y = df_encoded['Price']                # Price 열을 y로 사용

# 4. 데이터 세트 분리 (훈련용 80%, 시험용 20%)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

# 5. 모델 생성 및 학습
model = LinearRegression()
model.fit(X_train, y_train)

# 6. 결과 확인 (각 변수별 기울기 W들과 절편 b)
print("각 변수의 기울기(W):", model.coef_)       # X의 컬럼 순서대로 W값들이 리스트로 출력됨
print("Y 절편(b):", model.intercept_)           # 모든 X가 0일 때의 가격(기본값)

# 7. 새로운 데이터 예측 (크기 32, 방 3개, 지역은 Seoul일 때)
# ※ 원핫인코딩으로 인해 Region_Incheon, Region_Seoul 열이 생성됨 (Busan은 drop됨)
# ※ Seoul을 표현하려면 Region_Incheon=0, Region_Seoul=1로 입력해야 함
new_data = pd.DataFrame([[32, 3, 0, 1]], columns=X.columns)
pred = model.predict(new_data)
print(f"예측 가격: {pred[0]:.2f}만 원") # [0]으로 감싸인 값을 숫자 알맹이로 꺼내기

# 8. 모델 평가 지표 확인
y_pred = model.predict(X_test)
r2 = r2_score(y_test, y_pred) # 결정계수 (R²)

# 수정된 결정계수(Adjusted R²) 계산: 다중회귀 분석에서는 무조건 이 지표를 봐야 함
n = X_test.shape[0] # 데이터 개수
p = X_test.shape[1] # 독립변수 개수
adj_r2 = 1 - ((1 - r2) * (n - 1) / (n - p - 1))

print(f"MSE 오차: {mean_squared_error(y_test, y_pred):.2f}")
print(f"수정된 결정계수(Adjusted R²): {adj_r2:.4f}")
```

## 3. 유의 사항 (Trouble Shooting)
* **다중공선성 함정 (Dummy Variable Trap)**: 원핫인코딩을 할 때 범주 개수 그대로 열을 만들면 변수들끼리 완벽한 상관관계가 생겨 모델이 망가짐. 반드시 `drop_first=True` 옵션을 주어 **(범주 개수 - 1)**개의 열만 사용해야 함.
* **수정된 결정계수(Adjusted $R^2$) 필수**: 다중회귀에서는 아무 의미 없는 무작위 변수를 추가해도 일반 $R^2$ 값은 무조건 올라감. 따라서 변수의 개수가 늘어날 때 패널티를 부여하는 **Adjusted $R^2$** 지표를 최종 모델 성능으로 판정해야 함.
* **새로운 데이터 예측 시 주의**: 모델을 학습시킬 때 썼던 `X_train`과 **완벽히 동일한 컬럼 구조(개수와 순서)**를 가진 채로 `predict()`에 데이터를 집어넣어야 함. 원핫인코딩으로 바뀐 컬럼 구조를 정확히 파악해야 에러가 안 남.
* **시각화의 한계**: 독립변수가 1개였던 단순선형회귀와 달리, 다중선형회귀는 독립변수가 여러 개(3차원 이상)이므로 2차원 평면에 하나의 직선 그래프로 시각화하기가 어려움. 대신 예측값과 실제값의 차이를 나타내는 **잔차 분석(Residual Plot) 그래프**를 주로 활용함.
