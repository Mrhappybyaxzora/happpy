import requests
from bs4 import BeautifulSoup
from happy.logging import Logger
from functools import cache

l = Logger(__file__)


@cache
def wopen(app):
    sess = requests.Session()
    def extract_links(html):
        if html is None:
            return []
        soup = BeautifulSoup(html, 'html.parser')
        # Try to find all external links
        links = []
        for a in soup.find_all('a', href=True):
            href = a['href']
            if href.startswith('http') and not href.startswith('https://www.google.com'):  # skip Google internal links
                links.append(href)
        return links

    def search_google(query):
        url = f"https://www.google.com/search?q={query}"
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"}
        response = sess.get(url, headers=headers)

        if response.status_code == 200:
            return response.text
        else:
            print("Failed to retrieve search results.")
            l.error(response.status_code)
        return None

    # Fallbacks for well-known apps
    official_urls = {
        'facebook': 'https://facebook.com',
        'instagram': 'https://instagram.com',
        'twitter': 'https://twitter.com',
        'x': 'https://x.com',
        'youtube': 'https://youtube.com',
        'linkedin': 'https://linkedin.com',
        'whatsapp': 'https://web.whatsapp.com',
        'reddit': 'https://reddit.com',
        'tiktok': 'https://tiktok.com',
        'snapchat': 'https://snapchat.com',
        'gmail': 'https://mail.google.com',
        'google': 'https://google.com',
    }

    app_lower = app.strip().lower()
    if app_lower in official_urls:
        return official_urls[app_lower]

    html = search_google(app)
    links = extract_links(html) if html else []
    if links:
        return links[0]
    # Try fallback for known apps if not matched above
    for key, url in official_urls.items():
        if key in app_lower:
            return url
    return "/sorry"
if __name__ == "__main__":
    print(wopen("google"))