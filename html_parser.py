from urllib.request import urlopen
from bs4 import BeautifulSoup
import sys


def search(word):
    response = urlopen("https://en.oxforddictionaries.com/definition/"+word)
    html = response.read()
    soup = BeautifulSoup(html, "lxml")
    search_results = (soup.find("span", class_="phoneticspelling").__str__())
    # print (search_results)
    if search_results in "None":
        return None

    result = search_results[search_results.find(
        '">')+2:search_results.find("</")]
    return result


if __name__ == "__main__":
    # print(sys.argv)
    if "--" in sys.argv:
        while True:
            sys.stdout.write(">>> ")
            what=input()
            if input=="--":
                break
            print(search(what))
    if len(sys.argv):
        iterargs = iter(sys.argv)
        next(iterargs)
        for arg in iterargs:
            # print(arg)
            result = search(arg)
            if result.__str__() in "None":
                print("There's no such thing as", arg)
                continue
            print(arg + " " + result)
    else:
        lines = []
        for line in sys.stdin:
            stripped = line.strip()
            if not stripped:
                break
            lines.append(line.strip('\n'))

        for line in lines:
            # print(line)
            res = search(line)
            if res.__str__() in None:
                print(line, "-")
                continue
            print(line, res, "-")
            # print(line + " " + res)
