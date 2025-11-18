# my_package/todo_module.py

#1
# 1. 시작 정수, 끝 정수를 받아 그 사이의 모든 정수의 합을 구해서 반환하는 함수를 구현(ex: 1, 20 => 1에서 20 사이의 모든 정수의 합계)

def sum_num(start_num:int=0, end_num:int=10) : 
    """
    Start 정수 ~ End정수 까지의 합을 계산하는 함수
    
    Args:
        start(int): 계산 범위의 시작 정수. default:0
        end(int): 계산 범위의 끝 정수. default:10
    Returns
        int : start ~ end 까지의 모든 정수들의 합계
    """
    sum = 0
    for i in range(start_num, end_num+1):
        sum += i
    return sum
# input_start_num = 0
# input_end_num = 0
input_start_num = input("시작 정수:")
input_end_num = input("끝 정수:")
if input_start_num.isdigit():
    input_start_num_int = int(input_start_num)
else:
    print("숫자를 입력하시오")
if input_end_num.isdigit():
    input_end_num_int = int(input_end_num)
else:
    print("숫자를 입력하시오")

print("sum:",sum_num(input_start_num_int,input_end_num_int))
# print("sum:",sum_num(input_end_num_int=20))

# print(f"합친 숫자는 {sum_num(input_end_num,input_end_num)}")

def gugudan(num):
    for i in range(1,10):
        print(f"{num} x {i}  = {num * i}")

input_gugudan_num = input("숫자:")
if input_gugudan_num.isdigit():
    input_gugudan_num_int = int(input_gugudan_num)
else:
    print("숫자를 입력하시오")
gugudan(input_gugudan_num_int)

# 4. 체질량 지수는 비만도를 나타내는 지수로 키가 a미터 이고 몸무게가 b kg일때 b/(a**2) 로 구한다.
# 체질량 지수가
# - 18.5 미만이면 저체중
# - 18.5이상 25미만이면 정상
# - 25이상이면 과체중
# - 30이상이면 비만으로 하는데
# 몸무게와 키를 매개변수로 받아 비만인지 과체중인지 반환하는 함수를 구현하시오.
import math
bmi_num = 0
def bmi(a, b) -> tuple[float, str]:
    bmi_num = b/(a**2)
    # print("bmi_num : ",math.ceil(bmi_num))
    print("키:", a)
    print("키 타입:", type(a))
    print("몸무게:", b)
    print("몸무게 타입:", type(b))
    print("bmi_num : ",round(bmi_num,3))
    if bmi_num < 18.5:
        return bmi_num, "저체중"
    elif bmi_num >= 18.5 and bmi_num < 25: # elif라서 elif mi_num < 25: 만 해도됨
        return bmi_num, "정상"
    elif bmi_num >= 25 and bmi_num < 30:
        return bmi_num, "과체중"
    elif bmi_num >= 30:
        return bmi_num, "비만"

print(bmi(1.71, 78))
# input_height_num = input("키(미터):")
# # input_height_num2 = 0
# if input_height_num.isdigit():
#     input_height_num2 = float(input_height_num)
# else:
#     print("숫자를 입력하시오")

# input_weight_num = input("몸무게:")
# # input_weight_num2 = 0
# if input_weight_num.isdigit():
#     input_weight_num2 = float(input_weight_num)
# else:
#     print("숫자를 입력하시오")

# bmi(input_height_num2, input_weight_num2)


print(__name__)
if __name__ == "__main__":
    print("졸리다") # 메인모듈일 때만 실행

