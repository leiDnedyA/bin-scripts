#!/bin/python3
import requests

url = 'https://news.ycombinator.com/'  # Replace with your desired URL
target_domains = [
    'theatlantic.com',
    'washingtonpost.com',
    'nytimes.com',
    'chronicle.com',
    'wired.com',
]

response = requests.get(url)

html = None

if response.status_code == 200:
    html = response.text
else:
    print(f"Failed to retrieve the webpage. Status code: {response.status_code}")
    exit(1)

for domain in target_domains:
    if domain in html:
        print(domain + ' Found!')
