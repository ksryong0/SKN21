import requests
from bs4 import BeautifulSoup

# 크롤링할 깃허브 사용자 ID
github_id = 'SKNETWORKS-FAMILY-AICAMP'
url = f'https://github.com/orgs/SKNETWORKS-FAMILY-AICAMP/repositories'

try:
    # 웹페이지 HTML 가져오기
    response = requests.get(url)
    response.raise_for_status() # 요청 오류가 있으면 예외 발생

    # HTML 파싱
    soup = BeautifulSoup(response.text, 'html.parser')

    # 저장소 제목이 있는 요소 선택 (예시: <a> 태그의 `href` 속성을 이용)
    # 실제 HTML 구조에 맞게 태그와 선택자를 변경해야 합니다.
    repo_elements = soup.select('h3 a') # 예: <h3> 안에 있는 <a> 태그
    # repo_elements = soup.find('repos-list-description') # 예: <h3> 안에 있는 <a> 태그


    # 제목 추출 및 출력
    print(f"{github_id}님의 저장소 목록:")
    for element in repo_elements:
        title = element.get_text(strip=True)
        print(f"- {title}")

except requests.exceptions.RequestException as e:
    print(f"페이지를 가져오는 중 오류가 발생했습니다: {e}")
except Exception as e:
    print(f"처리 중 오류가 발생했습니다: {e}")

# import requests
# from bs4 import BeautifulSoup

# def get_github_repo_descriptions(username):
#     """
#     지정된 GitHub 사용자의 모든 레포지토리와 설명을 크롤링합니다.
#     """
    
#     url = f"https://github.com/orgs/{username}/repositories"
    
#     try:
#         # HTTP GET 요청 보내기
#         response = requests.get(url)
#         response.raise_for_status()  # 요청이 성공했는지 확인
        
#         # HTML 파싱
#         soup = BeautifulSoup(response.text, 'html.parser')
        
#         # 레포지토리 목록을 담고 있는 CSS 셀렉터 찾기
#         # GitHub UI 업데이트에 따라 셀렉터가 변경될 수 있습니다.
#         repositories = soup.select('#user-repositories-list li')
        
#         if not repositories:
#             print(f"사용자 '{username}'의 레포지토리를 찾을 수 없습니다.")
#             return
            
#         repo_data = []
        
#         for repo in repositories:
#             # 레포지토리 이름 추출
#             name_tag = repo.select_one('h3 a')
#             if name_tag:
#                 repo_name = name_tag.text.strip()
#             else:
#                 continue

#             # 레포지토리 설명 추출
#             # `p` 태그 중 `color-fg-muted` 클래스를 가진 요소를 찾습니다.
#             description_tag = repo.select_one('p.color-fg-muted')
            
#             # 설명이 없는 경우 처리
#             if description_tag:
#                 description = description_tag.text.strip()
#             else:
#                 description = "설명 없음"
            
#             repo_data.append({
#                 'name': repo_name,
#                 'description': description
#             })
            
#         return repo_data

#     except requests.exceptions.RequestException as e:
#         print(f"오류가 발생했습니다: {e}")
#         return None

# # 함수 실행 예시
# github_username = "SKNETWORKS-FAMILY-AICAMP"  # 본인의 깃허브 아이디로 교체하세요.
# repos = get_github_repo_descriptions(github_username)

# if repos:
#     for repo in repos:
#         print(f"레포지토리: {repo['name']}")
#         print(f"설명: {repo['description']}\n")