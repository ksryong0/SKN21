from langchain_mcp_adapters.client import MultiServerMCPClient
from langchain_openai import ChatOpenAI

from langchain.agents import create_agent
from dotenv import load_dotenv
import asyncio

load_dotenv()

async def main():
    # 1. MCP Client 생성 : 연결할 서버정보를 제공(실행)
    client = MultiServerMCPClient(
        {
            "time": {
                "transport":"stdio", # 통신방식
                "command": "python", 
                "args": ["-m", "mcp_server_time"] # command + args 실행: python -m mcp_server_time 서버를 실행하고 연결
            }
        }
    )
    # MCP Client로부터 tool들을 가져오기.
    tools = await client.get_tools()

    # tools : list[StructuredTool-Langchain Tool 타입] 
    # - MCP 서버의 툴들을 langchain에서 사용할 수 있게 만들어서 반환.

    agent = create_agent(
        model=ChatOpenAI(model="gpt-5.2"),
        tools=tools,
        system_prompt="""당신은 AI Assistant입니다. 필요한 경우 등록된 도구들을 이용해 질문에 답하세요. 답변은 한국어로 하세요."""
    )
    print(">>>> 종료 하려면 !quit을 입력하세요.<<<<")
    while True:
        query = input("질문:")
        if query == "!quit":
            print(">>>> 종료 <<<<")
            break
        res = await agent.ainvoke({
            "messages": [
                ("human", query)
            ]
        })
        print(res['messages'][-1].content)

if __name__ == "__main__":
    asyncio.run(main())

