
##################################################################
#  streamlit/01_streamlit_chat_exam.py
#  챗봇 대화 관련 위젯 

# 1. chat_input() : 사용자 입력을 받는 위젯
# 2. chat_message() : 메세지를 container(내용 창)에 입력하는 위젯.

# chat_input(): str
# - 사용자 입력을 받는 위젯.
# - 사용자가 입력한 내용은 엔터를 치면 반환되고, 입력폼에 작성된 글은 지워진다.
# - 코드가 어디에 위치하든지 상관없이 맨 아래에 위치한다.
# - 주요파라미터
#    - placeholder:str - 입력폼에 표시할 힌트
#    - key:str|int - 위젯의 고유 식별자
#    - max_chars: int - 최대 입력 글자수. None(default): 제한 없음
#    - on_submit: Callable - 엔터를 눌렀을 때(submit) 호출할 함수
# - https://docs.streamlit.io/develop/api-reference/chat/st.chat_input

# chat_message(name, *, avatar=None): Container
# - 메세지를 container(내용 창)에 입력하는 위젯.
# - 반환된 container에 write() 하거나 with 문을 이용해 write() 한다.
# - parameter
#    - name:str =  입력하는 메세지 작성자. ("assistant", "ai", "human", "user" or str)
#                       어시스턴트 = ai    human = user
#        - "assistant", "ai": 챗봇이 작성한 메세지, "human", "user": 사용자가 작성한 메세지
#    - avatar: str|st.image|None 
#        - 문자열, emoji, 이미지 등을 사용하여 아바타 이미지를 표현한다.
#        - 메세지 작성자를 표현하는 아바타 이미지.
#        - avatar=None 이면 name에 따라 결정된다. 
#              - name이 user, human, assistant, ai 일 경우 정해진 아이콘이 사용된다.
#              - name이 다른 문자열일 경우 첫번째 글자를 아바타로 사용한다.
#        - avatar 를 지정하면 지정한 avatar를 사용한다.
#              - 단 이름이 user, human, assistant, ai 일 경우 default avatar 가 나오고 그 뒤에 지정한 avatar가 나온다.
# - https://docs.streamlit.io/develop/api-reference/chat/st.chat_message

# st.session_state: 사용자의 상태를 저장하는 객체
#   - 페이지가 reload(rerun) 되더라도 유지 되야하는 값들을 저장하는 저장소 역할.
#       - 변수에 저장된 값은 rerun시 사라지게 된다. 그런데 rerun 후에도 그 값이 유지 되어야 하는 경우가 있다. 이런 값들을 저장하는 저장소.
#       - dictionary 형식으로 key=value 형태로 값을 저장한다.
#   - key 가 있는지 여부 확인
#       - in 연산자를 이용해 확인한다. `if "key" in st.session_state:` 형식으로 확인.
#   - 값 조회
#       - st.session_state.key 또는 st.session_state['key'] 를 이용해 조회한다.
#   - 값 저장
#       - st.session_state.key = value 또는 st.session_state['key'] = value 를 이용해 저장한다.
#       - 값을 저장하려는 key가 없으면 KeyError 발생한다. 그래서 미리 key를 생성해 놓고 사용해야 한다.
# 
#   - https://docs.streamlit.io/develop/api-reference/caching-and-state/st.session_state
##################################################################
import streamlit as st
import random
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_core.runnables import RunnablePassthrough
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
load_dotenv()

# 대화 기록을 저장할 히스토리 클래스 불러오기
chat_history = ChatMessageHistory()

chat = ChatOpenAI(model="gpt-4o")
prompt = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            """당신은 끝말잇기 게임을 진행하는 AI 챗봇입니다. 아래는 게임 규칙입니다. 당신과 user 의 입력에서 아래 규칙이 꼭 지켜져야 하며, 지키지 않은 사람에게 패배를 알린 뒤, 끝말잇기 게임을 종료합니다.
                1. 주어진 대화 기록에서 이미 나왔던 단어를 다시 말했을 경우 패배합니다.
                2. 두음법칙을 허용합니다. (ex. 리 -> 이, 력 -> 역, 락 -> 낙)
                3. 국어사전에 존재하는 단어이자, 명사여야 합니다.
            """,
        ),
        ("placeholder", "{chat_history}"),
        ("user", "{input}"),
    ]
)

chain = prompt | chat

chain_with_message_history = RunnableWithMessageHistory(
    chain,
    lambda session_id: chat_history,
    input_messages_key="input",
    history_messages_key="chat_history",
)

# chat_history.messages
def summarize_messages(chain_input):
    stored_messages = chat_history.messages
    if len(stored_messages) == 0:
        return False
    summarization_prompt = ChatPromptTemplate.from_messages(
        [
            ("placeholder", "{chat_history}"),
            (
                "user",
                "위 채팅 메시지는 끝말잇기 게임을 진행한 대화내용입니다. 언급한 단어들만 나열하여 저장해주세요.",
            ),
        ]
    )
    summarization_chain = summarization_prompt | chat
    # chat_history 에 저장된 대화 기록을 요약프롬프트에 입력 & 결과 저장
    summary_message = summarization_chain.invoke({"chat_history": stored_messages})
    # chat_history 에 저장되어있던 기록 지우기
    chat_history.clear()
    # 생성된 새로운 요약내용으로 기록 채우기
    chat_history.add_message(summary_message)
    return True


chain_with_summarization = (
    RunnablePassthrough.assign(messages_summarized=summarize_messages)
    | chain_with_message_history
)

# 대화 내역을 저장할 session state 를 생성
if "chat_history" not in st.session_state:
    st.session_state['chat_history'] = []

st.title("Chatbot 위젯 튜토리얼")
prompt = st.chat_input("User:")

if prompt: # 글이 입력되었다면 prompt와 ai 응답을 화면에 출력
    # container = st.chat_message('user')
    # container.write("ssssss")
    # 사용자 질문 추가
    st.session_state['chat_history'].append(
        {"role":"user", "content":prompt}
    )
    # AI 응답을 추가
    ai_message = chain_with_summarization.invoke(
        {"input": prompt},
        {"configurable": {"session_id": "unused"}}
    )
    st.session_state['chat_history'].append(
        {"role":"ai", "content": ai_message.content}
    )

# 대화내역 출력 - chat_history의 모든 내역을 출력
for chat_dict in st.session_state['chat_history']:
    with st.chat_message(chat_dict['role']):
        st.write(chat_dict["content"])

# uv pip install streamlit
# cd streamlit
# 실행: uv run streamlit run 01_streamlit_chat_exam.py
