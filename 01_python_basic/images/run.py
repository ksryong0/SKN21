import my_module #my_module을 실행
# my_package 모듈안에 있는 todo_module을 실행
# import my_package.todo_module as todo # my_package.todo_module 이름을 todo로 할게. 이제 todo로만 써야됨
from my_package import todo_module as todo
from my_module import plus # 내가 쓸 함수만 import

# r = my_module.minus(20,160) #my_module.함수()   my_module에서 정의한 함수를 호출하겠다.
# print(r)

# print(todo.gugudan(5))
# plus(100,200)
